# Javascript Outlines

## Index

## What Happens to our Code

- Syntax Parser: is a program that reads your code and determines what it does and if its grammar is valid.
- JS popular engines: V8, SpiderMonkey & Rhino.
- V8 written in c++.

![what-happens-to-our-code.png](./metadata/js/what-happens-to-our-code.png)

## Lexical Environment

Where something (your code syntax and its vocabulary) sits physically in the code?

```javascript
function hello() {
  var greet = "hello world"; // the variable sits lexically inside the function
}
```

Parsers cares about where you put things, it makes decisions.

## Execution Context

- Each time we call a function, it gets its own brand new execution context
- Every Execution Context is associated with 'Execution Context Object'
- When function is called, a new execution context is created in two phases
  - Creation phase
  - Execution phase

![Execution Context](./metadata/js/execution-context.png)
![Execution Stack](./metadata/js/execution-stack.JPG)

- Global object in case of browser is the _window_ object.
- Each (tab) window has its own global object.
- Global means not inside a function. Anything (variable or function) which is lexically not inside a function is attached to the global object.

```javascript
var name = "john"; // will be inside the `global` object (window object)
function first() {
  // will be inside the `global` object
  var a = "hello "; // will be inside the 'Variable Object' of the current execution context only
  second(); // new execution context will be created
  var x = a + name; // will be inside the 'Variable Object' of the current execution context only
  console.log("first: " + x);
}

function second() {
  // will be inside the `global` object
  var b = "hi ";
  third(); // new execution context will be created
  var z = b + name;
  console.log("second: " + z);
}

function third() {
  // will be inside the `global` object
  var c = "hey ";
  var z = c + name;
  console.log("third: " + z);
}
first();
// name === window.name // true
```

![Execution Context](./metadata/js/execution-context-3.jpg)

- The 'Variable Object' in case of global execution context is the 'window' object (global object).
- The 'scope chain' or 'outer environment' in case of global execution context is 'null' or 'nothing'.

![Execution Context](./metadata/js/execution-context-4.png)

- Hoisting in javascript: functions and variables are hoisted in javascript means they are available before execution actually starts.
- Difference between hoisting for functions and variables:
  - functions: already defined.
  - variables: undefined, only will be defined in execution phase.
- Hoisting works only with _function declaration_, and will not work with _function expression_.
  ```javascript
  var play = function () {
    // this function will not be hoisted // variable will be hoisted and assigned value of undefined
    // logic
  };
  ```

![Execution Context](./metadata/js/execution-context-5-scope-chain-1.png)
![Execution Context](./metadata/js/execution-context-5-scope-chain-2.png)

- Every execution context has a reference to its outer environment.
- **Remember**: The scope chain is only for functions defined inside functions (Lexical Scoping), check below example.
  - `first()` and `third()` attached to the global object, so it has access to 'a' variable only
  - `second()` is attached to `first()` Variable Object and has access to `first()` and global scope, so it has access to 'a', 'b' and 'c'.

![Execution Context](./metadata/js/execution-context-5-scope-chain-3.png)
![Execution Context](./metadata/js/execution-context-5-this-variable.PNG)
![Execution Context](./metadata/js/execution-context-5-this-variable-2.jpg)

Method Borrowing

![Method Borrowing](./metadata/js/method-borrowing.jpg)

## Events and Event Handler

- Events are waiting in the message queue to be processed until the execution stack is empty.
- The event will be handled only if the execution stack is empty.

![Events and Event Handler image](./metadata/js/events-and-event-handler.PNG)

## Event Bubbling, Target Element and Event Delegation

When event is triggered on some dom element (click button) then exact same event is also triggered on all of the parent elements all the way up to `<html>` element.

- Event Delegation means we can attach an event handler to a parent element, when event happens on child element, the same event will be triggered on all the parent elements up to `html`.
- When to use:
  - When you have element has a lots of child elements, and you don't want to put a listener on every child, you simply put on the parent and when the child event triggered it will also triggered on the parent, and in the event handler you can know which child element event triggered.
- Elements not yet added to the DOM. Items will be added later based on user action. Element still not exist put the handler on the parent element.

![Event Bubbling image](./metadata/js/event-bubbling-1.PNG)
![Event Bubbling image](./metadata/js/event-bubbling-2.PNG)

