# Javascript Examples

> To run any code in this file you have to install 'Code Runner' extension in VSC, then select the code you want to execute and press `ctrl+alt+n`.

## What is Javascript

- Javascript is a lightweight, cross platform, interpreted programming language with object-oriented capabilities.
  - lightweight means doesn't consume much memory and has simple syntax

## Topics

- variables
- objects
- functions
- this
- hoisting
- closure
- arrays
- ES6-ESNext
- callback
- promise
- async/await

## Tools

- JSLint: to check javascript code for errors and violations
- Online Js Editors: [plunker](https://plnkr.co/), [jsfiddle](https://jsfiddle.net/), [codepen](https://codepen.io/)

## Variables

- primitive datatypes in javascript (which is not objects) are: number, string, boolean, undefined, null, symbol (ES6)
- number always 64-bit floating point numbers even if it's written as integer; eg: 5 is 5.0.
- undefined: is a variable doesn't have a value yet.
- null: means 'non-existent'.
- javascript has a dynamic data type. This means data types are automatically assigned to variables.
- variables can't start with numbers, it can start with `&` and `_` only.

## Variable Mutation and Type Coercion

- Coercion is automatically converting from type to another.

```javascript
var age = 32;
console.log("age is: ", age); // age will be converted to string automatically

var job, isMarried, age;
job = "developer";
isMarried = true;
console.log("job: " + job + ", isMarried: " + isMarried + ", age: " + age); // isMarried will be converted to string and age will undefined.

var height = 30;
if (height == "30") {
  // 30 will be automatically converted to number. it does type coercion
  console.log("yes");
}
```

## Truthy and Falsy Values of Equality Operators

- Falsy values: undefined, null, 0, '', NaN (will be coerced automatically to false)
- Truthy: Not Falsy Value

```javascript
var height; // this is undefined
if (height) {
  console.log("A");
} else {
  console.log("B"); // the result
}

height = 0;
if (height || height === 0) {
  console.log("A"); // the result
} else {
  console.log("B");
}
```

## Javascript is weird

```javascript
// variables created without `var` keyword become global variables even if it's inside a function
age = 23;
function getMyName() {
  name = "mahmoud";
}
getMyName();
console.log("name: " + global.name); // it will print 'mahmoud' because the variable is set inside the global object.
```

```javascript
// another weird behavior
function getFamilyName() {
  var familyName = (surName = "mahmoud");
  // familyName will be local variable
  // surName will be global variable
}
getFamilyName(); // calling the function
console.log("familyName: " + global.familyName); // undefined
console.log("surName: " + global.surName); // mahmoud
```

```javascript
console.log(3 < 2 < 1);
// first: 3 < 2 is false
// then: false < 1 is true (because false coerced to 0, it become 0 < 1 which is true)
```

```javascript
console.log(Number(false)); // result: 0
console.log(Number(true)); // result: 1
console.log(Number(null)); // result: 0
```

```javascript
console.log(null == 0); // false, regards as a negative part of the language
console.log("" == 0); // true
console.log("" == false); // true
```

```javascript
console.log(Boolean(undefined)); // false
console.log(Boolean(null)); // false
console.log(Boolean("")); // false
```

```javascript
console.log(undefined || "hello"); // hello // it returns the value that can be coerced to true which is 'hello'
console.log(null || "hello");
console.log("" || "hello");
console.log(0 || "hello");

if (undefined || "hello") {
  // it returns 'hello', then check for existence Boolean('hello') which is true
  console.log("true");
}

// because of the above condition you may find 'default value pattern'
function printName(name) {
  name = name || "Mahmoud";
  console.log(name); // will print mahmoud
}
printName();
```

```javascript
console.log(typeof null); // object // it regards as bug in js
console.log(typeof printName); // function
```

Because of above weird behavior always use strict equality `===` & inequality `!==`. it doesn't coerce.

## Operator Precedence and Associativity

(left-to-right or right-to-left when we have the same precedence)

- precedence: `()` then `*/` then `+-`
- associativity:

```javascript
// Assignment operators are right-associative,
var a = 2,
  b = 3,
  c = 4;
a = b = c;
console.log(a); // result is 4 because associativity is from right-to-left.
console.log(b); // result is 4 because associativity is from right-to-left
console.log(c); // result is 4 because associativity is from right-to-left
```

- `6 / 3 / 2` is the same as `(6 / 3) / 2` because division is left-associative. Exponentiation, on the other hand, is right-associative, so `2 ** 3 ** 2` is the same as `2 ** (3 ** 2)`. Thus, doing `(2 ** 3) ** 2` changes the order and results in the 64.
- Remember that precedence comes before associativity. So, mixing division and exponentiation, the exponentiation comes before the division. For example, `2 ** 3 / 3 ** 2` results in 0.8888888888888888 because it is the same as `(2 ** 3) / (3 ** 2)`.

```javascript
a || b * c; // evaluate `a` first, then produce `a` if `a` is "truthy"
a && b < c; // evaluate `a` first, then produce `a` if `a` is "falsy"
a ?? (b || c); // evaluate `a` first, then produce `a` if `a` is not `null` and not `undefined`
a?.b.c; // evaluate `a` first, then produce `undefined` if `a` is `null` or `undefined`

// Short-circuiting is jargon for conditional evaluation. For example, in the expression a && (b + c), if a is falsy, then the sub-expression (b + c) will not even get evaluated, even if it is in parentheses.
```

```javascript
3 > 2 && 2 > 1;
// returns true

3 > 2 > 1;
// Returns false because 3 > 2 is true, then true is converted to 1
// in inequality operators, therefore true > 1 becomes 1 > 1, which
//  is false. Adding parentheses makes things clear: (3 > 2) > 1.
```

## Operators are Functions

```javascript
3 + 4; // '+' is a function call +(3, 4){ }
```

## Javascript is Pass by Variable or Pass by Reference

Javascript is pass by value for primitives and pass by reference for objects (including functions).

```javascript
var a = 3;
var b;
b = a; // will create a copy of the value of 'a' which is 3 and put it into 'b'

var a = {
  name: "mahmoud",
};
var b;
b = a; // will point to the same object in memory, it will not create a new memory space
// even if we pass the variable as a parameter to a function
var test = function (a) {};
test(a); // will pass the same object reference
```

## Objects

JavaScript objects are dynamic, you can add or remove properties or functions at runtime.

### Creating Object

There're different ways to create objects in javascript.

#### Creating Object Using **Object Literal**

```javascript
var bear = {
  color: "grey",
  age: 10,
  type: "sloth",
};
```

#### Creating Object Using **`new`** Keyword

```javascript
var bear = new Object();
bear.color = "grey";
bear.age = 10;
bear.type = "sloth";
```

#### Creating Object Using **Constructor Function**

Constructor function: - a normal function that is used to construct objects - The `this` variable inside the function points to a the new empty object, and that object is returned from the function automatically

```javascript
function Bear(color, age, type) {
  this.color = color;
  this.age = age;
  this.type = type;
  this.describe = function () {
    console.log("color: ", color, ";age: " + age);
  };
}

var slothBear = new Bear("grey", 10, "sloth");
```

Steps:
1- new: js will create new empty object {}.
2- Bear function will be called and `this` inside the function will point to this newly created object.
3- js will return this new object automatically as long as the function doesn't return any other object (functions may return objects).

#### Creating Object Using **`Object.create()`**

```javascript
var personProto = {
  calculateAge: function (yearOfBirth) {
    return 2021 - yearOfBirth;
  },
};

var mahmoud = Object.create(personProto);
mahmoud.name = "mahmoud";
mahmoud.age = 32;
console.log(mahmoud.calculateAge(1986));
```

#### Creating Object Using **Prototype Pattern**

```javascript
var PersonProto = Object.create(null); //this is an empty object, like {}
PersonProto.prototype = {
  // things to be available for inheritance
  calculateAge: function (yearOfBirth) {
    return 2021 - yearOfBirth;
  },
};

var mahmoud = Object.create(PersonProto.prototype, {
  name: { value: "mahmoud" },
  age: { value: 32 },
  job: { value: "developer" },
});
console.log(mahmoud.name);
console.log(mahmoud.calculateAge(1986));
```

### JSON to Object and Vice Versa

```javascript
var jsonObj = JSON.stringify({ color: "grey", age: 10, type: "sloth" }); // Javascript object to JSON object
console.log("jsonObj: " + jsonObj);
var jsObj = JSON.parse(jsonObj); // JSON object to javascript object
console.log("jsObj color: " + jsObj.color);
```

### Accessing Properties of an Object

```javascript
var color = slothBear.color;
// or
color = slothBear["color"];
console.log(color);
```

### deleting properties from an object

```javascript
delete slothBear.color;
```

### Notes about objects

- Javascript objects are mutable, that means they can be changed
- Javascript objects are reference type, not value

  ```javascript
  var myObj = { name: "mahmoud" };
  var yourObj = myObj; // both variables pointing to the same object in memory
  ```

- Arrays are also of type Object

  ```javascript
  var chars = ["a", "b", "c"];
  console.log(chars); // __proto__ of 'chars' is Array(0) which has __proto__ of Object
  ```

### Primitives vs Objects

```javascript
var a = 26;
var b = {
    test: true;
}
function change(a, b){
    a = 30;
    b.test = false;
}
change(a, b);
console.log('a: ', a); // 'a' will not change because we passed a copy
console.log('a: ', b); // 'b' will change because it is a reference
```

## `**this**` Keyword

Rules: Only during object method call `this` keyword will point to that object. - But in regular function call, `this` keyword will always point to the global object.

```javascript
var mahmoud = {
  name: "mahmoud",
  age: 32,
  code: function () {
    console.log(this.name + " is coding");
    return function sleep() {
      console.log(this.name + " is sleeping");
    };
  },
};

mahmoud.code()();
// will print
// mahmoud is coding, because when calling code() 'this' has access to the object itself
// undefined is sleeping, when calling sleep() it will make new execution context, and it doesn't have access to the object itself,
// it will try to find it in global object and will not find
```

### `this` with arrow function

arrow function doesn't have `this` keyword, they use `this` of the function they are written in.
So we say they have 'lexical this variable'

Check below examples, Complete explanation in Lecture 108, check it out.

```javascript
var box5 = {
  color: "green",
  position: 1,
  clickMe: function () {
    document.querySelector(".green").addEventListener("click", function () {
      // this will point to global object
      // remember the above rules, this will point to global object if it's regular function call
      var str =
        "This is box number " + this.position + " and it is " + this.color;
      alert(str);
    });
  },
};
box5.clickMe();

// To fix this problem, there is a common pattern to avoid this problem using self variable
var box5 = {
  color: "green",
  position: 1,
  clickMe: function () {
    var self = this;
    document.querySelector(".green").addEventListener("click", function () {
      // now 'self' pointing to the current object and not the global object
      var str =
        "This is box number " + self.position + " and it is " + self.color;
      alert(str);
    });
  },
};
box5.clickMe();

// using arrow function, 'this' will point the surrounding object
var box5 = {
  color: "green",
  position: 1,
  clickMe: function () {
    document.querySelector(".green").addEventListener("click", () => {
      // now after converting to arrow function, it will point to the object itself, same like 'self' hack
      var str =
        "This is box number " + this.position + " and it is " + this.color;
      alert(str);
    });
  },
};

// imagine what will happen if we changed the clickMe function also to be an 'arrow function'
// 'this' will point to the global object again! Why! because clickMe function points to surrounding object which is 'global object'
// and the callback pointing to the surrounding object which points to global object
var box5 = {
  color: "green",
  position: 1,
  clickMe: () => {
    document.querySelector(".green").addEventListener("click", () => {
      // 'this' point to the global object again
      var str =
        "This is box number " + this.position + " and it is " + this.color;
      alert(str);
    });
  },
};
box5.clickMe();
```

## Prototypal Inheritance `__proto__` && `prototype`

- Almost everything in javascript is an object.
- Only primitives: numbers, strings, booleans, undefined, null.
- Anything else is object: Arrays, Objects, Date, Wrapper Classes (Number, String), function...
- Inheritance done in javascript by something called `prototype`
- Each and every javascript object has a `prototype` property which makes inheritance possible in javascript.
- The `prototype` property of an object is where you put methods and properties to be inherited.

```javascript
var Person = function (name, age) {
  this.age = age;
  this.name = name;
  // Every time i create new object, this function will be copied to the new object (and takes memory), so better to put it in the `prototype` property
  // this.play = function (){
  // console.log('playing');
  // }
};
Person.prototype.city = "Dubai";
Person.prototype.play = function () {
  // now we have one instance of the method, all objects are using it
  console.log("playing");
};
Person.prototype.printName = function () {
  console.log("name is " + this.name); // this will point to the calling object
};

var mahmoud = new Person("mahmoud", 32); // now mahmoud will inherit city,  play and printName functions
mahmoud.play();
mahmoud.printName();
mahmoud.profession = "developer";

console.log(mahmoud.hasOwnProperty("profession")); // will be true // It looks for own property not parent property
console.log(mahmoud instanceof Person); // will be true

console.log(mahmoud.__proto__ === Person.prototype); // will be true
// __proto__ : refers to the parent
// prototype : refers to itself (what to be inherited)

// Same for Person, it inherits by default from Function
console.log(Person.__proto__ === Function.prototype);
```

`__proto__` is the actual object that is used in the lookup chain to resolve methods, etc. `prototype` is the object that is used to build `__proto__` when you create an object with `new`:

```javascript
new Foo().__proto__ === Foo.prototype;
new Foo().prototype === undefined;
```

Another examples

```javascript
// object
var athlete = {
  name: "mahmoud",
  sport: "swimming",
};
console.log(athlete.__proto__.toString()); // because its parent is Object

// function
var play = function () {
  console.log("playing");
};

console.log(play.__proto__); // f() {} // empty, this is the prototype of all functions // play.__proto__bind()
console.log(play.__proto__.__proto__ === Object.prototype); // object // true

// array
var c = [];

console.log(c.__proto__); // Array // c.__proto__.indexOf()
console.log(c.__proto__.__proto__ === Object.prototype); // object // true

// reflection & extend
for (const prop in mahmoud) {
  if (mahmoud.hasOwnProperty(prop)) {
    // look into the object itself not the parent // this is the reflection
    console.log("mahmoud own prop: " + prop);
  } else {
    console.log("mahmoud's parent prop" + prop);
  }
}

// in underscore library you can do this \_.extend(mahmoud, ahmed, wessam)
// source: ahmed, wessam
// dist: mahmoud
// it will loop through all the source objects, check its properties and CREATE in the dist, it is not making reference, no it is creating

String.prototype.isGreaterThan = function (limit) {
  return this.length > limit;
};
console.log("Mahmoud".isGreaterThan(9));
```

## Arrays

- Arrays are fundamental concept in javascript
- Arrays are also objects

### Creating Array, Adding and Removing Items

```javascript
var names = ["mahmoud", "ahmed", "wessam"]; // literal array
var years = new Array(1986, 1987, 1990, 1996); // condensed array

names[0] = "Mahmoud"; // mutate an array
names.push("Muhammad"); // add to the end of the array
names.unshift("Mum"); // add to the beginning of the array
console.log(names);
names.pop(); // remove element from the end
names.shift(); // remove element from the beginning
console.log(names);
var containsM = names.every(function (element) {
  return element.indexOf("m") != -1;
});
console.log(containsM); // will return `true` only if every element satisfy the function

var containsHm = names.filter(function (element) {
  if (element.indexOf("hm") != -1) {
    return element;
  }
});
console.log(containsHm); // will return new array contains the filtered elements

var allNames = names.join("|"); // Joins all elements of an array into a string. // if you not pass separator, separator will be `,`
console.log(allNames);

// delete item from an array
var numbers = [9, 2, 10];
numbers.splice(1, 1); // (start index to delete, number of elements to remove)
console.log(numbers); // [ 9, 10 ]

// Splice vs Slice
// Splice: mutate original array
// Slice: doesn't mutate original array

console.log([50, 4, 6].splice(1, 2)); // (start index, how many items) // result will be [4, 6] // original array [50]
console.log([458, 84, 696].splice(1, 1)); // (start index, how many items) // result will be [84] // original array [458, 696]

console.log([50, 4, 6].slice(1, 2)); // (start index, end index but not included) // result will be [4] // original array [50, 4, 6] not changed
console.log([458, 84, 696].slice(1, 1)); // (start index, end index but not included) // result will be [] // original array [458, 84, 696] not changed

// in arrays, don't use for in, use normal for loop
Array.prototype.myCustomFeature = "!cool";
var arr = ["45", "5465", "88"];
for (const index in arr) {
  console.log(index + ": " + arr[index]);
}
// result:
// 0: 45
// 1: 5465
// 2: 88
// myCustomFeature: !cool

// it is converting to an object and then looping through it.
// always use for(var i=0; i<arr.length; i++)
```

### Clone Array

```javascript
// best way to clone array is way-8

// way-1 Spread Operator (Shallow copy)
numbers = [1, 2, 3];
numbersCopy = [...numbers]; // This doesn’t safely copy multi-dimensional arrays. Array/object values are copied by reference instead of by value.

numbersCopy.push(4);
console.log(numbers, numbersCopy); // [1, 2, 3] and [1, 2, 3, 4] // numbers is left alone

nestedNumbers = [[1], [2]];
nestedNumbersCopy = [...nestedNumbers];
nestedNumbersCopy[0].push(300);

console.log(nestedNumbers, numbersCopy); // [[1, 300], [2]] & [[1, 300], [2]] // They've both been changed because they share references.

// Way-2 Good Old for() Loop (Shallow copy)
numbers = [1, 2, 3];
numbersCopy = [];
for (i = 0; i < numbers.length; i++) {
  // this doesn’t safely copy multi-dimensional arrays. Since you’re using the = operator, it’ll assign objects/arrays by reference instead of by value.
  numbersCopy[i] = numbers[i];
}

// -- this is fine
numbersCopy.push(4);
console.log(numbers, numbersCopy); // [1, 2, 3] and [1, 2, 3, 4]// numbers is left alone

// this not ok
nestedNumbers = [[1], [2]];
numbersCopy = [];
for (i = 0; i < nestedNumbers.length; i++) {
  numbersCopy[i] = nestedNumbers[i];
}
numbersCopy[0].push(300);
console.log(nestedNumbers, numbersCopy); // [[1, 300], [2]]// [[1, 300], [2]]// They've both been changed because they share references

// way-3 Good Old while() Loop (Shallow copy)
numbers = [1, 2, 3];
numbersCopy = [];
i = -1;
while (++i < numbers.length) {
  // This also assigns objects/arrays by reference instead of by value.
  numbersCopy[i] = numbers[i];
}

// this is ok
numbersCopy.push(4);
console.log(numbers, numbersCopy); // [1, 2, 3] and [1, 2, 3, 4]// numbers is left alone

// This is not ok
nestedNumbers = [[1], [2]];
numbersCopy = [];
i = -1;
while (++i < nestedNumbers.length) {
  numbersCopy[i] = nestedNumbers[i];
}
numbersCopy[0].push(300);
console.log(nestedNumbers, numbersCopy); // [[1, 300], [2]]// [[1, 300], [2]]// They've both been changed because they share references

// way-4 Array.map (Shallow copy)
numbers = [1, 2, 3];
numbersCopy = numbers.map((x) => x); // This also assigns objects/arrays by reference instead of by value.
console.log(numbers, numbersCopy);

// way-5 Array.filter (Shallow copy)
numbers = [1, 2, 3];
numbersCopy = numbers.filter(() => true); // This also assigns objects/arrays by reference instead of by value.
console.log(numbers, numbersCopy);

// way-6 Array.reduce (Shallow copy)
numbers = [1, 2, 3];
// reduce transforms an initial value (here is empty array) as it loops through a list.
numbersCopy = numbers.reduce((newArray, element) => {
  // This also assigns objects/arrays by reference instead of by value.
  newArray.push(element);
  return newArray;
}, []);
console.log(numbers, numbersCopy);

// way-7 Array.slice (Shallow copy)
// slice returns a shallow copy of an array based on the provided start/end index you provide.
// If we want the first 3 elements:
[1, 2, 3, 4, 5].slice(0, 3); // [1, 2, 3]// Starts at index 0, stops at index 3
// If we want all the elements, don’t give any parameters

numbers = [1, 2, 3, 4, 5];
numbersCopy = numbers.slice(); // [1, 2, 3, 4, 5] // This is a shallow copy, so it also assigns objects/arrays by reference instead of by value.
console.log(numbers, numbersCopy);

// wy-8 JSON.parse and JSON.stringify (Deep copy)
// JSON.stringify() turns an object into a string.
// JSON.parse() turns a string into an object.
// This way safely copies deeply nested objects/arrays!

nestedNumbers = [[1], [2]];
numbersCopy = JSON.parse(JSON.stringify(nestedNumbers));
numbersCopy[0].push(300);
console.log(nestedNumbers, numbersCopy); // [[1], [2]] // [[1, 300], [2]] // These two arrays are completely separate!

// way-9 Array.concat (Shallow copy)
// concat combines arrays with values or other arrays.

[1, 2, 3].concat(4); // [1, 2, 3, 4]
[1, 2, 3].concat([4, 5]); // [1, 2, 3, 4, 5]

// If you give nothing or an empty array, a shallow copy’s returned.
[1, 2, 3].concat(); // [1, 2, 3]
[1, 2, 3].concat([]); // [1, 2, 3] // This also assigns objects/arrays by reference instead of by value.

// way-10 Array.from (Shallow copy)
// This can turn any iterable object into an array. Giving an array returns a shallow copy.
numbers = [1, 2, 3];
numbersCopy = Array.from(numbers); // [1, 2, 3] // This also assigns objects/arrays by reference instead of by value.
```

### ES6 convert array to list

```javascript
let ingredient = ["lemon"];
let extraIngredient = ["tea", "coffee"];
ingredient.push(...extraIngredient); // push accepts list only not array[]
console.log(ingredient);
```

## Date

```javascript
var msecs = Date.parse(new Date());
console.log("Number of milliseconds from 1970: " + msecs); // Output is: Number of milliseconds from 1970: 1219946400000

var msecs = Date.UTC(2008, 9, 6);
console.log("Number of milliseconds from 1970 for UTC: " + msecs); // Output is: Number of milliseconds from 1970: 1223251200000
```

## Functions

- In javascript functions are objects, because of that function can take function as argument and can be returned by other function
- Javascript is event driven language, means it will not wait for event response, it will keep listening to other events
- Why javascript is first class functions:
  1- Function is an instance of object.
  2- Function behaves like any other object.
  3- We can store function in a variable.
  4- We can pass function as an argument to another function.
  5- We can create a function inside a function.
  6- we can return a function from a function.

```javascript
// function declaration
function first() {
  setTimeout(() => {
    console.log("first function");
  }, 500);
}

// function expression (Unit of code results in a value)
var second = function second() {
  console.log("second function");
};
first();
second();

// result will be:
// second function
// first function
```

Javascript function always return a value, when no return statement, then function returns `undefined`

Javascript has 'Argument Flexibility' means when calling the function, you can pass more or less than the 'function arguments'.

```javascript
function calc(a, b, c){
    ...
}
calc(1, 2); // c will be undefined
```

Each Javascript function has 'arguments' object, you can use to know the number of passed arguments or to loop over them.

```javascript
function add(a, b, c) {
  var result = 0;
  for (i = 0; i < arguments.length; i++) {
    result += arguments[i];
  }
  return result;
}
console.log(add(9, 1, 8));
```

### Constructor Functions

```javascript
function Programmer(name, company) {
  this.name = name;
  this.company = company;
  this.writeCode = function () {
    console.log("writing code...");
  };
  this.makeSkypeCall = function () {
    console.log("making skype call...");
  };
}

var javaProgrammer = new Programmer("Mahmoud", "Omnix International");
console.log(javaProgrammer.company);
javaProgrammer.writeCode();

// you have to use `new` keyword, if you forgot to use `new` keyword, `this` inside the function will point to the global object

var javaDeveloper = Programmer("Mahmoud", "Omnix International"); // now i'm calling the function itself, name and company will set to global variable
console.log(javaDeveloper); // will be undefined, because function always return a value
console.log(global.name);
console.log(global.company);

// Possible solution for this issue

function Programmer_2(name, company) {
  if (!(this instanceof Programmer_2)) {
    return new Programmer_2(name, company);
  }
  this.name = name;
  this.company = company;
  this.writeCode = function () {
    console.log("writing code...");
  };
  this.makeSkypeCall = function () {
    console.log("making skype call...");
  };
}

var javaDeveloper = Programmer_2("Mahmoud_2", "Omnix International_2");
console.log(javaDeveloper);
```

#### The `Function()` Constructor

```javascript
var func = new Function("x", "y", "return x*y;");
function secondFunction() {
  var result;
  result = func(10, 20);
  console.log(result);
}
secondFunction();

// Function is an object, so you can do following
function greet() {
  console.log("Hi");
}
greet.useName = "mahmoud";
console.log(greet.useName); // result: mahmoud

// javascript doesn't have 'function overloading' because functions are objects in javascript.
```

## Hoisting

Hoisting in javascript means that the interpreter moves all variables declarations up to the top of their scope.
This applies to the variables and function declarations.
Only declarations is hoisted and not the initialization.

```javascript
// Variable Hoisting Example

console.log("testing hoisting with variable" + x);
// if you run above statement alone it will throw 'Uncaught ReferenceError' because it didn't find x in the global object
// but what if we do
console.log("testing hoisting with variable " + x);
var x = 100;
console.log("testing hoisting with variable " + x);

// result will be:
// testing hoisting with variable undefined
// testing hoisting with variable 100

// because javascript moves all variable declarations to the top of the scope, it moves variable declaration only not initialization

// var x;
// console.log('testing hoisting with variable ' + x);
// x = 100;
// console.log('testing hoisting with variable ' + x);
```

```javascript
// Function Hoisting Example
// It's like variables hoisting but the function block at all moves to the top of the scope

printGoodMorning();
function printGoodMorning() {
  console.log("Good Morning!");
}

// output: Good Morning! because it will move the function block to the top

function printGoodMorning() {
  console.log("Good Morning!");
}
printGoodMorning();

// Be carful: function expression not hoisted

console.log(sayHello);
sayHello();
var sayHello = function () {
  console.log("hello...");
};

// output:
// undefined
// TypeError: sayHello is not a function
// Why! beacuse it is converted to:
// var sayHello; // this is undefined
// console.log(sayHello);
// sayHello();
// var sayHello = function (){
//     console.log('hello...');
// }
```

## Strict Mode

- add some extra rules
- if you want to use strict mode, put "use strict"; at the beginning of the file or inside any function `function play(){ "use strict" }`
- it's a good practice to run your code in strict mode.
- each browser has its own rules for strict mode.
- if you have more than one javascript file, and the first file uses strict mode, so strict mode will be applied to all files, so be careful.

## Callback Functions

Callback functions are probably the most widely used **functional programming** technique in javascript.

## Using `this` Keyword with Callback Function

```javascript
function callUserInput(firstName, secondName, callback) {
  if (typeof callback === "function") {
    // it is a good practice to make the callback function optional
    callback(firstName, secondName);
  }
}

var clientData = {
  id: 12654,
  fullName: null,
  setUserName: function (firstName, secondName) {
    this.fullName = firstName + " " + secondName;
    console.log("inside setUserName: " + this.fullName);
    console.log("inside setUserName: " + global.fullName);
  },
};
clientData.setUserName("Mahmoud", "SabahAllah"); // here i'm calling the object method itself.
console.log(clientData.fullName);

callUserInput("Ahmed", "Sabah Allah ", clientData.setUserName);
`here i'm passing the function definition itself, so the scope of 'this' when calling the function will be the global scope`;

console.log(clientData.fullName);
console.log(global.fullName);

// to solve this issue, you need to use `call` or `apply` methods
console.log(" ------ after fix using apply() ------ ");

function callUserInput_2(firstName, secondName, callback, callbackObject) {
  // sending the callback function and the object itself
  if (typeof callback === "function") {
    callback.apply(callbackObject, [firstName, secondName]); // now this will point to the current object not the global object
  }
}

var clientData_2 = {
  id: 12654,
  fullName_2: null,
  setUserName: function (firstName, secondName) {
    this.fullName_2 = firstName + " " + secondName;
    console.log("inside setUserName_2: " + this.fullName_2);
    console.log("inside setUserName_2: " + global.fullName_2);
  },
};

callUserInput_2(
  "Wessam",
  "Sabah Allah ",
  clientData_2.setUserName,
  clientData_2
);

console.log(clientData_2.fullName_2);
console.log(global.fullName_2);

// You can send any number of callback functions
// try not to nest more callbacks
// You can create named functions and send it. ex: const play = ()=> console.log('play');
```

## Javascript Closure

Closure is an inner function that has always access to the outer (enclosing) function's variables scope, even after the outer function has returned.

- Closures are used extensively in NodeJs asynchronous & non-blocking architecture.
- Outer function's variables: Closures have access to the outer function's variables even after the outer function returns.
- Outer function's arguments: Closures have access to the outer function's parameters even after the outer function returns.
- Global Variables: Closures have access to the global scope variables.

```javascript
function showName(firstName, lastName) {
  var namePrefix = "Your name is: ";
  function fullName() {
    return namePrefix + firstName + " " + lastName;
  }
  return fullName;
}

console.log(showName("Mr. Mahmoud", "Sabahallah")()); // here showName will return fullName function, and after calling it, it still have access to the outer function's variable namePrefix

// another example

function celebrityName(firstName) {
  var celebrityPrefix = "Celebrity Name is: ";
  function lastName(lastName) {
    return celebrityPrefix + firstName + " " + lastName;
  }
  return lastName;
}

console.log(celebrityName("Mahmoud")("SabahAllah")); // lastName function will have access to 'firstName' and 'celebrityPrefix' even after the celebrityName() has finished execution

// another example (issue) with closure

function celebrityIdCreator(celebrities) {
  var i;
  var uniqueId = 100;

  for (i = 0; i < celebrities.length; i++) {
    celebrities[i].id = function () {
      return uniqueId + i;
    };
  }
  return celebrities;
}

var actors = [
  { name: "mahmoud", id: 0 },
  { name: "ahmed", id: 0 },
  { name: "wessam", id: 0 },
];
var finalCelebrities = celebrityIdCreator(actors);
console.log(finalCelebrities[0].id());
console.log(finalCelebrities[1].id());
console.log(finalCelebrities[2].id());

// Problem description

// during the iteration in each loop, it will assign the same function definition to id (it will not evaluate the function and return the value itself)
// so 'i' changing every time but function definition is the same not changing, then function execution finished and returning the celebrities object.
// now when calling celebrities item id() it will call the function which has access to the outer's scope variable and last values is 3 and 100;
// so all the elements will have the same value 103.
```

## IIFE (Immediately Invoked Function Expression)

- We using the IIFE to overcome the problem of overriding variables in the global scope.
- Now i'm telling js compiler to call the function immediately, if i didn't put parentheses it will be normal function.
- Jquery using IIFE too much
- It creates new scope which is hidden from outside scope, so we can safely put variables, so you'll obtain data privacy and don't interfere with variables in our global execution context.

```javascript
(function () {
  // All code and variables inside this function is local to this scope only
  // You can't see what is inside from outside
  console.log("play");
})(); // Means turn everything inside () to 'function expression', you can't put statements inside ()

// another form

(function () {
  // all code and variables inside this function is local to this scope only
  console.log("play");
})();

// IIFE with params
(function (name) {
  console.log(name);
})("SabahAllah");
```

Global Variables are Evils in javascript

```javascript
function getName() {
  return "samsung";
}

function suggestPhone() {
  productName = "iphone";
  return productName;
}
var productName = getName();
suggestPhone(); // this will change the productName global variable
console.log(productName);

// Solution for this issue to put the code in IIFE function
// In object oriented programming, class contains variables and methods and it could be public or private, but in javascript no private concept but we can achieve this using IIFE.

var module = (function () {
  var privateFunction = function () {
    console.log("this is private function");
  };

  return {
    publicVariable: "mahmoud",
    publicFunction: function () {
      privateFunction();
    },
  };
})();

console.log(module.publicVariable);
module.publicFunction();
```

TODO: search for revealing module pattern

## Default Parameters

Starting from ECMAScript6 you can send default parameter value.

```javascript
function greet(name, profession = "developer") {
  console.log("Name: " + name + " & profession: " + profession);
}
greet("Ahmed");
greet("Mahmoud", "Full Stack Developer");

const a = [15, 012, 3, 4, 5];
const [first, second] = a;
console.log(first); //15
console.log(second); //10 how!
```

## ES6

### `let` & `const`

- variables declarations with `let` and `const` are block scope.
- variables declarations with `var` is function scope.

```javascript
let name = "mahmoud"; // you can mutate
const surName = "Sabah Allah"; // constant you can't mutate

// example
function test() {
  if (true) {
    // block scope
    let x = 10;
    let y = 15;
  }
  console.log(x); // not defined outside of its scope // ReferenceError: x is not defined
}
test();

// on contrary
function test() {
  if (true) {
    var x = 10;
    var y = 15;
  }
  console.log(x); // will be 10
}
test();

// example
let i = 23;
for (let i = 0; i < 5; i++) {
  // i inside block scope only
  console.log(i);
}
console.log(i); // 23

// on contrary
var i = 23;
for (var i = 0; i < 5; i++) {
  console.log(i);
}
console.log(i); // will be 5

// with let & const: You have to declare the variable before use
// This is done by something called 'Temporal-Dead Zone' TDZ
// 'Temporal-Dead Zone' TDZ: variables still hoisted but we can't access before declaration
(function kick() {
  console.log(power); // will throw ReferenceError: power is not defined
  let power;
})();
```

### IIFE

New way to write IIFE

```javascript
(function () {})();

{
  // this is also block
  const a = 1;
  const b = 2;
  var c = 3;
}
console.log(a); // not accessible // ReferenceError: a is not defined
console.log(b); // not accessible // ReferenceError: a is not defined
console.log(c); // accessible, because var is not block scope
```

### Strings

#### Template Literals

```javascript
var name = "Mahmoud";
console.log(`this is ${name}`); // result: This is Mahmoud
```

#### string new methods

```javascript
let name = "Mahmoud";
console.log(name.startsWith("M")); // true
console.log(name.endsWith("d")); // true
console.log(name.includes("hmo")); // true
console.log(name.repeat(5));
```

### Arrow function

```javascript
let play = (name, club) => console.log(`${name} is playing in ${club} club`);
play("mahmoud", "Ahly");
```

### `for-of` Loop

```javascript
//iterate over the value
for (const v of ["a", "b", "c"]) {
  console.log(v);
}

//get the index as well, using `entries()`
for (const [i, v] of ["a", "b", "c"].entries()) {
  console.log(`index: ${i} value: ${v}`);
}
```

Notice the use of `const`. This loop creates a new scope in every iteration, so we can safely use that instead of `let`.

The difference with for...in is:
for...of iterates over the property values
for...in iterates the property names

```javascript
var person = { fname: "John", lname: "Doe", age: 25 };

var text = "";
for (var x in person) {
  text += person[x] + " ";
}
```

### Destructuring

It gives us a very convenient way to extract data from data structure like an array
[Destructuring Reference](https://hacks.mozilla.org/2015/05/es6-in-depth-destructuring/)

```javascript
// With Array
// ES5
var mahmoud = ["mahmoud", 26];
var name = mahmoud[0];
var age = mahmoud[1];

// ES6
const [name, age] = ["mahmoud", 26];
console.log(name);
console.log(age);

// With Object
// ES5
const fullName = {
  firstName: "Mahmoud",
  lastName: "SabahAllah",
};

//const {firstName, lastName} = fullName;
const { firstName: a, lastName: b } = fullName; // using alias
console.log(a);
console.log(b);

// Setting Default Values During Assignment

const userSettings = { nightMode: true, fontSize: "large" };

const {
  // defaults
  nightMode = false,
  language = "en",
  fontSize = "normal",
} = userSettings;

console.log(nightMode); // true
console.log(language); // 'en'
console.log(fontSize); // 'large'

// Destructuring Named Function Arguments
function sum({ a = 1, b = 2, c = 3 }) {
  return a + b + c;
}

console.log(sum({ b: 10, a: 5 })); // 5 + 10 + 3 = 18

// Using Destructuring To Cleanly Parse a Server Response
// Often we only care about the data block or even one specific value in the data block of a server response.
// If that is the case, you can use destructuring to only grab that value while ignoring a lot of the other things a server typically sends back
// This pattern allows you to pull out values from an object as your arguments are being parsed.
// You also get to set up defaults for free!
function mockServerCall() {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve({
        status: 200,
        "content-type": "application/json",
        data: {
          dataOfInterest: 42,
        },
      });
    }, 250);
  });
}

