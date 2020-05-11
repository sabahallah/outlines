# Nexus Outline

> This outline describe what is Nexus and how to integrate with [Jenkins](./jenkins-outline.md).

## Table of Content

* [What is Nexus](#what-is-nexus)
* [Resources](#resources)

## What is Nexus

Nexus is a repository manager. It allows you to proxy, collect, and manage your dependencies. It makes it easy to distribute your software. Internally, you configure your build to publish artifacts to Nexus and they then become available to other developers.

A Nexus installation brings you such a repository for your company. So you can host your own repositories, but also use Nexus as a proxy for public repositories. With such a proxy the time to receive an artifact is reduced and it saves bandwidth. Nexus allows you to host your private build artifacts. Nexus is available as commercial and Open Source distribution.

Nexus manages software "artifacts" required for development. If you develop software, your builds can download dependencies from Nexus and can publish artifacts to Nexus creating a new way to share artifacts within an organization. While Central repository has always served as a great convenience for developers you shouldn't be hitting it directly. **You should be proxying Central with Nexus** and maintaining your own repositories to ensure stability within your organization. With Nexus you can completely control access to, and deployment of, every artifact in your organization from a single location.

The primary use of a repository manager is to proxy and cache artifacts from "external" repositories. Your organization uses open source libraries, and when your build needs them it will automatically query a local repository manager. If that local repository manager does not have that particular artifact, it will retrieve it from an external repository server and cache it for later use.

"**Central**" refers to the "Central Maven Repository", you can think of "central" as the global repository manager that stores all open source components. "Central" has millions of users throughout the world, and it is fed by thousands for open source projects.

## Resources

* [Youtube: What is Nexus | How to setup and configure Nexus | Nexus Repository Manager](https://www.youtube.com/watch?v=83AGz9huJGo)
  * [Installation Instructions](https://github.com/ValaxyTech/Simple-DevOps-Project/blob/master/Nexus/Nexus_Installation.MD)
* [Youtube: Jenkins Integration with Nexus](https://www.youtube.com/watch?v=qbO4MTESiJQ)
* [Youtube: How to integrate Nexus with jenkins and upload artifacts to Nexus server](https://www.youtube.com/watch?v=Mde05zXu0O4)
* [Youtube: Uploading artifacts from jenkins to Nexus](https://www.youtube.com/watch?v=7NmGSnqLd58)
* [Nexus Repository Manager - Tutorial](https://www.vogella.com/tutorials/Nexus/article.html)
