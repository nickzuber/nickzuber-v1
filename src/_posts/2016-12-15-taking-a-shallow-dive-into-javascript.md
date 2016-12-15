---
layout: post
title: "Taking a Shallow Dive into JavaScript"
date: 2016-12-15 13:22:51 -0500
permalink: blog/taking-a-shallow-dive-into-javascript
use_math: true
---

When it comes to choosing a primary programming language for a project or
professional application, there are plenty of different factors that need to be
considered. Among those, there are also different types or categories of
programming languages to choose from as well; some of which being scripting or
interpreted languages and compiled languages. While each flavor of programming
language has their own weaknesses and strengths, one particular scripting
language, known as JavaScript, is rapidly growing and becoming more ubiquitous
across all kinds of programming stacks. Starting out as a simple language used
for the web, JavaScript has quickly become much more than that; now appearing
in all sorts of different kinds of applications like machine learning programs
and can even be used for writing servers. JavaScript is easily one of the most
versatile and powerful scripting languages in modern programming, and can be
used to build strong and scalable applications.

## Programming Paradigm & Continuations

One of the many characteristics of JavaScript that make this language so unique
is its flexible support for a multitude of programming paradigms. At its core,
just about everything in JavaScript is an object that is implemented as an
associative array, with the exception of its six primitive types: string,
number, boolean, null, undefined, and symbol [2]. Even then, most of these
primitive types have their respective object wrapper classes that allows
developers to declare these primitives as objects. Now, since almost everything
in JavaScript is itself an object, it’s clear to see how object oriented
programming paradigms are natively supported by the language. The one caveat
here, however, is that JavaScript doesn’t support classical inheritance, but
rather prototypical inheritance [1]. This means that each object has its own
prototype which can be composed to properties and methods, and since objects
are mutable, to achieve inheritance you just create a new instance of an object
and augment its properties [4].

JavaScript can also be treated as an impure functional language since it
natively supports first class lambda functions, lexical closures, immutability,
and tail recursion. While JavaScript itself doesn’t overtly promote functional
programming or immutability, it’s very possible and becoming quite common to
use JavaScript in a functional manner. Functions in JavaScript are treated as
objects themselves, and can be used as arguments to other functions as well as
having additional properties and methods. Aside from this feature, each
function is bound with its own lexical scope that includes any of the variables
declared within the outer function that it was declared inside of [1]. With
this ability to have higher ordered functions and tail recursion, JavaScript is
able to support continuation-passing style.

In JavaScript related software development, continuation-passing style is a
very important topic, primarily due to the fact that JavaScript itself is
single threaded. This means that all of the programs being run on an instance
of a JavaScript runtime engine are done on a single thread, which implies that
any halt or waiting that must occur within a given JavaScript process will halt
the entire program. This problem is clearly noticeable for any IO related tasks
that involve some JavaScript program waiting on some input before it can
complete a task. Continuation-passing style solves this single threaded problem
by deferring the continuation of the program to be executed when its ready,
rather than having to freeze the entire program waiting for it to be ready.
This approach is widely used, and is quite necessary, for asynchronous
programming in not just JavaScript applications, but any program that might use
this method of programming. Asynchronous procedures are programs that run
independently of the main thread or process in a non-blocking manner [3]. This
process might be reminiscent of multithreading, however asynchronous programs
can be implemented by alternative means, therefore making them very different;
for example, JavaScript supports asynchronous methods and JavaScript runtime
engines are single threaded.  

The concept of asynchronous programming inherently lends itself to
continuation-passing style; if a program is running independently of the main
thread, how will the main program know when it has finished? The most common
answer to this problem is to implement continuation-passing style for
asynchronous functions. The idea is to pass in the continuation of the program
to the asynchronous function, and once the function has completed its process,
the result is then passed as an argument into the continuation, and the program
can advance. All of this can occur without the program having to halt, since we
aren’t waiting for the call to finish to continue running the program, but
rather just giving the asynchronous call a set of instructions to perform with
its result once it has completed.

## Type System