mockServerCall().then(({ data: { dataOfInterest = 100 } }) => {
  console.log(dataOfInterest); // 42 (but would default to 100)
});
```

### Arrays New Features

```javascript
// ES5
const boxes = document.querySelectorAll(".box"); // will return a nodelist
// convert to array
var boxArray = Array.prototype.slice.call(boxes);
boxArray.foreach(function () {
  // logic
});

// ES6
var boxArray = Array.from(boxes).forEach(function () {
    ...
});

// ES5
for (let index = 0; index < boxArray.length; index++) {
  const element = boxArray[index];
}

// ES6
for (const current of boxes) {
}

// ES6
var ages = [12, 17, 8, 21, 22];
let above18Index = ages.findIndex((curr) => curr >= 18); // will return first occurrence only
console.log(ages[above18Index]);

let above15 = ages.find((curr) => curr >= 15); // will return first occurrence only
console.log(above15);
```

### Spread Operator

```javascript
// ES5
function add(a, b, c, d) {
  return a + b + c + d;
}

var ages = [12, 18, 98, 23];
var sum = add.apply(null, ages); // we can't pass array directly to the function eg: add(ages)

// ES6
var sum = add(...ages); // will convert the array to arguments, this is called expanding

// Another Case
const teamA = ["1", "52", "500"];
const teamB = ["19", "89", "79"];