## DOM Traversing

When you make event delegation, and get the source element which event occures _but_ not making any action on this source element. Instead you want to make action on another element in the parent tree.

![DOM traversing Image](./metadata/js/dom-traversing.jpg)

## Prototype chain (Inheritance)

![Prototype chain image](./metadata/js/prototype-chain.jpg)
![Prototype chain image](./metadata/js/prototype-chain-1.PNG)
![Prototype chain image](./metadata/js/prototype-chain-2.PNG)

## Closure in javascript

![closure image](./metadata/js/closure-1.PNG)
![closure image](./metadata/js/closure-2.PNG)

- When the function returns (pop up from the stack), js will keep a memory space for the variables `a` and `retirementAge`, then when executing `retirementUS()` it would have access to this memory space. Execution context has gone, only memory space is exist.
- The javascript engine will always make sure that whatever function is running, it will have access to the variables that it's supposed to have access to from the outer environment.

### Closure Issue

![closure issue image](./metadata/js/closure-0.jpg)

### Closure Another Example

![Closure example](./metadata/js/closure-3.png)
![Closure example](./metadata/js/closure-4.png)
![Closure example](./metadata/js/closure-5.png)

## Asynchronous javascript

- Allow asynchronous functions to run in the background.
- We pass in callbacks that runs once the function has finished its work.
- Move on immediately - non-blocking.
- Web APIs live outside of js engine itself.
- All callback functions stay in the message queue until the execution context become empty, then the 'even loop job' will move the callbacks to execution context in order.
- 'The event loop' is monitoring the execution stack and the message queue
- There are javascript engine, rendering engine and http request.
  - If I make http request, js engine will delegate the task to 'http request'.
  - Once 'http request' finishes its work and return the data, it puts the handler in event message queue waiting the execution stack to be empty.

![asynchronous javascript image](./metadata/js/the-event-loop.PNG)

## RxJS (Reactive Extensions for JavaScript)

RxJS is a library for reactive programming using observables that makes it easier to compose asynchronous or callback-based code. The library also provides utility functions for creating and working with observables.

- [Reference on Angular site](https://angular.io/guide/rx-library)
- Rx is made up of three key points: _RX = OBSERVABLE + OBSERVER + SCHEDULERS_
  - Observable: Observable are nothing but the data streams. You can think observables as _suppliers_. They process and supply the data to other components.
  - Observers (subscriber): Observers _consumes_ the data stream emitted by the observable. Observers subscribe to the observable using `subscribe()` method to receive the data emitted by the observable. Whenever the observable emits the data all the registered observer receives the data in `onNext()` callback. Here they can perform various operations like parsing the JSON response or updating the UI. If there is an error thrown from observable, the observer will receive it in `onError()`.
  - Schedulers: Remember that Rx is for asynchronous programming and we need a thread management.
    - Schedulers are the component in Rx that tells observable and observers, on which thread they should run.
    - You can use `observeOn()` method to tell _observers_ on which thread you should observe
    - You can use `scheduleOn()` to tell the _observable_, on which thread you should run.
- Observable is Promise++. In Rx you can easily convert a Promise to an Observable by doing `var stream = Rx.Observable.fromPromise(promise);`
  - A Promise is simply an Observable with one single emitted value. Rx streams go beyond promises by allowing many returned values.

### Create an observable from a promise

```js
import { from, Observable } from "rxjs";

// Create an Observable out of a promise
const data = from(fetch("/api/endpoint"));
// Subscribe to begin listening for async result
data.subscribe({
  next(response) {
    console.log(response);
  },
  error(err) {
    console.error("Error: " + err);
  },
  complete() {
    console.log("Completed");
  },
});
```

### Create an observable from a counter

```js
import { interval } from "rxjs";

// Create an Observable that will publish a value on an interval
const secondsCounter = interval(1000);
// Subscribe to begin publishing values
const subscription = secondsCounter.subscribe((n) =>
  console.log(`It's been ${n + 1} seconds since subscribing!`)
);
```

### Create an observable from an event

```js
import { fromEvent } from 'rxjs';

const el = document.getElementById('my-element')!;

// Create an Observable that will publish mouse movements
const mouseMoves = fromEvent<MouseEvent>(el, 'mousemove');

