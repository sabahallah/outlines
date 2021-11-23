# Security Outlines

This outline contains the major security principles including authentication, authorization for JWT and OAuth. It also contains highlights of the major security attacks what-is and how-to-avoid techniques, brief of hashing algorithms and more...

Please check [angular-spring-stateless-auth-module](#to-be-added) which is implementing the below points.

## Index

- [Intro](#Intro)
- [Authentication](#Authentication)
- [Traditional Authentication](#traditional-Authentication)
- [JWT](#jwt)
- [OAuth vs JWT](#oauth-vs-jwt)
- [Jwt Stateless Authentication](#jwt-stateless-authentication)
- [OAuth Authentication](#oauth-authentication)
- [What is CSRF attack](#What-is-CSRF-attack)
- [What is CORS](#What-is-CORS)
- [Cross-site scripting (XSS) attacks](#Cross-site-scripting-XSS-attacks)
- [JWTs and Cookies](#JWTs-and-Cookies)
- [My solution for JWT stateless authentication and authorization to prevent CSRF and XSS attacks](#My-solution-for-JWT-stateless-Authentication-and-Authorization-to-prevent-CSRF-and-XSS-attacks)
- [What is replay attack](#What-is-Replay-attack)
- [Geolocation by IP](#Geolocation-by-IP)
- [Enumeration attack](#Enumeration-Attack)
- [OpenPGP secure encryption of our data](##OpenPGP-Secure-encryption-of-our-data)
- [Bcrypt encoding](#Bcrypt-Encoding)
- [Password encoding](#Password-Encoding)
- [Password strength and rules](#Password-Strength-and-Rules)
- [Hashing methods](#Hashing-Methods)
- [Resources](#resources)

## Intro

Get the full picture about Angular security with plain and simple explanations of concepts like OAuth, JSON Web Tokens, client sessions, CSRF, XSS, and more.

Authentication and authorization in single page apps is a lot different than it is in traditional round-trip applications.
Having a separate client and server means you need to manage sessions on the front end while protecting data resources at the API in a stateless manner.
You also probably want to support social authentication through OAuth.

- SPA vs round-trip application auth
- JSON Web Tokens vs cookies and sessions
- OAuth 2.0
- User experience considerations
- Application security and attack mitigation
- Ionic authentication considerations

## Authentication

- Authentication starts with a login page, which can be hosted either in our domain or in a third-party domain. In an enterprise scenario, the login page is often hosted on a separate server, which is part of a company-wide Single Sign-On solution.
- On the public Internet, the login page might also be:
  - Hosted by a third-party Authentication provider such as [auth0](https://auth0.com).
  - Available directly in our single page application using a login screen route.
  - A separately hosted login page is an improvement security-wise because this way the password is never directly handled by our application code in the first place. The separately hosted login page can have minimal Javascript or even none at all, and it could be styled to make it look and feel as part of the whole application.

## Traditional Authentication

![Traditional Authentication](./metadata/security/traditional-authentication.PNG)

## Jwt

- JWT (JSON Web Token) is an open standard (RFC 7519) that defines a compact and self-contained way for securely transmitting information between parties as a JSON object.
- A stateless authentication mechanism as the user state is never saved in server memory.
- A JWT token consists of 3 parts separated with a dot(.), `header.payload.signature`
- Header
  ```json
  {
    "alg": "HS256",
    "typ": "JWT"
  }
  ```
- Payload (contains the claims). Three types of claims: _reserved_, _public_, and _private_ claims.
  - _Reserved_ claims are predefined claims such as `iss` (issuer), `exp` (expiration time), `sub` (subject), `aud` (audience).
  - _Private_ claims, we can create some custom claims such as `subject` and `role`.
    ```json
    {
      "sub": "Alex123",
      "scopes": [
        {
          "authority": "ROLE_ADMIN"
        }
      ],
      "iss": "http://devglan.com",
      "iat": 1508607322,
      "exp": 1508625322
    }
    ```
- Signature ensures that the token is not changed on the way. encoded header in base64 + . + payload encoded in base64 + secret, all will be hashed
  ```json
  HMACSHA256(
    base64UrlEncode(header) + "." +
    base64UrlEncode(payload),
    secret)
  ```
  - eg:
  ```jwt
  Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJBbGV4MTIzIiwic2N.v9A80eU1VDo2Mm9UqN2FyEpyT79IUmhg
  ```
- Claims
  - `"iss"` (Issuer) Claim
  - `"sub"` (Subject) Claim
  - `"aud"` (Audience) Claim
  - `"exp"` (Expiration Time) Claim
  - `"nbf"` (Not Before) Claim
  - `"iat"` (Issued At) Claim
  - `"jti"` (JWT ID) Claim
- The result of that is a SHA-256 HMAC or Hash-Based Message Authentication Code

## OAuth vs JWT

Firstly, we have to differentiate JWT and OAuth. Basically, JWT is a _token format_. OAuth is an _authorization protocol_ that can use JWT as a token. OAuth uses server-side and client-side storage. If you want to do real logout you must go with OAuth2. Authentication with JWT token can not logout actually. Because you don't have an Authentication Server that keeps track of tokens. If you want to provide an API to 3rd party clients, you must use OAuth2 also. OAuth2 is very flexible. JWT implementation is very easy and does not take long to implement. If your application needs this sort of flexibility, you should go with OAuth2. But if you don't need this use case scenario, implementing OAuth2 is a waste of time.

## JWT Stateless Authentication

- Remember that your tokens are NOT encrypted, so claims can be read. Never store anything confidential in JWTs, unless you also use JWE (encryption). But then encrypting and decrypting tokens can quickly become CPU-intensive.
- One argument I once read is that, since most operations performed require the logged user’s information, one ends up hitting a database or a cache to fetch those user details anyway. So you lose the benefits of statelessness, because you end up replacing a session object with a call to the database.
- Disabling and expiring JWT token
  - Like cookies, JWTs can be set to expire. The tricky part here is to determine how long should JWTs live, because you cannot logout someone as long as he has a valid token!
  - What if you need to disable a user? Again, in “stateless land”, a user can keep on accessing your application as long as his token is not expired. Setting a lifetime of two weeks is probably not a good idea, unless you constantly check whether the JWT is part of a list of revoked tokens. But then you’re implementing a kind of state.
  - So let’s make our JWT expire in 30 minutes then. Fine, but now you either have the user typing his password every 30 minutes, or you have to implement some sort of logic to re-authenticate a user automatically (issue a new access token? or use _refresh_ tokens?).

## OAuth Authentication

What exactly is OAuth (Open Authorization)?

OAuth is simply a secure authorization protocol that deals with the authorization of third party application to access the user data without exposing their password. eg. Login with fb, twitter... all work under this protocol. It does not deal with _authentication_.

OAuth allows notifying a _resource provider_ (e.g. Facebook) that the _resource owner_ (e.g. user) grants permission to a third-party (e.g. an application) access to their information (e.g. your email or list of your friends...).

Parties involved

- OAuth Client (Application Which wants to access your credential)
- OAuth Provider (eg. facebook, twitter...)
- Owner (the person who has facebook, twitter... account)

How It Works?

I have supposed a scenario where a website(stackoverflow) needs to add login with facebook feature. Thus facebook is _oAuth Provider_ and the stackoverflow is _oAuth Client_

- **This step is done by app's developer**. At the very beginning facebook (_oAuth Provider_) has no idea about the stackoverflow(_oAuth Client_) because there is no link between them. So the very first step is to register stackoverflow with facebook developers site. This is done manually where developers need to give app's information to facebook like app's name, website, logo, redirect Url(important one). Then stackoverflow is successfully registered, has got client Id, client secret etc from facebook and is up and running with OAUTH.
  ![login image](https://i.stack.imgur.com/Vb3bY.png)
- **Now when stackoverflow's user clicks login with fb button**. Stackoverflow requests facebook with ClientId(fb use it to recognize the client) and redirectUrl(fb will return back to this url after success).Thus the user gets redirected to facebook login page. This is the best part _**user(owner) is not giving their facebook credential to stackoverflow**_.
  ![provider login image](https://i.stack.imgur.com/5Jev9.png)
  ![give permission image](https://i.stack.imgur.com/8IVIJ.png)
- After Owner allow Stackoverflow to access the information. Then Facebook redirects back to stackoverflow, along with _authcode_ using the redirectUrl provided at step 2.
- Then access token is used by stackoverflow to retrieve owner's information without using password. This is the whole motive of oAuth, where actual credentials is never exposed to third party applications.
- Resources
  - [OAuth 2 Simplified - very well explained](https://aaronparecki.com/oauth-2-simplified/)
  - [Quick video](https://www.youtube.com/watch?v=tFYrq3d54Dc)
  - [Google developer playground](https://developers.google.com/oauthplayground/)

## What is CSRF attack

- Cross-Site Request Forgery
- When you log in to site x and successful login happens, site x sets some cookies in the browser. then you open another site y. site y can't access the cookies created by site x because they are not under the same domain, but site y can send request itself from the UI to site x, in this case all the cookies set by domain x will be sent in the request. this is default behavior by the browser. If site y have some knowledge about site x apis, it can make some action on your behalf as long as the login cookie on your browser is valid and present. like posting something...
- The malicious script cannot read the token value, so it cannot copy it to the header, and so the server will block the malicious request!
- You need to protect against CSRF if you store your JWT in a cookie.
- We’re going to basically apply two techniques: **the synchronizer token pattern** and the **cookie-to-header** mechanism.
- Have the clients generate and send the same unique secret value in both a Cookie and a custom HTTP header. Considering a website is only allowed to read/write a Cookie for its own domain, only the real site can send the same value in both headers. Using this approach all your server has to do is check if both values are equal, on a stateless per request basis!
- To summarize: we use a CSRF token (unique, random, renewed at each user login) to ensure that a modifying request is indeed coming from a given authenticated user.

## What is CORS

- CORS (cross-origin resource sharing) is the mechanism that secures the sharing of resources with domains that are not the domain of origin of those resources.
- We know we need to define the “rules” by which a resource sharing will be accepted or not.
- These rules are specified in the header of the response to be sent back to the browser when it preflight.
- The sequence is:
  - The browser preflight a CORS-triggering request. In practice, it sends an `OPTIONS` request for that purpose. (always authorize OPTIONS requests in your configuration!).
  - The server replies with the set of conditions by which the actual request is accepted.
  - The browser sends the actual request.
  - The server provides the requested resource.
- Remember to allow `OPTIONS` method in order for browser to make the preflight request.
- You can also allow `CORS` for specific methods not for all.
- `CORS` headers
  - `Access-Control-Allow-Origin` specifies the origin URL from which requests will be accepted. A request received from a different origin will be rejected.
  - `Access-Control-Max-Age`: defines how long the preflight will be cached, that is, how much time the browser has between what he announced it would request and the actual request.
  - `Access-Control-Allow-Credentials` indicates whether the actual request can contain credentials or not.
  - `Access-Control-Allow-Methods` indicates which methods are allowed to access the resource.
  - `Access-Control-Allow-Headers` lists the headers that can be used by the browser when making the actual request. Notice how in my code I allow a custom header to send CSRF tokens? If that CSRF header is not specified, the tokens will never be accepted by the browser
- Having the two parts of the application (the UI and the API) served from different ports presents a problem, though – by default, the web browser prevents the UI application from accessing the API on a port different from the one on which the UI was served (this is known as the Single-Origin Policy, or SOP).
- we're likely to run into the SOP problem in production, for instance, if we want to serve our application's UI from <http://example.com> and it's API from <http://api.example.com>, or if we want to provide our API for other people’s applications to consume in addition to our own.
- A popular solution to this problem is the use of Cross-Origin Resource Sharing (CORS). CORS is a W3C Recommendation, supported by all modern browsers, that involves a set of procedures and HTTP headers that together allow a browser to access data (notably Ajax requests) from a site other than the one from which the current page was served.
- This means that XMLHttpRequests can only be made to the same domain that served the initial page. If the protocol, host, or port do not match the original page request, the response won't be received by the client code, and you'll see this _error_.
  > XMLHttpRequest cannot load <http://localhost:8080/heroes>. No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin '<http://localhost:3000>' is therefore not allowed access.
- For simple cases like this `GET`, when your Angular code makes an XMLHttpRequest that the browser determines is cross-origin, the browser looks for an HTTP header named `Access-Control-Allow-Origin` in the response. If the response header exists, and the value matches the origin domain, then the browser passes the response back to the calling javascript. If the response header does not exist, or it's value does not match the origin domain, then the browser does not pass the response back to the calling code, and you get the error that we just saw.
- For more complex cases, like `PUT`, `DELETE`, or any request involving credentials (which will eventually be all of our requests), the process is slightly more involved. The browser will send an OPTION request to find out what methods are allowed. If the requested method is allowed, then the browser will make the actual request, again passing or blocking the response depending on the Access-Control-Allow-Origin header in the response.

### Configure CORS for Spring

You can control the cross origin resources in two level, _controller_ level and _application_ level

- Controller Level
  ```java
  @GetMapping("/good-beers")
  @CrossOrigin(origins = "http://localhost:4200")
  public Collection<Beer> goodBeers() {
  }
  ```
- Application Level: `CORSFilter.java` Filter

## Cross-site scripting (XSS) attacks

- In a nutshell, is a type of vulnerability where an attacker can inject JavaScript that will run on your page. Basic XSS attacks attempt to inject JavaScript through form inputs.

### Solutions

- Cookies, when used with the HttpOnly cookie flag, are not accessible through JavaScript, and are immune to XSS.
- You can also set the Secure cookie flag to guarantee the cookie is only sent over HTTPS.
- Also you can’t set cookies in any outgoing requests at all.

## JWTs and Cookies: Storing JWT in Cookies

- We can send a JWT back to the client
  - In a Cookie
  - In the Request Body
  - In a plain HTTP Response Header

Let's start with cookies, why not use them? JWTs are sometimes mentioned as an alternative to Cookies, but these are two very different concepts. Cookies are a browser data storage mechanism, a place where we can safely store a small amount of data.

That data could be anything such as for example the user preferred language, but it can also contain a user identification token such as for example a JWT.

So we can for example, store a JWT in a cookie! Let's then talk about the advantages and disadvantages of using cookies to store JWTs, when compared to other methods.

### How the browser handles cookies

A unique aspect of cookies is that the browser with each request will automatically append the cookies for a particular domain or sub-domain to the headers of the HTTP request.

This means that if we store the JWT in a cookie, we will not need any further client logic for sending back the cookie to the application server with each request, assuming the login page and the application share the same root domain.

Besides setting a cookie with the JWT value, we also set a couple of security properties that we are going to cover next.

### Unique security properties of Cookies - HttpOnly and Secure Flags

Another unique aspect of Cookies is that they have some security-related properties that help with ensuring secure data transfer.

A Cookie can be marked as Secure, meaning that the browser will only append the cookie to the request if it's being made over an HTTPS connection.

A Cookie can also be marked as Http Only, meaning that it's not accessible by the Javascript code at all! Note that the browser will still append the cookie to each request sent back to the server, just like with any other cookie.

This means for example that in order to delete a HTTP Only cookie, we need to send a request to the server, like for example to logout the user.

One advantage of an HTTP Only cookie is that if the application suffers, for example, a script injection attack (or XSS), the Http Only flag would still, in this disastrous scenario, prevent the attacker from getting access to the cookie and use it to impersonate the user.

The two flags Secure and Http Only can and are often used together for maximum security, which might make us think that Cookies are the ideal place for storing a JWT.

But Cookies have some disadvantages too, so let's talk about those: this will help us decide if storing JWT in cookies is a good approach for our application.

### Disadvantages of Cookies & XSRF

Applications with Bearer tokens stored in a Cookie suffer from a vulnerability called **Cross-Site Request Forgery**, also known as `XSRF` or `CSRF`.

Here is how it works:

- Somebody sends you a link and you click on it.
- The link ends up sending an HTTP request to the site under attack containing all the cookies linked to the site.
- And if you were logged into the site this means the Cookie containing our JWT bearer token will be forwarded too, this is done automatically by the browser
- The server receives a valid JWT, so there is no way for the server to distinguish this attack from a valid request

This means that an attacker could trick a user to do certain actions on its behalf, just by sending an email, or posting a link in a public forum.

This attack is less powerful than it might look but the problem is that it's very easy to perform: all it takes is an email or a post on social media.

It's important to realize that if we choose to store our JWT in a cookie then we need to also put in place some defenses against XSRF.

The good news is that all major frameworks come with defenses that can be easily put in place against XSRF, as it's such a well-known vulnerability.

Like it happens many times, there is a design tradeoff going on here with Cookies. Using them means leveraging HTTP Only which is a great defense against script injection, but on the other hand, it introduces a new problem, XSRF.

A potential problem with receiving the session JWT in a cookie is that we would not be able to receive it from a third-party web domain, that handles the authentication logic.

This is because an application running on app.example.com cannot access cookies from another domain like security-provider.com.

So in that scenario, we would not be able to access the cookie containing the JWT, and send it to our server for validation, making the use of cookies unfeasible.

[OWASP CSRF reference](https://owasp.org/www-community/attacks/csrf)

### Related Controls

Checking the referrer header in the client’s HTTP request can prevent CSRF attacks. Ensuring that the HTTP request has come from the original site means that attacks from other sites will not function. It is very common to see referrer header checks used on embedded network hardware due to memory limitations.
XSS can be used to bypass both referrer and token based checks simultaneously. For instance, the Samy worm used an XMLHttpRequest to obtain the CSRF token to forge requests.

Can we get the best of the two solutions?

## My solution for JWT stateless Authentication and Authorization to prevent CSRF and XSS attacks

- Best solution till now is that the server send back the jwt token as `xsrf-token` cookie and as `Authorization` header in the response.
- The front end will automatically send the same cookie value in header as `x-xsrf-token`, this step can be done automatically by Angular. Angular already comes with build-in CSRF-token support.
- Also in front end, get Authorization header and put in memory not in local storage as it may be accessible to any javascript.
- Why not to keep the jwt in local or session storage? It is unlike cookies, which are protected from this. Any javascript on the page can access storage and steal information including CDN scripts that you include in your page eg. `bootstrap.min.js`.
- Additional step is to send the `Authorization` header as well in any ongoing request headers
- In backed you need to check the `Authorization` header === `x-xsrf-token` header === `xsrf-token` cookie
- By this way you mitigated the `CSRF` attack and immune `XSS` attack.
- This is during login scenario, but what if the user closes the browser and opened it again? In this case you already have the cookie, just all you need is to get the `Authorization` header and put in the memory. This may be done on application startup.
- Another solution if you want to go stateful is to use Spring Session with Redis in Memory DB. We'll send xsrf token to browser, browser will send it back in the header. We verify the token in spring session sever.

## What is Replay attack

- Replay attacks (token side-jacking): intercepting a token and using it to impersonate a user. This can be mitigated by using short expiration times, but it’s not enough to prevent them.
- So we have to ensure our signing keys are safe. We can avoid storing our signing key in full on the server’s file system, in case a breach occurs. And we can set up a system of keys rotation to mitigate any leaks. Never make the whole key accessible by the same user. His advice is to split the key in two and, for example, store one half in the file system and one half in the database.

## Geolocation by IP

To get geographic location data from an IP address use the MaxMind GeoIP2 Java API with the free [GeoLite2 database](https://dev.maxmind.com/geoip/geoip2/geolite2/)

## Enumeration Attack

- Brute Force Authentication Attempts Solution:
  - We’ll keep a record of the number of failed attempts originating from a single IP address. If that particular IP goes over a set number of requests – it will be blocked for 24 hours.
- Solution for enumeration attack is to add re-captcha in registration

## OpenPGP (Secure encryption of our data)

For one specific case, I needed the client to be able to send data to the server in a very secure way. My solution was to have the server generate and cache its own key ring, and have the public key sent to the web clients. With those public keys, the web clients would encrypt their data with the OpenPGP.js library, using the server’s public key, before sending it over.

- [OpenPGP for complete beginners](https://zacharyvoase.com/2009/08/20/openpgp/)
- [OpenPGP Integration (Java and JavaScript): Java keys generation](https://www.codesandnotes.be/2018/07/17/openpgp-java-keys-generation/)
- [OpenPGP Integration (Java and JavaScript): Java PGP encryption](https://www.codesandnotes.be/2018/09/04/openpgp-integration-java-and-javascript-java-pgp-encryption/)
- [OpenPGP Integration (Java and JavaScript): OpenPGP.js](https://www.codesandnotes.be/2018/11/10/openpgp-integration-java-and-javascript-openpgp-js/)
- [OpenPGP Integration (Java and JavaScript): PGP exchange between Java and JavaScript](https://www.codesandnotes.be/2019/03/29/openpgp-integration-java-and-javascript-pgp-exchange-between-java-and-javascript/)
- [github code](https://github.com/codesandnotes/openpgp-integration)

## Bcrypt Encoding

`Bcrypt` is a password hashing function designed by Niels Provos and David Mazières, based on the Blowfish cipher. Bcrypt uses adaptive hash algorithm to store password. BCrypt internally generates a random salt while encoding passwords and hence it is obvious to get different encoded results for the same string. But one common thing is that every time it generates a String of length 60.

## Password Encoding

```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```

There are a few encoding mechanism supported by Spring Security. We’ll use `BCryptPasswordEncoder`, as it’s usually the best solution available. Most of the other mechanism, such as the `MD5PasswordEncoder` and `ShaPasswordEncoder` use weaker algorithms and are now deprecated.

## Password Strength and Rules

We're using [Passay: Password policy enforcement for Java](http://www.passay.org/) to enforce password constraints during registration. Things like – the password should contain a special character, or it should be at least 8 characters long.

## Hashing Methods

### What is `RS256` Signature?

`RS256` is a JWT signature type that is based on `RSA`, which is a widely used public key encryption technology. One of the main advantages of using a `RS256` signature is that we can separate the ability of creating tokens from the ability to verify them.

In a nutshell, `RS256` signatures work in the following way:

- A private key (like RSA_PRIVATE_KEY in our code) is used for signing JWTs
- A public key is used to validate them.
- The two keys are not interchangeable, they can either only sign tokens, or only validate them, but neither key can do both things

### Benefits

- We only have to deploy the private signing key in the Authentication Server, and not on the multiple Application servers that use the same Authentication Server
- Being able to publish the validating key gives us built-in key rotation and revocation. This is because in order to enable a new key pair we simply publish a new public key.

### `RS256` vs `HS256`

HS256 is still commonly used, but for example providers such as `Auth0` are now using `RS256` by default.

## Resources

- JWT
  - [The Complete Guide to JSON Web Tokens](https://blog.angular-university.io/angular-jwt/)
  - [jwt.io](https://jwt.io/)
  - [JWT Tutorial for Beginners](https://examples.javacodegeeks.com/enterprise-java/jwt-tutorial-for-beginners/)
  - [Attacking JWT Authentication](https://www.sjoerdlangkemper.nl/2016/09/28/attacking-jwt-authentication/)
  - [JSON Web Token (JWT) Standards](https://tools.ietf.org/html/rfc7519)
  - [Authentication With JSON Web Tokens (JWT): The Complete Guide: Great Article](https://blog.angular-university.io/angular-jwt-authentication/)
  - [Where to Store your JWTs – Cookies vs HTML5 Web Storage](https://stormpath.com/blog/where-to-store-your-jwts-cookies-vs-html5-web-storage)
- JWT Tools for developers
  - [jsonwebtoken.io](https://www.jsonwebtoken.io/)
  - [java.jsonwebtoken.io](https://www.java.jsonwebtoken.io/)
  - [Supercharge Java Authentication with JSON Web Tokens (JWTs)](https://www.baeldung.com/java-json-web-tokens-jjwt)
- [CORS](https://www.html5rocks.com/en/tutorials/cors/)
- Frontend user authentication, register using jwt
  - <https://jasonwatmore.com/post/2019/06/22/angular-8-jwt-authentication-example-tutorial>
  - <https://jasonwatmore.com/post/2019/06/10/angular-8-user-registration-and-login-example-tutorial>
    - [Code on Github](https://github.com/cornflourblue/angular-8-registration-login-example)
- Authorization
  - [JWT Role Based Authorization with Spring Security](https://www.devglan.com/spring-security/jwt-role-based-authorization)
    - [Code on Github](https://github.com/only2dhir/spring-security-jwt)
  - [Angular 8 - Role Based Authorization Tutorial with Example](https://jasonwatmore.com/post/2019/08/06/angular-8-role-based-authorization-tutorial-with-example)
    - [Code on Github](https://github.com/cornflourblue/angular-8-role-based-authorization-example)
- Basic Authentication
  - <https://jasonwatmore.com/post/2019/06/26/angular-8-basic-http-authentication-tutorial-example>
  - `window.btoa(str)` encode base-64 string
  - `window.atob(str)` decode base-64 string
  - and put in local storage. with every request send this and compare in server
- From stateful to stateless RESTful security using Spring and JWTs - Series of articles
  - [From stateful to stateless RESTful security using Spring and JWTs - Part 1](https://www.codesandnotes.be/2017/09/25/from-stateful-to-stateless-restful-security-using-spring-and-jwts-part-1-intro/)
  - [From stateful to stateless RESTful security using Spring and JWTs - Part 2](https://www.codesandnotes.be/2017/10/02/from-stateful-to-stateless-restful-security-using-spring-and-jwts-part-2-session-based-authentication/)
  - [From stateful to stateless RESTful security using Spring and JWTs - Part 3](https://www.codesandnotes.be/2017/10/09/from-stateful-to-stateless-restful-security-using-spring-and-jwts-part-3-token-based-authentication/)
  - [From stateful to stateless RESTful security using Spring and JWTs - Part 4](https://www.codesandnotes.be/2017/10/16/from-stateful-to-stateless-restful-security-using-spring-and-jwts-part-4-jwt-based-authentication/)
  - [From stateful to stateless RESTful security using Spring and JWTs - Part 5](https://www.codesandnotes.be/2017/10/23/from-stateful-to-stateless-restful-security-using-spring-and-jwts-part-5-stateless-csrf/)
  - [From stateful to stateless RESTful security using Spring and JWTs - Part 6](https://www.codesandnotes.be/2017/11/17/from-stateful-to-stateless-restful-security-using-spring-and-jwts-part-6-should-i-go-stateless/)
  - [From stateful to stateless RESTful security using Spring and JWTs - Part 7](https://www.codesandnotes.be/2017/12/18/from-stateful-to-stateless-restful-security-using-spring-and-jwts-part-7-reference-material/)
  - [Code on github](https://github.com/codesandnotes/jwt-rest-spring/tree/01_basic_authentication)
- Spring-based REST services security
  - [Spring-based REST services security Part 1: CORS](https://www.codesandnotes.be/2015/07/12/angularjs-web-apps-for-spring-based-rest-services-security-the-server-side-part-1/)
  - [Spring-based REST services security Part 2: CSRF](https://www.codesandnotes.be/2015/07/24/angularjs-web-apps-for-spring-based-rest-services-security-the-server-side-part-2-csrf/)
- [Integrating Angular 2 with Spring Boot, JWT, and CORS, Part 1](https://chariotsolutions.com/blog/post/angular-2-spring-boot-jwt-cors_part1/)
- [Integrating Angular 2 with Spring Boot, JWT, and CORS, Part 2](https://chariotsolutions.com/blog/post/angular-2-spring-boot-jwt-cors_part2/)
- [Spring Security](https://www.baeldung.com/security-spring)
- [Basic and Digest Authentication](https://www.baeldung.com/basic-and-digest-authentication-for-a-rest-api-with-spring-security)
- [Spring Security for a REST API](https://www.baeldung.com/securing-a-restful-web-service-with-spring-security)
- [Spring Security and Angular, Hint: Difficult](https://spring.io/guides/tutorials/spring-security-and-angular-js/)
- [Create a Spring Boot app with Angular front end using **Maven** and modern front end tooling](https://github.com/dsyer/spring-boot-angular)
- OAuth2
  - <https://classroom.udacity.com/courses/ud330/lessons/3967218625/concepts/39636486110923>
    - <https://developers.google.com/oauthplayground/>
  - [Udacity Course: Authentication & Authorization: OAuth](https://ae.udacity.com/course/authentication-authorization-oauth--ud330)
  - [Spring Boot Security Oauth2 With Angular](https://www.devglan.com/spring-security/spring-boot-oauth2-angular)
  - [Spring Boot Security OAuth2 Example(Bcrypt Encoder)](https://www.devglan.com/spring-security/spring-boot-security-oauth2-example)
  - [Spring Boot Security Oauth2 Jwt Auth Example](https://www.devglan.com/spring-security/spring-boot-oauth2-jwt-example)
  - [Spring Boot Security Google Oauth](https://www.devglan.com/spring-security/spring-boot-security-google-oauth)
  - [Spring Security OAuth2 User Registration](https://www.devglan.com/spring-security/spring-security-oauth2-user-registration)
  - [Secure a Spring Boot REST API with JSON Web Token](https://medium.com/@nydiarra/secure-a-spring-boot-rest-api-with-json-web-token-reference-to-angular-integration-e57a25806c50)
  - [Spring Boot and OAuth2](https://spring.io/guides/tutorials/spring-boot-oauth2/)
  - [Spring REST API + OAuth2 + Angular](https://www.baeldung.com/rest-api-spring-oauth2-angular)
  - [Simple Single Sign-On with Spring Security OAuth2](https://www.baeldung.com/sso-spring-security-oauth2)
  - [OAuth 2 Developers Guide](https://projects.spring.io/spring-security-oauth/docs/oauth2.html)
  - <http://www.baeldung.com/rest-api-spring-oauth2-angularjs>
  - [A Quick Guide to OAuth 2.0 with Spring Security](https://www.javacodegeeks.com/2019/03/quick-guide-oauth-spring-security.html)
- Registeration
  - [Spring Security Registration](https://www.baeldung.com/spring-security-registration)
    - [2FA using google authenticator: Check when needed](https://www.baeldung.com/spring-security-two-factor-authentication-with-soft-token)
  - [Registeration flow](https://www.baeldung.com/spring-security-registration)
    - [github code](https://github.com/Baeldung/spring-security-registration)
  - [Registration – Activate a New Account by Email](https://www.baeldung.com/registration-verify-user-by-email)
  - [Registration – Resend Verification Email](https://www.baeldung.com/spring-security-registration-verification-email)
  - [Registration – Password Encoding](https://www.baeldung.com/spring-security-registration-password-encoding-bcrypt)
  - [Registration – The Registration API becomes RESTful](https://www.baeldung.com/registration-restful-api)
  - [Registration – Reset Your Password](https://www.baeldung.com/spring-security-registration-i-forgot-my-password)
  - [Registration – Password Strength and Rules](https://www.baeldung.com/registration-password-strength-and-rules)
  - [Registration – Updating your Password](https://www.baeldung.com/updating-your-password/)
  - [Registration – Purging Expired Tokens Generated By The Registration](https://www.baeldung.com/registration-token-cleanup)
  - [Registration – Auto Login User After Registration](https://www.baeldung.com/spring-security-auto-login-user-after-registration)
  - [Registration – Keep Track of Logged In Users with Spring Security](https://www.baeldung.com/spring-security-track-logged-in-users)
  - [Registration – Notify User of Login From New Device or Location](https://www.baeldung.com/spring-security-login-new-device-location)
  - [Registration – Geolocation by IP in Java](https://www.baeldung.com/geolocation-by-ip-with-maxmind)
    - Contains google maps integration as well, after getting the latitude and longitude.
  - [Registration – Roles and Privileges](https://www.baeldung.com/role-and-privilege-for-spring-security-registration)
  - [Registration – Integrate reCAPTCHA](https://www.baeldung.com/spring-security-registration-captcha)
  - [Registration – Enumeration Attacks](https://www.baeldung.com/spring-security-enumeration-attacks)
  - [Allow Authentication from Accepted Locations Only](https://www.baeldung.com/spring-security-restrict-authentication-by-geography)
  - [Prevent Brute Force Authentication Attempts](https://www.baeldung.com/spring-security-block-brute-force-authentication-attempts)