By default, JavaScript is an untyped language; meaning that it inherently has
no static type system within the native implementation of the language itself.
While the term _untyped_ has a few different meanings, in the context of
JavaScript it implies that all expressions, functions, and variables belong to
a single type such that a program is always generated where all of the types
match up [5]. Since there is no native static type system, this language can
also be considered as a dynamic language, such that the types of its variables
are volatile and are allowed to change. This inherently leads to programming
bugs that are difficult to trace and can also lead to unexpected behavior if a
variable changes type somewhere within the program and isn’t accounted for.  

This is the primary reason that makes writing fast JavaScript programs hard;
since types are dynamic, the interpreter executing a JavaScript program must
include additional checks during runtime to ensure that variable’s data type
[6]. With statically typed languages, the compiler knows the data types of each
variable in the program and is able to perform these checks very quickly,
usually as a simple lookup in a table or as a static function. In dynamically
typed languages, the interpreter has to update and perform additional checks
each time a variable changes due to its volatile nature, which slows down the
interpreting process. To be more specific, each variable needs to have its own
type checks since it can change data types on the fly, each statement needs to
check to see if it throws an exception due to the possibility of type
mismatching, and since every field can be added, removed, or altered during
runtime, there needs to be checks for that as well [6]. One advantage to
JavaScript being a prototypical object oriented language is that we don’t need
to worry about class hierarchy checks during runtime since each object has its
own copy of its proto chain during its instantiation.

## Garbage Collection

Unlike languages such as C that have a very low level and manual way of
handling memory allocation and deallocation, JavaScript uses garbage collection
to reclaim unused memory within a program [7]. In all modern iterations of
JavaScript, this method of garbage collection is often implemented using a mark
and sweep memory allocation strategy. It’s important to note that some older
implementations of JavaScript, notably versions that were created for Netscape,
utilized a reference counting strategy for garbage collection, however this
approach is no longer used today.  

The mark and sweep garbage collector is able to navigate through all of the
variables defined within the program periodically, and mark all of the values
referred to by these variables [8]. This particular algorithm makes sure it
recursively check and mark the values and properties of any objects or arrays
it finds as well in the hopes of being able to find every variable and value
within the program that is still reachable. Therefore, any values or variables
that were not marked is considered garbage that can be reclaimed by the
collector. The garbage collector then begins to sweep through the program,
making sure to deallocate and reclaim any memory it finds that is unmarked and
considered to be garbage. It does this by iterating through each value within
the program’s environment, deallocating any that it finds to be unmarked [8].  

Traditional and naive implementations of mark and sweep garbage collection tend
to go through complete marking and sweeping phases at a time; the downside to
this approach is that it can hinder the program’s performance since it needs to
start and stop while the garbage collection is happening. In modern iterations
of JavaScript, this method of garbage collection is handled more efficiently by
trying to only run in the background of a program during the runtime. This
helps avoid disrupting the performance of the application while at the same
time still being able to collect any garbage generated during the lifetime of
the program.  

## Closing

Over the last couple of decades, JavaScript has come a long way from being a
simple scripting language built in roughly ten days [9]. It is quickly becoming
a more mature and ubiquitous across all different kinds of programming stacks,
and is capable of much more than it was originally intended when it was first
conceived. JavaScript is easily one of the most versatile and powerful
scripting languages in modern programming, and can be used to build strong and
scalable applications.

---

## Cited Sources

[1] https://en.wikipedia.org/wiki/JavaScript <br />
[2] https://developer.mozilla.org/en-US/docs/Glossary/Primitive <br />
[3] http://cs.brown.edu/courses/cs168/s12/handouts/async.pdf <br />
[4] https://en.wikipedia.org/wiki/Prototype-based_programming <br />
[5] https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_correspondence <br />
[6] http://www.cl.cam.ac.uk/research/srg/netos/vee_2012/slides/vee18-ishizaki-presentation.pdf <br />
[7] https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management <br />
[8] http://docstore.mik.ua/orelly/webprog/jscript/ch11_03.htm <br />
[9] https://www.w3.org/community/webed/wiki/A_Short_History_of_JavaScript