// Subscribe to start listening for mouse-move events
const subscription = mouseMoves.subscribe(evt => {
  // Log coords of mouse movements
  console.log(`Coords: ${evt.clientX} X ${evt.clientY}`);

  // When the mouse is over the upper-left of the screen,
  // unsubscribe to stop listening for mouse movements
  if (evt.clientX < 40 && evt.clientY < 40) {
    subscription.unsubscribe();
  }
});
```

### Create an observable that creates an AJAX request

```js
import { Observable } from "rxjs";
import { ajax } from "rxjs/ajax";

// Create an Observable that will create an AJAX request
const apiData = ajax("/api/data");
// Subscribe to create the request
apiData.subscribe((res) => console.log(res.status, res.response));
```

### RxJS Operators

Operators are functions that build on the observables foundation to enable sophisticated manipulation of collections. For example, RxJS defines operators such as `map()`, `filter()`, `concat()`, and `flatMap().

#### Map Operator

```js
import { of } from "rxjs";
import { map } from "rxjs/operators";

const nums = of(1, 2, 3);

const squareValues = map((val: number) => val * val);
const squaredNums = squareValues(nums);

squaredNums.subscribe((x) => console.log(x));

// Logs
// 1
// 4
// 9
```

#### Pipe Operator

You can use pipes to link operators together. Pipes let you combine multiple functions into a single function.

```js
import { of, pipe } from "rxjs";
import { filter, map } from "rxjs/operators";

const nums = of(1, 2, 3, 4, 5);

// Create a function that accepts an Observable.
const squareOddVals = pipe(
  filter((n: number) => n % 2 !== 0),
  map((n) => n * n)
);

// Create an Observable that will run the filter and map functions
const squareOdd = squareOddVals(nums);

// Subscribe to run the combined functions
squareOdd.subscribe((x) => console.log(x));
```

The pipe() function is also a method on the RxJS Observable, so you use this shorter form to define the same operation:

```js
import { of } from "rxjs";
import { filter, map } from "rxjs/operators";

const squareOdd = of(1, 2, 3, 4, 5).pipe(
  filter((n) => n % 2 !== 0),
  map((n) => n * n)
);

// Subscribe to get values
squareOdd.subscribe((x) => console.log(x));
```

### Error handling

In addition to the `error()` handler that you provide on subscription, RxJS provides the `catchError` operator that lets you handle known errors in the observable recipe.

For instance, suppose you have an observable that makes an API request and maps to the response from the server. If the server returns an error or the value doesn’t exist, an error is produced. If you catch this error and supply a default value, your stream continues to process values rather than erroring out.

Here's an example of using the catchError operator to do this:

```js
import { Observable, of } from "rxjs";
import { ajax } from "rxjs/ajax";
import { map, catchError } from "rxjs/operators";

// Return "response" from the API. If an error happens,
// return an empty array.
const apiData = ajax("/api/data").pipe(
  map((res: any) => {
    if (!res.response) {
      throw new Error("Value expected!");
    }
    return res.response;
  }),
  catchError(() => of([]))
);

apiData.subscribe({
  next(x: T) {
    console.log("data: ", x);
  },
  error() {
    console.log("errors already caught... will not run");
  },
});
```

### Retry Failed Observable

Where the catchError operator provides a simple path of recovery, the retry operator lets you retry a failed request.

Use the `retry` operator before the `catchError` operator. It resubscribes to the original source observable, which can then re-run the full sequence of actions that resulted in the error. If this includes an HTTP request, it will retry that HTTP request.

```js
import { Observable, of } from "rxjs";
import { ajax } from "rxjs/ajax";
import { map, retry, catchError } from "rxjs/operators";

const apiData = ajax("/api/data").pipe(
  map((res: any) => {
    if (!res.response) {
      console.log("Error occurred.");
      throw new Error("Value expected!");
    }
    return res.response;
  }),
  retry(3), // Retry up to 3 times before failing
  catchError(() => of([]))
);

apiData.subscribe({
  next(x: T) {
    console.log("data: ", x);
  },
  error() {
    console.log("errors already caught... will not run");
  },
});
```

## Misc