const allTeams = [...teamA, ...teamB];
console.log(allTeams);

// Another Case
const circle = document.querySelector(".circle");
const boxes = document.querySelectorAll(".box");
const all = [circle, ...boxes];

Array.from(all).forEach((curr) => (curr.style.color = "purple"));
```

### Rest Parameters

Pass number of arguments into a function
Spread Operator: Convert array to single elements
Rest Operator: Convert single elements to array during function call

```javascript
// ES5
function isValidAges() {
  console.log(arguments); // will print { '0': 1990, '1': 1991, '2': 1992 } // Arguments[3] is array like structure not array
  // to convert arguments to real array
  var args = Array.prototype.slice.call(arguments);
  console.log(args); // will print [ 1990, 1991, 1992 ]
}
isValidAges(1990, 1991, 1992);

// ES6

function isValidAges(school, ...years) {
  console.log(school);
  console.log(years); // will print [ 1990, 1991, 1992 ] because ...years is array
}

isValidAges("Talat Harb", 1990, 1991, 1992);
```

### Maps

- new entirely data structure
- keys could be anything, primitive, object, function

```javascript
const question = new Map();
question.set("x", "y");
question.set(8, "ok");
console.log(question.get("x"));
console.log(question.size);
question.delete("x");
console.log(question);

