# Typescript Outline

> This is a basic introduction of `Typescript`

- TypeScript is a superset of JavaScript.
- It adds static typing to Javascript, because javascript in its own dynamically typed.
- [Official Documentation](http://www.typescriptlang.org)

## Commands

- `npm install -g typescript` install typescript compiler globally.
- `npm install -g typescript@2.2` install specific version.
- `npm install --save-dev typescript` install typescript locally in a project.
- `npx tsc typing.ts` compile typescript file to javascript, it will generate `.js` file

## Configuring the Typescript Compiler

- Sometimes you wanna compile all typescript files in your project in one time, and how typescript compiler behaves, this is by using configuration file.
- `npx tsc --init` this will create `tsconfig.json` file

## Basic Features

- Primitives: number, string, boolean
- More Complex Types: arrays, objects
- Function Types, parameters
- Generics
- Classes, Interfaces

```typescript
// ***************** primitives ********************** //
let age: number = 12; // number in lower case is primitive data type, but Number in capital letter is an object type
let username: string = "Mahmoud";
let isGraduated: boolean = true;
// ***************** arrays ********************** //
let hobbies: string[] = null;
hobbies = ["running", "swimming", "cycling"];
// ***************** objects ********************** //
// here is type definition
let person: {
  name: string;
  age: number;
};
person = {
  name: "Mahmoud",
  age: 35,
};
// array of objects
let people: {
  name: string;
  age: number;
}[];
// ***************** Type inference ********************** //
// by default typescript tries to infer the types without you explicitly telling the type
let course = "react - the complete guide";
course = 1345; // will not compile because typescript inferred the type as string.
// ***************** Union types ********************** //
// Union types: Sometime you want to allow multiple types
let course: string | number = "react - the complete guide";
course = 12345; // now this will be accepted
// ***************** Type Alias ********************** //
// Type Alias: You can define a type
type Person = {
  name: string;
  age: number;
};
// now you can use the alias
let person: Person;
person = {
  name: "Mahmoud",
  age: 35,
};
let people: Person[];
// ***************** functions and types ********************** //
function add(a: number, b: number) {
    // here also is a type inference, so return type will be number
    return a + b;
}
// you can explicitly tell the return type
function add(a: number, b: number): number | string {
    return a + b;
}
// here return type is void
// Note: print function is a built in javascript function, so this will not compile. Try to change the name.
function print(value: any) {
    console.log(value);
}
// ***************** Generics ********************** //
function insertAtBeginning(array: any[], value: any) {
    // spread operator, coping array
    return [value, ...array];
}
const demoArray = [1, 2, 3];
const updatedArray = insertAtBeginning(demoArray, -1); // result will be [-1, 1, 2, 3]
// now the return type will be of type any[] which is not helpful in us
// updatedArray[0].split('') you can't do this if the passing array is of type numbers.
// now you can define this function as a generic function, now typescript will look into the arguments and understands it's array of numbers, so return type will be array of number.
function insertAtBeginning<T>(array: T[], value: T) {
    return [value, ...array];
}
// now if you call this updatedArray[0].split(''), it will show an error, split is not a function in type number
const stringArray = insertAtBeginning(['a','b','e'], 'd'); // now it will infer the return type as a array of string.
// ***************** Classes ********************** //
class Student {
    firstName: string;
    lastName: string;
    age: number
    private courses: string[];
    constructor(first: string, last: string, age: number, courses: string[]){
        this.firstName = first;
        this.lastName = last;
        this.age = age;
        this.courses = courses;
    }
    enrol(courseName: string) {
        this.courses.push(courseName);
    }
    listCourses(){
        // will return a copy
        return this.courses.slice();
    }
}
const student = new Student('Mahmoud', 'SabahAllah', 35, ['angular','css']);
student.enrol('react'); // now courses = ['angular','css','react']
// by default all the properties and methods are public by default, you can access them by using dot notation.
// you can make a property private by adding private keyword. private course: string[];
class Student {
    // this is shorthand notation
    // add the accessors to the parameters, type script will write all the above code.
    constructor(public firstName: string, public lastName: string, public age: number, private courses: string[]){
    }
    enrol(courseName: string) {
        this.courses.push(courseName);
    }
    listCourses(){
        // will return a copy
        return this.courses.slice();
    }
}
// ***************** Interfaces ********************** //
// will be compiled to javascript
// object type definition
interface Human {
    firstName: string;
    lastName: string;
    age: number;
    // we don't add the actual code. we just add the type
    greet: () => void;
}
let mahmoud: Human;
mahmoud = {
    firstName: "mahmoud",
    lastName: "SabahAllah",
    age: 35,
    greet() {
        console.log('hello');
    }
}
// Question here: you can do this by using type keyword. so what is the difference!
// interfaces can be implemented by classes
class Instructor implements Human {
    firstName: string;
    lastName: string;
    age: number;
    greet {
        console.log('hello');
    }
}
```