- When JavaScript variables are declared, they have an initial value of `undefined`. If you do a mathematical operation on an `undefined` variable your result will be `NaN` which means "Not a Number". If you concatenate a string with an `undefined` variable, you will get a literal string of "undefined".
- In JavaScript all variables and function names are case sensitive. This means that capitalization matters. `MYVAR` is not the same as `MyVar` nor `myvar`.
- In mathematics, a number can be checked to be even or odd by checking the remainder of the division of the number by 2.
  ```js
  17 % 2 = 1; // (17 is Odd)
  48 % 2 = 0; // (48 is Even)
  ```
  The remainder operator is sometimes incorrectly referred to as the "modulus" operator. It is very similar to modulus, but does not work properly with negative numbers.
- Escaping Literal Quotes in Strings.
  ```js
  var sampleStr = 'Alan said, "Peter is learning JavaScript".';
  ```
- Escape sequences in strings.
  - `\'` single quote
  - `\"` double quote
  - `\\` backslash
  - `\n` newline
  - `\r` carriage return
  - `\t` tab
  - `\b` backspace
  - `\f` form feed
  ```js
  var myStr = "FirstLine\n\tSecondLine\nThirdLine";
  console.log(myStr);
  ```
- In JavaScript, String values are immutable, which means that they cannot be altered once created.
- An easy way to append data to the end of an array is via the `push()` function, the `push()` takes one or more parameters and "pushes" them onto the end of the array.
  ```js
  var arr = [1, 2, 3];
  arr.push(4);
  arr.push(["dog", 3]);
  ```
- `pop()` removes the last element from an array and returns that element.
  ```js
  var arr = [1, 4, 6];
  var lastElement = arr.pop();
  console.log(arr);
  console.log(lastElement);
  ```
- `shift()` It works just like `pop()`, except it removes the first element instead of the last.
  ```js
  var arr = [1, 4, 6];
  var firstElement = arr.shift();
  console.log(arr);
  console.log(firstElement);
  ```
- `unshift()` works exactly like `push()`, but instead of adding the element at the end of the array, `unshift()` adds the element at the beginning of the array.
  ```js
  var myArray = [
    ["Mahmoud", 23],
    ["Ahmed", 16],
  ];
  myArray.unshift(["Wessam", 35]);
  ```
- In JavaScript, scope refers to the visibility of variables. Variables which are defined outside of a function block have Global scope. This means, they can be seen everywhere in your JavaScript code.
- Variables which are used without the `var` keyword are automatically created in the global scope.
- Variables which are declared within a function, as well as the function parameters have local scope. That means, they are only visible within that function.
- A function can include the `return` statement but it does not have to. In the case that the function doesn't have a `return` statement, when you call it, the function processes the inner code but the returned value is `undefined`.
- The `case` keyword in `switch` statement is doing strict equality `===`.
- In javascript objects, you can use numbers as properties. You can even omit the quotes for single-word string properties, as follows:
  ```js
  var anotherObject = {
    make: "Ford",
    5: "five",
    model: "focus",
  };
  ```
  However, if your object has any non-string properties, JavaScript will automatically _typecast_ them as strings.
- We can use the `.hasOwnProperty(propname)` method of objects to determine if that object has the given property name. `.hasOwnProperty()` returns true or false.
- JavaScript has a `Math.random()` function that generates a random decimal number between 0 (inclusive) and not quite up to 1 (exclusive). Thus Math.random() can return a 0 but never quite return a 1
- `Math.floor(Math.random() * 20);` Generates a random number between 0 and 19.
- `Math.floor(Math.random() * (max - min + 1)) + min;` Generates a random number in any rang.
- The `parseInt(string)` function parses a string and returns an integer. `var a = parseInt("007");` It converts the string "007" to an integer 7. If the first character in the string can't be converted into a number, then it returns `NaN`.
- The `parseInt(string, radix)` function parses a string and returns an integer. It takes a second argument for the `radix`, which specifies the base of the number in the string. The radix can be an integer between 2 and 36.
  ```js
  var a = parseInt("11", 2); // The radix variable says that "11" is in the binary system, or base 2. This example converts the string "11" to an integer 3.
  var b = parseInt("FXX123", 16); // base 16 hexadecimal
  var c = parseInt("015", 10); // base 10
  var d = parseInt(15.99, 10); // base 10
  ```
