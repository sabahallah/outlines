# YAML Outline

> This outline includes most YAML syntax. You can validate YAML syntax on [YAML Online Validator](https://codebeautify.org/yaml-validator) and [Converter here](https://codebeautify.org/yaml-to-json-xml-csv).

## What is YAML

* YAML Ain't Markup Language.
* YAML is a data serialization language that is natural, meaningful and human-readable.
* Common data types are scalars (String, number and boolean), lists and arrays.
* Common use is to use as a configuration file or for storing data.
* Two forms of styles:
  * Block Style.
    * Better for humans.
    * Less compact.
    * Example as below.
  * Flow Style.
    * An extension of json. eg: `datacenter: { location: dubai, cab: 13}`.
    * Folding long line content.
    * Tags and Anchors.
* You can add multiple directives/documents into one file.
  * Triple dashes (`---`) to mark start of a file.
  * Triple dots (`...`) to mark the end without closing the data stream.
* Comments
  * Define a comment with octothorpe and a space (`# `).
  * Should be at the end of the line.
  * Blank lines interpreted to a commented lines.
* Anchors
  * Used to store and reuse data.
  * Define an anchor with `&`.
  * Reference an anchor with `*`.

## Syntax Example

```yaml
--- # mark start of a file.
# YAML Ain't Markup Language.
# This is a comment.
person:
    name: &myName mahmoud # define anchor or variable myName
    occupation: 'developer'
    occupation2: 'developer #'
    age: 33
    gpa: 3.5
    gpa2: !!str 3.5 # will be rendered as "3.5"
    fav_num: 1e+10
    male: true
    birthday: 1986-07-29 14:20:00 # ISO 8601
    flaws: null # no value
    hobbies: # list of items
        - running
        - swimming
        - biking
    movies: ["Fast and Furious","Gladiator"] # list of items # flow style
    friends: # list of objects
        - name: "Hany" # this is an object
          age: 32
        - {name: "Hossam", age: "32"} # another form of object
        -
         name: "Ahmed"
         age: 32
    description: > # render below text as a single line
        Lorem Ipsum is simply dummy text of the printing and
        typesetting industry. Lorem Ipsum has been the industry's
        standard dummy text ever since the 1500s, when an unknown
        printer took a galley of type and scrambled it to make a
        type specimen book.
    signature: | # preserve spacing, indentation, new lines, etc.
        Mahmoud
        Software Developer
        email - mahmoud.sabahallah@gmail.com
    id: *myName # id will have the value of myName
    base: &base # storing entire below key/value pair in a variable
     var1: val1
    foo:  # base will be rendered as var1: val1
     <<: *base
     var2: val2
    datacenter: { location: dubai, cab: 13} # flow style
# to mark the end
...
---
newperson:
  name: mahmoud
  age: 33
```
