# Infrastructure as Code Outline

> This outline describes what is Infrastructure-as-Code (IAC) and its tools.

## Table of Content

* [What is Infrastructure-as-Code (IAC)](#what-is-infrastructure-as-code-iac)
* [The Problems IaC Tools Can Solve](#the-problems-iac-tools-can-solve)
* [Benefits](#benefits)
* [Infrastructure-as-Code Tools](#infrastructure-as-code-tools)
  * [Configuration Management vs Provisioning Tools](#configuration-management-vs-provisioning-tools)
  * [Procedural vs Declarative](#procedural-vs-declarative)
  * [Master vs Masterless](#master-vs-masterless)
  * [Agent vs Agentless](#agent-vs-agentless)
  * [Using Multiple Tools Together](#using-multiple-tools-together)
    * [Provisioning plus Configuration Management](#provisioning-plus-configuration-management)
    * [Provisioning plus Server Templating](#provisioning-plus-server-templating)
    * [Provisioning plus Server Templating plus Orchestration](#provisioning-plus-server-templating-plus-orchestration)
* [Best Practices to Get the Most out of IaC](#best-practices-to-get-the-most-out-of-iac)
* [References](#references)

***

## What is Infrastructure-as-Code (IAC)

A long time ago, in a data center far, far away, an ancient group of powerful beings known as sysadmins used to deploy infrastructure manually. Every server, every route table entry, every database configuration, and every load balancer was created and managed by hand. It was a dark and fearful age: fear of downtime, fear of accidental misconfiguration, fear of slow and fragile deployments, and fear of what would happen if the sysadmins fell to the dark side (i.e. took a vacation). The good news is that thanks to the DevOps Rebel Alliance, we now have a better way to do things: Infrastructure-as-Code (IAC).

Instead of clicking around a web UI or SSHing to a server and manually executing commands, the idea behind IAC is to write code to define, provision, and manage your infrastructure.

***

## The Problems IaC Tools Can Solve

* Create, change or destroy infrastructure resources such as compute, storage, networking components or platform services like database, Kubernetes cluster etc.
* Deploy, update applications on top of the infrastructure.
* Manage the configurations used by the applications.

***

## Benefits

* Automate your entire provisioning and deployment process, which makes it much faster and more reliable than any manual process.
* Represent the state of your infrastructure in source files that anyone can read rather than in a sysadmin’s head.
* You can store those source files in version control, which means the entire history of your infrastructure is now captured in the commit log, which you can use to debug problems, and if necessary, roll back to older versions.
* You can validate each infrastructure change through code reviews and automated tests.
* IAC: it makes developers happy. Deploying code is a repetitive and tedious task. A computer can do that sort of thing quickly and reliably, but a human will be slow and error prone.
* IAC offers a better alternative that allows computers to do what they do best (automation) and developers to do what they do best (coding).

***

## Infrastructure-as-Code Tools

* Chef
* Puppet
* Ansible
* SaltStack
* CloudFormation (for AWS only)
* Terraform
* Azure Resource Manager (for Azure only)
* Google Cloud Deployment Manager (for Google only)

Infrastructure-as-Code (IAC) Classification:

* Configuration management tools:  Ansible, Puppet, Chef and SaltStack.
* Provisioning tools: Terraform and CloudFormation.
* Server Templating: Packer (open-source image-building tool. It allows you to create identical machine images).

You can use configuration management and provisioning tools together.

### Configuration Management vs Provisioning Tools

* Configuration management tools:
  * Designed to install and manage software on existing servers.
  * Chef, Puppet, Ansible, and SaltStack.
* Provisioning tools:
  * Designed to provision the servers themselves (as well as the rest of your infrastructure, like load balancers, databases, networking configuration, etc).
  * CloudFormation and Terraform.

These two categories are not mutually exclusive, as most configuration management tools can do some degree of provisioning and most provisioning tools can do some degree of configuration management.

If you use Docker, the vast majority of your configuration management needs are already taken care of. With Docker, you can create images (such as containers or virtual machine images) that have all the software your server needs already installed and configured. Once you have such an image, all you need is a server to run it. And if all you need to do is provision a bunch of servers, then a provisioning tool like Terraform is typically going to be a better fit than a configuration management tool ([here’s an example of how to use Terraform to deploy Docker on AWS](https://github.com/brikis98/infrastructure-as-code-talk)).

### Procedural vs Declarative

Chef and Ansible encourage a procedural style where you write code that specifies, step-by-step, how to to achieve some desired end state.

Terraform, CloudFormation, SaltStack, and Puppet all encourage a more declarative style where you write code that specifies your desired end state, and the IAC tool itself is responsible for figuring out how to achieve that state.

For example, let’s say you wanted to deploy 10 servers (“EC2 Instances” in AWS lingo) to run v1 of an app. Here is a simplified example of an Ansible template that does this with a procedural approach:

```playbook
- ec2:
    count: 10
    image: ami-v1
    instance_type: t2.micro
```

And here is a simplified example of a Terraform template that does the same thing using a declarative approach:

```terraform
resource "aws_instance" "example" {
  count         = 10
  ami           = "ami-v1"
  instance_type = "t2.micro"
}
```

These two approaches may look similar, and when you initially execute them with Ansible or Terraform, they will produce similar results. But if you want to increase the number of servers to 15. With Ansible, the procedural code you wrote earlier is no longer useful; if you just updated the number of servers to 15 and reran that code, it would deploy 15 new servers, giving you 25 total!

So instead, you have to be aware of what is already deployed and write a totally new procedural script to add the 5 new servers:

```playbook
- ec2:
    count: 5
    image: ami-v1
    instance_type: t2.micro
```

With declarative code, since all you do is declare the end state you want, and Terraform figures out how to get to that end state, Terraform will also be aware of any state it created in the past. Therefore, to deploy 5 more servers, all you have to do is go back to the same Terraform template and update the count from 10 to 15.

```terraform
resource "aws_instance" "example" {
  count         = 15
  ami           = "ami-v1"
  instance_type = "t2.micro"
}
```

If you executed this template, Terraform would realize it had already created 10 servers and therefore that all it needed to do was create 5 new servers.

Now what happens when you want to deploy v2 the service? With the procedural approach, both of your previous Ansible templates are again not useful, so you have to write yet another template to track down the 10 servers you deployed previous and carefully update each one to the new version. With the declarative approach of Terraform, you go back to the exact same template once again and simply change the ami version number to v2:

```terraform
resource "aws_instance" "example" {
  count         = 15
  ami           = "ami-v2"
  instance_type = "t2.micro"
}
```

With the kind of declarative approach used in Terraform, the code always represents the latest state of your infrastructure. At a glance, you can tell what’s currently deployed and how it’s configured, without having to worry about history or timing. This also makes it easy to create reusable code, as you don’t have to manually account for the current state of the world. Instead, you just focus on describing your desired state, and Terraform figures out how to get from one state to the other automatically. As a result, Terraform codebases tend to stay small and easy to understand.

### Master vs Masterless

By default, **Chef, Puppet, and SaltStack** all **require** that you run a **master server** for storing the state of your infrastructure and distributing updates.

Every time you want to update something in your infrastructure, you use a client (e.g., a command-line tool) to issue new commands to the master server, and the master server either pushes the updates out to all the other servers, or those servers pull the latest updates down from the master server on a regular basis.

However, having to run a master server has some serious drawbacks:

* Extra infrastructure: You have to deploy an extra server, or even a cluster of extra servers (for high availability and scalability), just to run the master.
* Maintenance: You have to maintain, upgrade, back up, monitor, and scale the master server(s).
* Security: You have to provide a way for the client to communicate to the master server(s) and a way for the master server(s) to communicate with all the other servers, which typically means opening extra ports and configuring extra authentication systems, all of which increases your surface area to attackers.

**Ansible, CloudFormation, Heat, and Terraform are all masterless by default**. Or, to be more accurate, some of them may rely on a master server, but it’s already part of the infrastructure you’re using and not an extra piece you have to manage. Ansible works by connecting directly to each server over SSH, so again, you don’t have to run any extra infrastructure or manage extra authentication mechanisms (i.e., just use your SSH keys).

### Agent vs Agentless

**Chef, Puppet, and SaltStack** all **require** you to install **agent** software on each server you want to configure. The agent typically runs in the background on each server and is responsible for installing the latest configuration management updates.

This has a few drawbacks:

* Bootstrapping: How do you provision your servers and install the agent software on them in the first place?
* Maintenance: You have to carefully update the agent software on a periodic basis.
* Security: If the agent software pulls down configuration from a master server (or some other server if you’re not using a master), then you have to open outbound ports on every server. If the master server pushes configuration to the agent, then you have to open inbound ports on every server. In either case, you have to figure out how to authenticate the agent to the server it’s talking to. All of this increases your surface area to attackers.

**Ansible, CloudFormation, Heat, and Terraform do not require you to install any extra agents**. Or, to be more accurate, some of them require agents, but these are typically already installed as part of the infrastructure you’re using. For example, AWS, Azure, Google Cloud, and all other cloud providers take care of installing, managing, and authenticating agent software on each of their physical servers. As a user of Terraform, you don’t have to worry about any of that: you just issue commands and the cloud provider’s agents execute
them for you on all of your servers. With Ansible, your servers need to run
the SSH Daemon, which is common to run on most servers anyway.

### Using Multiple Tools Together

You will likely need to use multiple tools to build your infrastructure. Each of the tools you’ve seen has strengths and weaknesses, so it’s your job to pick the right tool for the right job.

#### Provisioning plus Configuration Management

Example: Terraform and Ansible. You use Terraform to deploy all the underlying infrastructure, including the network topology (i.e., VPCs, subnets, route tables), data stores (e.g., MySQL, Redis), load balancers, and servers. You then use Ansible to deploy your apps on top of those servers.

This is an easy approach to start with, as there is no extra infrastructure to run (Terraform and Ansible are both client-only applications) and there are many ways to get Ansible and Terraform to work together (e.g., Terraform adds special tags to your servers and Ansible uses those tags to find the server and configure them). The major downside is that using Ansible typically means you’re writing a lot of procedural code, with mutable servers, so as your code base, infrastructure, and team grow, maintenance may become more difficult.

#### Provisioning plus Server Templating

Example: Terraform and Packer.

* You use **Packer** to package your apps as virtual machine images.
* You then use **Terraform** to  
  (a) deploy servers with these virtual machine images and  
  (b) deploy the rest of your infrastructure, including the network topology (i.e., VPCs, subnets, route tables), data stores (e.g., MySQL, Redis), and load balancers.

This is also an easy approach to start with, as there is no extra infrastructure to run (Terraform and Packer are both client-only applications). Moreover, this is an immutable infrastructure approach, which will make maintenance easier.

However, there are two major drawbacks. First, virtual machines can take a long time to build and deploy, which will slow down your iteration speed. Second, the deployment strategies you can implement with Terraform are limited (e.g., you can’t implement blue-green deployment natively in Terraform), so you either end up writing lots of complicated deployment scripts, or you turn to orchestration tools, as described next.

#### Provisioning plus Server Templating plus Orchestration

Example: Terraform, Packer, Docker, and Kubernetes.

* You use **Packer** to create a virtual machine image that has Docker and Kubernetes installed.
* You then use **Terraform** to  
  (a) deploy a cluster of servers, each of which runs this virtual machine image and  
  (b) deploy the rest of your infrastructure, including the network topology (i.e., VPCs, subnets, route tables), data stores (e.g., MySQL, Redis), and load balancers.  
  (c) Finally, when the cluster of servers boots up, it forms a Kubernetes cluster that you use to run and manage your Dockerized applications.

The advantage of this approach is that Docker images build fairly quickly, you can run and test them on your local computer, and you can take advantage of all the built-in functionality of Kubernetes, including various deployment strategies, auto healing, auto scaling, and so on.

The drawback is the added complexity, both in terms of extra infrastructure to run (Kubernetes clusters are difficult and expensive to deploy and operate, though most major cloud
providers now provide managed Kubernetes services, which can offload some of this work), and in terms of several extra layers of abstraction (Kubernetes, Docker, Packer) to learn, manage, and debug.

***

## Best Practices to Get the Most out of IaC

* **Codify everything**. Codify all the infrastructure things! So infrastructure can then be deployed quickly and seamlessly, and ideally no one should log into a server to manually make adjustments.
* **Document as little as possible**. Your IaC code will essentially be your documentation, so there shouldn’t be many additional instructions for your IT employees to execute. With IaC, the code itself represents the documentation of the infrastructure and will always be up to date. Additional documentation, such as diagrams and other setup instructions, may be necessary to educate those employees who are less familiar with the infrastructure deployment process. But most of the deployment steps will be performed by the configuration code, so this documentation should ideally be kept to a minimum.
* **Maintain version control**. These configuration files will be version-controlled. Because all configuration details are written in code, any changes to the codebase can be managed, tracked, and reconciled. Just like with application code, source control tools like Git, Mercurial, Subversion, or others should be used to maintain versions of your IaC codebase.
* **Continuously test, integrate, and deploy**. Continuous testing, integration, and deployment processes are a great way to manage all the changes that may be made to your infrastructure code. Testing should be rigorously applied to your infrastructure configurations to ensure that there are no post-deployment issues. Depending on your needs, an array of test types – unit, regression, integration and many more – should be performed. Automated tests can be set up to run each time a change is made to your configuration code.
* **Make your infrastructure code modular**. You can break down your infrastructure into separate modules or stacks then combine them in an automated fashion.
* **Make your infrastructure immutable (when possible)**. The idea behind immutable infrastructure is that IT infrastructure components are replaced for each deployment, instead of changed in-place. You can write code for and deploy an infrastructure stack once, use it multiple times, and never change it. If you need to make changes to your configuration, you would just terminate that stack and build a new one from scratch.

***

## References

* [A Comprehensive Guide to Terraform](https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca)
* [Why we use Terraform and not Chef, Puppet, Ansible, SaltStack, or CloudFormation](https://blog.gruntwork.io/why-we-use-terraform-and-not-chef-puppet-ansible-saltstack-or-cloudformation-7989dad2865c)
* [Infrastructure-as-code: running microservices on AWS with Docker, ECS, and Terraform](https://github.com/brikis98/infrastructure-as-code-talk)
* [Infrastructure as Code best practices](https://www.thorntech.com/2018/02/infrastructure-as-code-best-practices/)