- Unlike `var`, when using `let`, a variable with the same name can only be declared once.
  ```js
  let camper = "James";
  let camper = "David"; // throws an error
  ```
- `"use strict"` This enables Strict Mode, which catches common coding mistakes and "unsafe" actions. For instance:
  ```js
  "use strict";
  x = 3.14; // throws an error because x is not declared
  ```
- **Reserved Keywords in Javascript** `abstract`, `else`, `instanceof`, `switch`, `boolean`, `enum`, `int`, `synchronized`, `break`, `export`, `interface`, `this`, `byte`, `extends`, `long`, `throw`, `case`, `false`, `native`, `throws`, `catch`, `final`, `new`, `transient`, `char`, `finally`, `null`, `true`, `class`, `float`, `package`, `try`, `const`, `for`, `private`, `typeof`, `continue`, `protected`, `var`, `debugger`, `goto`, `public`, `void`, `default`, `if`, `return`, `volatile`, `delete`, `implements`, `short`, `while`, `do`, `import`, `static`, `with`, `double`, `in`, `super`, `function`.
- **void operator** The void operator evaluates the given expression and then returns `undefined`.

  ```javascript
  void (function test() {
    console.log("boo!");
    // expected output: "boo!"
  })();

  try {
    test();
  } catch (e) {
    console.log(e);
    // expected output:
    // "boo!"
    // ReferenceError: test is not defined
  }
  //*********
  void 2 == "2"; // (void 2) == '2', returns false
  void (2 == "2"); // void (2 == '2'), returns undefined
  ```

  ```html
  <a href="javascript:void(0);">
    <!-- will evaluate the experession and return undefined-->
    Click here to do nothing
  </a>

  <a href="javascript:void(document.body.style.backgroundColor='green');">
    <!-- will evaluate the experession, update background and return undefined -->
    Click here for green background
  </a>
  ```