if (question.has(8)) {
  console.log("yes has 8");
} else {
  console.log("not have 8");
}

for (let [key, value] of question.entries()) {
  // destructing
  console.log(`for:: key: ${key}, value: ${value}`);
}

question.clear();
console.log(question);
```

### Dynamic properties

```javascript
const x = {
  ["a" + "_" + "b"]: "z",
};
console.log(x.a_b); // z
```

### Classes

Important notices about Classes:

- Class definition is not hoisted unlike function constructor.
- You can add only methods to classes not properties

```javascript
// ES5
var Programmer = function (name, yearOfBirth) {
  this.name = name;
  this.yearOfBirth = yearOfBirth;
};
Programmer.prototype.calculateAge = function () {
  // some logic
};

// ES6
class Programmer {
  // let name= 0; // not valid // You can add only methods to classes not properties
  constructor(name, yearOfBirth) {
    this.name = name;
    this.yearOfBirth = yearOfBirth;
  }

  calculateAge() {
    return 2021 - this.yearOfBirth;
  }

  static code() {
    console.log("coding...");
  }
}

const mahmoud = new Programmer("mahmoud", 32);
console.log(mahmoud.calculateAge());
Programmer.code();
```

### Inheritance

```javascript
// ES5
// Parent
var Person = function (name, age) {
  this.name = name;
  this.age = age;
};