- Using `with` keyword is not recommended, and is forbidden in ECMAScript 5 strict mode.
- **HTML 5 Standard Events**

  - Attribute: Means html element attribute.
  - Script: Indicates a Javascript function to be executed against that event.

  | Attribute          | Value  | Description                                                                                                  |
  | ------------------ | ------ | ------------------------------------------------------------------------------------------------------------ |
  | Offline            | script | Triggers when the document goes offline                                                                      |
  | Onabort            | script | Triggers on an abort event                                                                                   |
  | onafterprint       | script | Triggers after the document is printed                                                                       |
  | onbeforeonload     | script | Triggers before the document loads                                                                           |
  | onbeforeprint      | script | Triggers before the document is printed                                                                      |
  | onblur             | script | Triggers when the window loses focus                                                                         |
  | oncanplay          | script | Triggers when media can start play, but might has to stop for buffering                                      |
  | oncanplaythrough   | script | Triggers when media can be played to the end, without stopping for buffering                                 |
  | onchange           | script | Triggers when an element changes                                                                             |
  | onclick            | script | Triggers on a mouse click                                                                                    |
  | oncontextmenu      | script | Triggers when a context menu is triggered                                                                    |
  | ondblclick         | script | Triggers on a mouse double-click                                                                             |
  | ondrag             | script | Triggers when an element is dragged                                                                          |
  | ondragend          | script | Triggers at the end of a drag operation                                                                      |
  | ondragenter        | script | Triggers when an element has been dragged to a valid drop target                                             |
  | ondragleave        | script | Triggers when an element is being dragged over a valid drop target                                           |
  | ondragover         | script | Triggers at the start of a drag operation                                                                    |
  | ondragstart        | script | Triggers at the start of a drag operation                                                                    |
  | ondrop             | script | Triggers when dragged element is being dropped                                                               |
  | ondurationchange   | script | Triggers when the length of the media is changed                                                             |
  | onemptied          | script | Triggers when a media resource element suddenly becomes empty.                                               |
  | onended            | script | Triggers when media has reach the end                                                                        |
  | onerror            | script | Triggers when an error occur                                                                                 |
  | onfocus            | script | Triggers when the window gets focus                                                                          |
  | onformchange       | script | Triggers when a form changes                                                                                 |
  | onforminput        | script | Triggers when a form gets user input                                                                         |
  | onhaschange        | script | Triggers when the document has change                                                                        |
  | oninput            | script | Triggers when an element gets user input                                                                     |
  | oninvalid          | script | Triggers when an element is invalid                                                                          |
  | onkeydown          | script | Triggers when a key is pressed                                                                               |
  | onkeypress         | script | Triggers when a key is pressed and released                                                                  |
  | onkeyup            | script | Triggers when a key is released                                                                              |
  | onload             | script | Triggers when the document loads                                                                             |
  | onloadeddata       | script | Triggers when media data is loaded                                                                           |
  | onloadedmetadata   | script | Triggers when the duration and other media data of a media element is loaded                                 |
  | onloadstart        | script | Triggers when the browser starts to load the media data                                                      |
  | onmessage          | script | Triggers when the message is triggered                                                                       |
  | onmousedown        | script | Triggers when a mouse button is pressed                                                                      |
  | onmousemove        | script | Triggers when the mouse pointer moves                                                                        |
  | onmouseout         | script | Triggers when the mouse pointer moves out of an element                                                      |
  | onmouseover        | script | Triggers when the mouse pointer moves over an element                                                        |
  | onmouseup          | script | Triggers when a mouse button is released                                                                     |
  | onmousewheel       | script | Triggers when the mouse wheel is being rotated                                                               |
  | onoffline          | script | Triggers when the document goes offline                                                                      |
  | ononline           | script | Triggers when the document comes online                                                                      |
  | onpagehide         | script | Triggers when the window is hidden                                                                           |
  | onpageshow         | script | Triggers when the window becomes visible                                                                     |
  | onpause            | script | Triggers when media data is paused                                                                           |
  | onplay             | script | Triggers when media data is going to start playing                                                           |
  | onplaying          | script | Triggers when media data has start playing                                                                   |
  | onpopstate         | script | Triggers when the window's history changes                                                                   |
  | onprogress         | script | Triggers when the browser is fetching the media data                                                         |
  | onratechange       | script | Triggers when the media data's playing rate has changed                                                      |
  | onreadystatechange | script | Triggers when the ready-state changes                                                                        |
  | onredo             | script | Triggers when the document performs a redo                                                                   |
  | onresize           | script | Triggers when the window is resized                                                                          |
  | onscroll           | script | Triggers when an element's scrollbar is being scrolled                                                       |
  | onseeked           | script | Triggers when a media element's seeking attribute is no longer true, and the seeking has ended               |
  | onseeking          | script | Triggers when a media element's seeking attribute is true, and the seeking has begun                         |
  | onselect           | script | Triggers when an element is selected                                                                         |
  | onstalled          | script | Triggers when there is an error in fetching media data                                                       |
  | onstorage          | script | Triggers when a document loads                                                                               |
  | onsubmit           | script | Triggers when a form is submitted                                                                            |
  | onsuspend          | script | Triggers when the browser has been fetching media data, but stopped before the entire media file was fetched |
  | ontimeupdate       | script | Triggers when media changes its playing position                                                             |
  | onundo             | script | Triggers when a document performs an undo                                                                    |
  | onunload           | script | Triggers when the user leaves the document                                                                   |
  | onvolumechange     | script | Triggers when media changes the volume, also when volume is set to "mute"                                    |
  | onwaiting          | script | Triggers when media has stopped playing, but is expected to resume                                           |

- **JavaScript and Cookies** Web Browsers and Servers use HTTP protocol to communicate and HTTP is a stateless protocol
  But for a commercial website, it is required to maintain session information among different pages. For example:
  - cookie: plain text data thas has 5 fields.
    - Expires: Friday, May 18, 2018, 4:00:00 AM
    - Host: en.wikipedia.org
    - Path: /
    - Secure: secure
    - Name= WMF-Last-Access-Global
  - JavaScript can read, create, modify, and delete the cookies that apply to the current web page.
  - Storing Cookies: `document.cookie = "name=mahmoud;age=31;expires=date";`
  - Reading Cookies:
    ```js
    var allcookies = document.cookie;
    var cookiearray = allcookies.split(";");
    for (var i = 0; i < cookiearray.length; i++) {
      name = cookiearray[i].split("=")[0];
      value = cookiearray[i].split("=")[1];
      document.write("Key is : " + name + " and Value is : " + value);
    }
    ```
    - Deleting a Cookie: you just need to set the expiry date to a time in the past.
    ```js
    var now = new Date();
    now.setMonth(now.getMonth() - 1);
    document.cookie = "expires=" + now.toUTCString() + ";";
    ```
- **JavaScript Page Refresh**
  ```js
  function AutoRefresh(t) {
    setTimeout("location.reload(true);", t);
  }
  ```
- **JavaScript - Page Redirection**
  - When to use page redirection:
    - You did not like the name of your domain and you are moving to a new one. In such a scenario, you may want to direct all your visitors to the new site. Here you can maintain your old domain but put a single page with a page redirection such that all your old domain visitors can come to your new domain.
    - You have built-up various pages based on browser versions or their names or may be based on different countries, then instead of using your server-side page redirection, you can use client-side page redirection to land your users on the appropriate page.
    - The search engines may have already indexed your pages. But while moving to another domain, you would not like to lose your visitors coming through search engines. So you can use client-side page redirection. But keep in mind this should not be done to fool the search engine, it could lead your site to get banned.
    ```js
    <script type="text/javascript">
        function Redirect() {
            window.location="http://www.sabahallah.com";
        }
        // You can show an appropriate message to your site visitors before redirecting them to a new page. This would need a bit time delay to load a new page.
        document.write("You will be redirected to main page in 10 sec.");
        setTimeout('Redirect()', 10000);
    </script>
    ```
- **JavaScript - Dialog Boxes**
  - Alert Dialog Box [Alert box gives only one button "OK" to select and proceed]
    ```javascript
    function Warn() {
      alert("This is a warning message!");
    }
    ```
  - Confirmation Dialog Box
    ```javascript
    function getConfirmation() {
      var retVal = confirm("Do you want to continue ?");
      if (retVal == true) {
        document.write("User wants to continue!");
        return true;
      } else {
        document.write("User does not want to continue!");
        return false;
      }
    }
    getConfirmation();
    ```
  - Prompt Dialog Box
    - This dialog box is displayed using a method called `prompt()` which takes two parameters:
      - a label which you want to display in the text box and
      - a default string to display in the text box.
    - This dialog box has two buttons: OK and Cancel. If the user clicks the OK button, the window method `prompt()` will return the entered value from the text box. If the user clicks the Cancel button, the window method `prompt()` returns `null`.
    ```javascript
    function getValue() {
      var retVal = prompt("Enter your name : ", "your name here");
      document.write("You have entered : " + retVal);
    }
    getValue();
    ```
- **Methods are functions**. There is a small difference between a function and a method:
  - a function is a standalone unit of statements.
  - a method is attached to an object and can be referenced by the 'this' keyword.
- **JavaScript Native Objects**: `Number`, `Boolean`, `String`, `Array`, `Date`, `Math` and `RegExp`.
- **String HTML Wrappers**
  - **_anchor()_**: Creates an HTML anchor that is used as a hypertext target.
    ```javascript
    function getValue() {
      <script type="text/javascript">
        var str = new String("Hello world"); alert(str.anchor( "myanchor" ));
      </script>;
      // output: <a name="myanchor">Hello world</a>
    }
    getValue();
    ```
  - **_big()_**: Creates a string to be displayed in a big font as if it were in a `<big>` tag.
    ```javascript
    function getValue() {
      <script type="text/javascript">
        var str = new String("Hello world"); alert(str.big());
      </script>;
      // output: <big>Hello world</big>
    }
    getValue();
    ```
- **JavaScript - Errors & Exceptions Handling** There are three types of errors in programming:
  - _Syntax Errors_. Also called parsing errors, occur at compile time in traditional programming languages and at interpret time in JavaScript.
  - _Runtime Errors_. Also called exceptions, occur during execution (after compilation or interpretation).
  - _Logical Errors_. They occur when you make a mistake in the logic that drives your script and you do not get the result you expected.

## Interview Questions

- How many types of functions JavaScript supports?
  - A: A function in JavaScript can be either **named** or **anonymous**.
- How can you get the total number of arguments passed to a function?
  - `arguments.length`

## Functional Programming