Person.prototype.calculateAge = function (yearOfBirth) {
  this.age = 2021 - yearOfBirth;
};

// Child
var Athlete = function (name, age, job, medals) {
  Person.call(this, name, age); // calling the super constructor function
  this.job = job;
  this.medals = medals;
};

Athlete.prototype = Object.create(Person.prototype); // making the inheritance

Athlete.prototype.wonMedal = function () {
  this.medals++;
};

var mahmoudAthlete = new Athlete("mahmoud", null, "developer", 10);
mahmoudAthlete.calculateAge(1986); // from parent
mahmoudAthlete.wonMedal(); // from child
console.log(mahmoudAthlete.age);
console.log(mahmoudAthlete.medals);

// ES6

// Parent
class Person {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }
  calculateAge(yearOfBirth) {
    this.age = 2021 - yearOfBirth;
  }
}

// Child
class Athlete extends Person {
  constructor(name, age, job, medals) {
    super(name, age);
    this.job = job;
    this.medals = medals;
  }

  wonMedal() {
    this.medals++;
  }
}

var mahmoudAthlete = new Athlete("mahmoud", null, "developer", 10);
mahmoudAthlete.calculateAge(1986); // from parent
mahmoudAthlete.wonMedal(); // from child
console.log(mahmoudAthlete.age);
console.log(mahmoudAthlete.medals);
```

### Prototype

A prototype can be specified with `__proto__`

```javascript
const person = { profession: "programmer" };
const mahmoud = {
  __proto__: person,
};
console.log(mahmoud.profession);
```

### `super()`

```javascript
const person = { profession: "programmer", code: () => "coding.." };
const x = {
  __proto__: person,
  code() {
    return super.code() + "...js";
  },
};
console.log(x.code()); // coding.....js
```

### Enhanced Object Literals

```javascript
const color = "yellow";
const machine = {
  color, // instead of: color = color
};
console.log(machine.color);
```

## Asynchronous Javascript

Allow asynchronous functions to run in the background - We pass in callbacks that run once the function has finished its work - move on immediately - non-blocking.

### Callback Hell

```javascript
function getRecipe() {
  setTimeout(() => {
    setTimeout(
      (mobileNumber) => {
        console.log("inside second callback, mobileNumber: " + mobileNumber);
        setTimeout(() => {
          console.log("inside third callback");
        }, 3000);
      },
      5000,
      "0562974766"
    ); // passing value to the function
    console.log("inside first callback ");
  }, 1000);
}

getRecipe();
// ES6 fixes this issue by promises to deal with asynchronous javascript
```

### Promises

```javascript
// callback --> promise --> async --> Observables (which is a way to handle async code)
// creating the promise using new Promise(resolve, reject)
// Promise will be in pending state, once event happens it will be either (resolved) or (rejected)

// Produce
var getIds = new Promise((resolve, reject) => {
  // resolve & reject is a callback functions
  setTimeout(() => {
    resolve([10, 20, 30]);
  }, 1500);
});

// Consume
getIds
  .then((ids) => {
    console.log(ids);
  })
  .catch((err) => console.log(err));

// another example
let done = false;
const isItDoneYet = new Promise((resolve, reject) => {
  if (done) {
    const workDone = "Here is the thing I built";
    resolve(workDone);
  } else {
    const why = "Still working on something else";
    reject(why);
  }
});

// consuming the promise
const checkIfItsDone = () => {
  isItDoneYet
    .then((ok) => {
      console.log(ok);
    })
    .catch((err) => {
      console.error(err);
    });
};

checkIfItsDone();

// another example
// callback hell
function getRecipe() {
  setTimeout(() => {
    const recipeID = [523, 883, 432, 974];
    console.log(recipeID);

    setTimeout(
      (id) => {
        const recipe = { title: "Fresh tomato pasta", publisher: "Jonas" };
        console.log(`${id}: ${recipe.title}`);

        setTimeout(
          (publisher) => {
            const recipe2 = { title: "Italian Pizza", publisher: "Jonas" };
            console.log(recipe);
          },
          1500,
          recipe.publisher
        );
      },
      1500,
      recipeID[2]
    );
  }, 1500);
}
getRecipe();

// using promises
const getIDs = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve([523, 883, 432, 974]);
  }, 1500);
});

const getRecipe = (recID) => {
  return new Promise((resolve, reject) => {
    setTimeout(
      (ID) => {
        const recipe = { title: "Fresh tomato pasta", publisher: "Jonas" };
        resolve(`${ID}: ${recipe.title}`);
      },
      1500,
      recID
    );
  });
};

const getRelated = (publisher) => {
  return new Promise((resolve, reject) => {
    setTimeout(
      (pub) => {
        const recipe = { title: "Italian Pizza", publisher: pub };
        resolve(`${pub}: ${recipe.title}`);
      },
      1500,
      publisher
    );
  });
};

getIDs
  .then((IDs) => {
    console.log(IDs);
    return getRecipe(IDs[2]);
  })
  .then((recipe) => {
    console.log(recipe);
    return getRelated("Jonas Schmedtmann");
  })
  .then((recipe) => {
    console.log(recipe);
  })
  .catch((error) => {
    console.log("Error!!");
  });
```

### Using async await

- Using async await ES8/2017
- async/await was designed to consume promises and not to produce them. if you want to produce promises we just do it the way we do.
- most of the time we're going to consume promises

```javascript
// producing promises same as previous example. async/await was designed to consume promises and not to produce them

async function getRecipesAW() {
  const IDs = await getIDs; // getIDs is a promise, it is like calling getIDs.then and wait until it finishes
  console.log(IDs);
  const recipe = await getRecipe(IDs[2]); // getRecipe is a promise, it is like calling getRecipe.then() and wait until it finishes
  console.log(recipe);
  const related = await getRelated("Jonas Schmedtmann"); // getRelated is a promise, it is like calling getRelated.then() and wait until it finishes
  console.log(related);

  return related;
}
// async always return a promise
getRecipesAW().then((result) => console.log(`${result} is the best ever!`));
```

### Chaining Promises

```javascript
const getResponseStatus = (response) => {
  if (response.status >= 200 && response.status < 300) {
    return Promise.resolve(response); // return back resolved promise
  }
  return Promise.reject(new Error(response.statusText)); // return back rejected promise
};
const getJsonResponse = (response) => response.json(); // response.json() also will return a resolved promise contains the json object

fetch("http://quotes.rest/qod.json") // run this in browser only
  .then(getResponseStatus) // will return a resolved promise, so u can call .then()
  .then(getJsonResponse)
  .then((data) => {
    console.log("Request succeeded with JSON response", data);
  })
  .catch((error) => {
    console.log("Request failed", error);
  });
// Another example using AJAX and fetch API
// AJAX asynchronous javascript and xml
function getWeather(woeid) {
  fetch(
    `https://crossorigin.me/https://www.metaweather.com/api/location/${woeid}/`
  )
    .then((result) => {
      // console.log(result);
      return result.json();
    })
    .then((data) => {
      // console.log(data);
      const today = data.consolidated_weather[0];
      console.log(
        `Temperatures today in ${data.title} stay between ${today.min_temp} and ${today.max_temp}.`
      );
    })
    .catch((error) => console.log(error));
}
getWeather(2487956);
getWeather(44418);

async function getWeatherAW(woeid) {
  try {
    const result = await fetch(
      `https://crossorigin.me/https://www.metaweather.com/api/location/${woeid}/`
    );
    const data = await result.json();
    const tomorrow = data.consolidated_weather[1];
    console.log(
      `Temperatures tomorrow in ${data.title} stay between ${tomorrow.min_temp} and ${tomorrow.max_temp}.`
    );
    return data;
  } catch (error) {
    alert(error);
  }
}
getWeatherAW(2487956);

let dataLondon;
getWeatherAW(44418).then((data) => {
  dataLondon = data;
  console.log(dataLondon);
});
```

### Handling Errors in Promises

When anything in the chain of promises fails and raises an error or rejects the promise, the control goes to the nearest `catch()` statement down the chain.

```javascript
new Promise((resolve, reject) => {
  throw new Error("Error");
}).catch((err) => {
  console.error(err);
});

// or
new Promise((resolve, reject) => {
  reject("Error");
}).catch((err) => {
  console.error(err);
});

// Cascading errors
// If inside the catch() you raise an error, you can append a second catch() to handle it, and so on.

new Promise((resolve, reject) => {
  throw new Error("Error");
})
  .catch((err) => {
    throw new Error("Error2");
  })
  .catch((err) => {
    console.error(err);
  });
```

### Orchestrating Promises with `Promise.all()` and `Promise.race()`

```javascript
// 1- Promise.all()
// If you need to synchronize different promises, Promise.all() helps you define a list of promises, and execute something when they are all resolved.