- References:
  - <https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-1-1f15e387e536>
  - <https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-2-7005682cec4a>
  - <https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7>
  - <https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-4-18fbe3ea9e49>
  - <https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-5-c70adc9cf56a>
  - <https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-6-db502830403>
  - [The Most Adequate Guide to Functional Programming](https://mostly-adequate.gitbooks.io/mostly-adequate-guide/)
- Pure Functional Language like **Elm** or **Haskell**

### Functional Programming Characteristics

- **Purity**
  - Pure Functions are very simple functions. They only operate on their input parameters.
  - Most _useful_ Pure Functions must take at least one parameter.
  - All _useful_ Pure Functions must return something.
  - Pure Functions will always produce the same output given the same inputs.
  - Pure functions have no side effects.
- **Immutability**
  - There are no variables in Functional Programming.
  - Functional Programming uses recursion to do looping.
- **Higher-order Functions**
  In Functional Programming, a function is a first-class citizen of the language. In other words, a function is just another value. Since functions are just values, we can pass them as parameters.

  Even though Javascript is not a Pure Functional language, you can do some functional operations with it.

  Higher-order Functions either take functions as parameters, return functions or both.

- **Closures**
  A closure is a function’s scope that’s kept alive by a reference to that function.

  Note that in Javascript, closures are problematic since the variables are mutable, i.e. they can change values from the time they were closed over to the time the returned function is called.

  Thankfully, variables in _Functional Languages_ are Immutable eliminating this common source of bugs and confusion.

- **Function Composition**

  In Functional Programming, functions are our building blocks. We write them to do very specific tasks and then we put them together like Lego™ blocks.

  Javascript doesn’t do Function Composition natively.

- **Currying**
  A Curried Function is a function that only takes a single parameter at a time.

  In `Elm` and other Functional Languages, all functions are curried automatically.

  Common Functional Functions; `Map`, `Reduce` and `Filter`.

- **Referential Transparency**

  Referential Transparency is a fancy term to describe that a pure function can safely be replaced by its expression.

  The order of execution in a Pure Functional Language can be determined by the compiler. With Pure Functional Languages, we have the potential to take advantage of the CPU cores at a fine grained level automatically without changing a single line of code.

- **Type Annotations**

  ex in `elm`  
   `doSomething : String -> (Int -> (String -> String))`

## Resources

- [Udemy Javascript Course - The Complete JavaScript Course 2021: From Zero to Expert!](https://www.udemy.com/course/the-complete-javascript-course) Need
  - [Pig Game](https://piggame2.netlify.com/) (DOM manipulation)
  - [Budgety](http://budgety2.netlify.com/) (advanced JavaScript)
  - [Forkify](https://forkify.netlify.com/) (modern JavaScript and AJAX).
- Learn RxJs
  - [Reactive Programming: RxJs, Max Channel, 12 Videos, 100 minutes](https://www.youtube.com/playlist?list=PL55RiY5tL51pHpagYcrN9ubNLVXF8rGVi)
  - <https://www.learnrxjs.io/>
- [Wesbos's website](https://wesbos.com/)
- [ES5 to ESNext Every Feature Added to Javascript](https://medium.freecodecamp.org/es5-to-esnext-heres-every-feature-added-to-javascript-since-2015-d0c255e13c6e)
- [Prototypal Inheritance](https://flaviocopes.com/javascript-prototypal-inheritance/)
- [Javascript Regular Expression](https://flaviocopes.com/javascript-regular-expressions/)
- [Introduction to Unicode and UTF-8](https://flaviocopes.com/unicode/)
- [Efficiently load JavaScript with defer and async](https://flaviocopes.com/javascript-async-defer/)
- [Service Workers explained](https://flaviocopes.com/service-workers/)
- [Understanding the Fetch API](https://flaviocopes.com/fetch-api/)
- [JS operator Precedence](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Operator_Precedence)
- [JS Equality and Sameness](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Equality_comparisons_and_sameness)
- [ES6 Compatibility Table](https://kangax.github.io/compat-table/es6/)
- [Event Listeners](https://developer.mozilla.org/en-US/docs/Web/Events)
- [insertAdjacentHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/insertAdjacentHTML)
- [Dom Manipulation (you don't need jquery. it is using js only in dom manipulation)](https://blog.garstasio.com/you-dont-need-jquery/dom-manipulation/)
- [Strict Mode](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)
- Watch [this](https://www.youtube.com/watch?v=y0UklBZzjR4&ab_channel=CodingTech)