const f1 = fetch("http://quotes.rest/qod.json");
const f2 = fetch("http://quotes.rest/qod.json");
Promise.all([f1, f2])
  .then((res) => {
    console.log("Array of results", res);
  })
  .catch((err) => {
    console.error(err);
  });

// The ES2015 destructuring assignment syntax allows you to also do
const f1 = fetch("http://quotes.rest/qod.json");
const f2 = fetch("http://quotes.rest/qod.json");
Promise.all([f1, f2]).then(([res1, res2]) => {
  console.log("Results", res1, res2);
});

// 2- Promise.race()
// Promise.race() runs as soon as one of the promises you pass to is resolved, and it runs the attached callback just once with the result of the first promise resolved

const promiseOne = new Promise((resolve, reject) => {
  setTimeout(resolve, 500, "one");
});
const promiseTwo = new Promise((resolve, reject) => {
  setTimeout(resolve, 100, "two");
});
Promise.race([promiseOne, promiseTwo]).then((result) => {
  console.log(result); // result will be 'two'
});
```

## `fetch()` vs `axios()` APIs

- `fetch()`
  - is not supported by old browsers
  - you need to make two steps, wait for the response, then convert the response data to json object.
- `axios()`
  - is doing in one step (returning an object)

```javascript
async function getData() {
  try {
    const result = await axios("");
    console.log(result.data);
  } catch (error) {
    console.log(error);
  }
}
```

## Modules

- Modules are very cool, because they let you encapsulate all sorts of functionality, and expose this functionality to other JavaScript files, as libraries.
- Not exist before ES2015
- ES Modules Syntax: `import package from 'module-name'`
- CommonJS Modules Syntax: `const package = require('module-name')`

```javascript
// names export
export const name = "mahmoud";
export const play = () => {
  console.log("playing");
};

//usage
import { name, play } from "./file";
play();

// you can export more than one thing
const a = 1;
const b = 2;
const c = 3;
export { a, b, c };

// usage
import * as all from "./module";

// You can import just a few of those exports, using the destructuring assignment:
import { a } from "module";
import { a, b } from "module";
import { a, b as two } from "module";

// example
const renderRecipe = (recipe) => {
  console.log("rendering");
};
export const renderResult = (recipes) => {
  recipes.foreach(renderRecipe); // automatically renderRecipe will be exported
};
```

```javascript
// you can't put more than one 'default' in the same file
export default (str) => str.toUpperCase(); // exists in uppercase.js

// include module in HTML page
<script type="module" src="uppercase.js"></script>;

// include in another module
import toUpperCase from "./uppercase.js";

// and usage
toUpperCase("test"); //'TEST'

// You can use an absolute path to import module
import toUpperCase from "https://flavio-es-modules-example.glitch.me/uppercase.js";
import { toUpperCase } from "/uppercase.js";
import { toUpperCase } from "../uppercase.js";
```

### CORS with Modules

Modules are fetched using CORS. This means that if you reference scripts from other domains, they must have a valid CORS header that allows cross-site loading (like Access-Control-Allow-Origin)

## DOM Manipulation with Javascript

DOM: Document Object Model, is a structured representation of an HTML document, DOM is fully object oriented representation

```javascript
// Get numbers between range, eg: 1 to 6
var randomNumber = Math.floor(Math.random() * 6) + 1;
console.log(randomNumber);
```

```javascript
document.querySelector("#firstName").textContent = 24; // only text content
document.querySelector("#firstName").innerHTML = "<em>" + 12 + "</em>"; // adding html content
document.querySelector(".dice").style.display = "none"; // query by class name
document.querySelector(".dice").style.color = "red"; // change html element style
document.querySelector(".dice").classList.remove("active"); // getting all css classes on this selector
document.querySelector(".dice").classList.add("active"); // if you call add twice it will add active class two times
document.querySelector(".dice").classList.toggle("active");
document
  .querySelector(".btn-roll")
  .addEventListener("keypress", function (event) {
    if (event.keycode === 13 || event.which === 13) {
      console.log("pressed");
    }
  });
document.getElementById("score").focus(); // put mouse cursor on element
document.getElementById("score").textContent = "0"; // faster than querySelector but selecting by id only
var newHtml = html.replace("%id%", obj.id);

// add adjacent element
var one = document.getElementById("one");
one.insertAdjacentElement("afterend", "html code"); // beforebegin, afterbegin, beforend, afterend

var fields = document.querySelectorAll("div.note, div.alert"); // will return list
var fieldsArray = Array.prototype.slice.call(fields); // from list to array
fieldsArray.foreach(function (current, index, array) {
  // Logic // TODO: check the course for example
});

// delete an element from DOM
var parentElement = document.getElementById("parent");
var element = document.getElementById("name");
parentElement.removeChild(element);

// loop through nodelist
var fields = document.querySelectorAll(".percentage"); // will return a node list
var nodeListForEach = function (list, callback) {
  for (let index = 0; index < list.length; index++) {
    callback(list[index], index);
  }
};

nodeListForEach(fields, function (current, index) {
  current.textContent = index + 1; // or any other logic
});

// event listener on `option` html element
document.querySelector(".text").addEventListener(change, function () {
  // some logic
});

// prevent default behavior of submit
document
  .querySelector(".dice")
  .addEventListener("submit", (e) => e.preventDefault());

document.getElementsByTagName("p");

// change html element attribute value
document.getElementById("name").src = "";

// append child element
var paragraph = document.createElement("p");
var node = document.createTextNode("this is new paragraph");
paragraph.appendChild(node);
document.getElementById("div1").appendChild(paragraph);

// remove child
document.getElementById("div1").removeChild(paragraph);
// remove child if i don't know the parent
paragraph.parentNode.removeChild(paragraph);

// insert adjacent elements
var div1 = document.getElementById("div1");
div1.insertAdjacentElement("afterend", "<p>test</p>"); // before begin, after begin, before end, after end (of the selected element)

// closest // returns the closest ancestor of the current element (or the current element itself)

<article>
  <div id="div-01">
    Here is div-01
    <div id="div-02">
      Here is div-02
      <div id="div-03">Here is div-03</div>
    </div>
  </div>
</article>;

var el = document.getElementById("div-03");

// returns the element with the id=div-02
var r1 = el.closest("#div-02");

// returns the closest ancestor which is a div in div, here it is the div-03 itself
var r2 = el.closest("div div");

// returns the closest ancestor which is a div and has a parent article, here it is the div-01
var r3 = el.closest("article > div");

// returns the closest ancestor which is not a div, here it is the outmost article
var r4 = el.closest(":not(div)");

// data-\*

elements.searchResPages.addEventListener("click", (e) => {
  const btn = e.target.closest(".btn-inline");
  if (btn) {
    const goToPage = parseInt(btn.dataset.goto, 10);
    searchView.clearResults();
    searchView.renderResults(state.search.result, goToPage);
  }
});

// you can change data-\* to anything data-name, data-age, and you will get it using elm.dataset.name or elm.dataset.age ...
<button class="btn-inline results__btn--${type}" data-goto="3"></button>;
```

## The Module Pattern

- Modules are important aspect of any robust application's structure
- Keeps the units of code for a project both cleanly separated and organized
- encapsulate some data into privacy and expose other data publicly
- Each part of the application is responsible for doing one part independently

- UI Module
  - get inputs
  - update UI
- Data Module
  - add item to our data structure
  - calculate something
- Controller Module
  - add event handler
  - We'll use Closure and IIFE

```javascript
// We'll use Closure and IIFE
var budgetController = (function () {
  // IIFE
  var x = 23;
  var add = function (a) {
    // this is private
    return x + a;
  };

  return {
    publicAdd: function (b) {
      // this is public
      console.log(add(b)); // closure // will have access to outer variables even after it returned
    },
  };
})(); // () here you can pass any other modules you want and use it inside, eg: (budgetData)
budgetController.publicAdd(5);
```

## Events

Events are part of the DOM and every HTML element has number of events. eg:

- body events: onload, onunload
- form events: onchange, onsubmit, onreset, onselect, onblur, onfocus
- keyboard events: onkeydown, onkeyup
- mouse events: onclick, ondbclick, onmousedown, onmousemove, onmouseout, onmouseover, onmouseup

## call, apply and bind methods

```javascript
// call, apply and bind methods
// the three methods are in function prototype, so each function has the three methods
// all of the three have to do with 'this' keyword
// call & apply, so you can grab methods from other objects and use them as long as you have similar property names
// call & apply for method borrowing
// bind for method currying

// 1- call, for method borrowing
var mahmoud = {
  name: "Mahmoud",
  printName: function (prefix) {
    console.log(prefix, this.name);
  },
};

var sara = {
  name: "Sara",
};

mahmoud.printName.call(sara, "Name is: "); // passing the object and function parameter // now printName is pointing to sara object and not mahmoud
mahmoud.printName("Name is: ");

// 2- apply, same as 'call' but it accepts Array

var mahmoud = {
  name: "Mahmoud",
  printHobbies: function (...hobbies) {
    console.log(this.name + "'s hobbies: " + hobbies);
  },
};

var sara = {
  name: "Sara",
};

mahmoud.printHobbies.apply(sara, ["cooking", "watching tv"]);

// 3- bind, same as call but it doesn't immediate call the function, but instead it generates a copy of the function so we can store it somewhere
// This is named `Method carrying`: creating a copy of a function but with some preset parameters
var Person = {
  firstName: "",
  lastName: "",
  printHobbies: function (...hobbies) {
    console.log(this.firstName + "'s hobbies: " + hobbies);
  },
};

var logHobbies = function (name, hobbies) {
  this.firstName = name; // after using bind, `this` will point to the passed object
  this.printHobbies(hobbies);
};

var logHobbiesFunc = logHobbies.bind(Person, "Mahmoud"); // you should pass the object // Optional you can send all required params or part of them or none
// usage
logHobbiesFunc(["cooking", "watching tv"]);

// another examples for bind
function multiply(a, b) {
  return a * b;
}

var multiplyByTwo = multiply.bind(this, 2);
console.log(multiplyByTwo(4)); // 8

var multiplyByTen = multiply.bind(this, 10);
console.log(multiplyByTen(10)); // 100
```

## Misc

- JavaScript is a case-sensitive language, Time and TIME will convey different meanings in JavaScript.
- It's advised to always use strict checking `!==` and `===`, because it's checking both type & value.
- Semicolons are Optional: javascript is adding a semicolon `;` automatically at the end of each line if it doesn't end with a semicolon and ends of `}`, `return`, `throw`, `continue`, `break`.
- Window Object has:
  - history object
  - document object
  - link
  - form
  - anchor
  - location object
- setTimeout(function, duration) will be executed after duration
- setInterval(function, duration) will be executed every duration
- clearTimeout(timeoutVariable) clear any given timeout
- Difference between function and method
  - function: standalone unit of statements.
  - method: attached to an object and can be referenced by `this` keyword.
- Create your own library/framework
  - you have to wrap your code, in order to not be affected by any other code.
  - if you have multiple files, code may be overridden by other code
  - Use IIFE which accepts Window & Jquery objects as arguments

```
// example:
function add(y) {
  var x = 10;
  return
  x + y;
}
// console.log(add(10)); // will be undefined, because it will be converted to

function add(y) {
  var x = 10;
  return; // will return undefined
  x + y;
}
```

```javascript
var result = parseInt("231 mahmoud"); // result is 231 only
console.log(result);

console.log(parseFloat("1.02")); // from string to float
console.log(isNaN("1")); // check if it's number or not

// loading multiple scripts
var name = "Ahmed"; // exists in <script src="app1.js"/>
var name = "Mahmoud"; // exists in <script src="app2.js"/>
console.log(name); // will print 'Mahmoud', because it puts all variables in the execution context according to the files order, then start executing the code

// You should create initialization function init() in your app

// prompt an alert and receive user input
var x = prompt("Please enter your name: ");
console.log("Your name is: ", x);

// Math
console.log(Math.round(13.4)); // Round number to closest integer // result= 13

// String to Number
console.log(parseInt("845"));

// map function
var numbers = [9, 2, 10];
var numbersBy5 = numbers.map(function (current) {
  return current * 5;
});
console.log(numbersBy5); // [ 45, 10, 50 ]

// remove the sign
console.log(Math.abs(-120)); // 120

// put two number right after the decimal point
var num = 1.25454;
console.log(num.toFixed(2)); // result 1.25
console.log(parseInt("1").toFixed(2)); // result 1.00

// format string from -26545.988786 to 2,6545.99
var num, firstPart, secondPart, result;

num = -26545.988786;
num = Math.abs(num).toFixed(2); // 26545.98
firstPart = num.split("").splice(0, 1); //2
secondPart = num.split("").splice(1, num.length); //6545.98
result = firstPart.join("").concat(",").concat(secondPart.join(""));
console.log("result: " + result); // 2,6545.99
```

## Useful Examples

```javascript
// functional programming and `bind()` function
function mapItems(arr, fun) {
  var newArr = [];
  for (i = 0; i < arr.length; i++) {
    newArr.push(fun(arr[i]));
  }
  return newArr;
}

var limiter = function (limit, item) {
  return item > limit;
};

var limiterSimplified = function (limiter) {
  return function (limit, item) {
    return item > limit;
  }.bind(this, limiter);
};

var arr = [1, 3, 6];
var result = mapItems(arr, limiter.bind(this, 2)); // bind will create a copy of the function then it will pass the first argument only.
console.log("result", result);

var resultSimplified = mapItems(arr, limiterSimplified(2));
console.log("resultSimplified", resultSimplified);
```

```javascript
// function constructor
function Person(name, age) {
  console.log(this); //this will be the new object that will created.
  this.name = name;
  this.age = age;
  console.log("this function is invoked!");
}
var mahmoud = new Person("Mahmoud", 32);
// as long as the function doesn't return an object, js will return the newly created object.
// [if i return { test: true}, the type of mahmoud will be of that type]
```

```javascript
// Very powerful trick for Polyfilling Object.create [which is supported by modern browsers only]
if (!Object.create) {
  Object.create = function (o) {
    if (arguments.length > 1) {
      throw new Error(
        "Object.create implementation only accepts the first parameter. "
      );
    }
    function F() {}
    F.prototype = o;
    return F();
  };
}

var person = {
  name: "",
  age: "",
};

var mahmoud = Object.create(person);
mahmoud.name = "mahmoud";
mahmoud.age = 32;
console.log(mahmoud.name);
```

```javascript
// typeof test
typeof null; // will be object
console.log(typeof null);

var b = "mahmoud";
var result = typeof b == "string" ? "B is String" : "B is Numeric";
console.log(result);
```

```javascript
// Using Labels (outerloop, innerloop) to Control the for loop Flow

console.log("Entering the loop!<br /> ");
// This is the label name
outerLoop: for (var i = 0; i < 5; i++) {
  console.log("Outer Loop: " + i + "<br />");
  innerLoop: for (var j = 0; j < 5; j++) {
    if (j > 3) break; // Quit the innermost loop
    if (i == 2) break innerLoop; // Do the same thing
    if (i == 4) break outerLoop; // Quit the outer loop
    console.log("Inner Loop: " + j + " <br />");
  }
}

console.log("Exiting the loop!<br /> ");
```

```javascript
// Math.ceil
console.log(Math.ceil(22.1)); // round to next integer // 23

// Hash Event
// fired each time the hash in URL is changed
window.addEventListener('hashchange', ()=>{
  let id = window.location.hash; // will return #123
  console.log(id.replace('#',''));
  });

  // same listener for multiple events
  ['hashchange', 'load'].forEach(()=>{
  let id = window.location.hash; // will return #123
  console.log(id.replace('#',''));
  });

  // page refresh
  // <a href="javascript:location.reload(true)">refresh page</a>
  // or

<script>
    var _refresh = function(t){
        setTimeout(() => {
            location.reload(true);
        }, t)
    }
</script>
<body onload="javascript:_refresh(5000);">

</body>
```

## JS Libraries

- Ramda
- Lodash
- Underscore.js helps working with arrays, collections of objects. examples: `_.map()`, `_.filter()`
- moment.js for date formatting

### Webpack

- ES6 or ESNext ------> Transpiling & Polyfilling (Using Babel - javascript compiler) ------> ES5 (to support older browsers)
- ES6 Modules ---------(Using webpack)---------> Bundle
- Webpack is doing more functionalities, code splitting, loading SaaS or images, decrease javascript bundle size using algorithm 'tree shaking'
- Webpack is most commonly used asset bundler, not only bundle js files but bundles all kind of assets, js, css, images...
- for webpack configuration, check javascript course, section 9
