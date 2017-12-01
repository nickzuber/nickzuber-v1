---
layout: post
title: "Continuations and Their Role In JavaScript"
date: 2016-12-22 13:34:08 -0500
permalink: blog/continuations-and-their-role-in-javascript
use_math: true
author: Nick Zuber
tags:
 - paper
 - language
---

By definition, a computer program is a collection of instructions that are
designed to perform a specific task. It is inherently important for a
developer to understand each individual instruction or step the program has to
take in order to reach its goal correctly. Naturally, it can be valuable to a
developer to have more control over these instruction depending on the program
at hand. When the program is executing some specific instruction, the
collection of steps that still need to be processed in order for the program to
complete a computation is known as a continuation. Some languages are able to
provide its users this ability to treat continuations as first class features,
while some other languages require its users to implement them manually.
Regardless of the kind of program being created, continuations can always be a
valuable concept and tool for a developer to understand in order to be equipped
to build smart and sound programs.

## Continuation-Passing Style

Using continuations to your advantage within computer programs can yield
powerful results. A common method for using continuations is known as
continuation-passing style. In the continuation-passing style paradigm, control
is within the program is passed explicitly by continuations. This is in
direct contrast to more widely used styles of programming such as direct style.
The direct style of programming is can generally be described as synchronous
programming, in which continuations are passed implicitly by just advancing to
the next line of the program. While some languages in particular have native
support for continuations, such that continuations are treated as first class
features, other languages are still able to implement their own interpretation
of continuation-passing style so long as they have the right tools to do so. In
order for a language to properly implement continuation-passing style, the
language needs to be able to support closures and proper tail calls. This
is due to the fact that for continuation-passing style to work properly, the
language needs to be able to manually create continuations which can be
implemented as non-returning functions that are able to encapsulate the
respective name bindings within its lexical scope, and be able to support
functions that are able to call other functions at the very end of themselves.

One way to implement continuation-passing style into a program is to have a
function which takes in an additional argument of another function, which
represents the continuation. When the first function completes its execution,
instead of returning the result of the procedure, it instead passes this result
into the continuation, thus advancing the program with its product. In
contrast, the direct style of programming would rather return the result of the
function back to the caller in order to further advance the program, while with
the continuation-passing style, the next set of instructions for the program is
being called with the result of the function when its ready.  

## Continuations in JavaScript

JavaScript is a great example of a language that doesn’t have first class
continuations, but in many cases requires continuation-passing style to be
supported in order to perform many of the useful tasks that this language is
often times expected to be able to do. In JavaScript, manual continuations are
simple to write since the language supports closures, and continuation-passing
style is also easily implemented since the language naturally supports proper
tail calls. By simply passing in a function argument, which represents the
continuation of the program, to another function, which represents the current
process being executed, we’re able to pass the result of the current function
into the continuation and invoke it at the very end of the current function,
hence advancing the program in a continuation-passing style.

For JavaScript related software development, continuation-passing style is a
very important topic, primarily due to the fact that JavaScript itself is
single threaded. This means that all of the programs being run on an instance
of a JavaScript runtime engine is done so on a single thread, which implies
that any halt or waiting that must occur within a given JavaScript process will
halt the entire program. This problem is clearly noticeable for any IO related  
tasks that involve some JavaScript program waiting on some input before it can
complete a task. Continuation-passing style solves this single threaded problem
by deferring the continuation of the program to be executed when its ready,
rather than having to freeze the entire program waiting for it to be ready.
This approach is widely used, and is quite necessary, for asynchronous
programming in not just JavaScript applications, but any program that might use
this method of programming. Asynchronous procedures are programs that run
independently of the main thread or process in a non-blocking manner. This
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

## In Closing

Being able to have control over the state of a given program can be a very
useful advantage for a developer to have. Even in cases where continuations
aren’t required in order to build a program, they still provide an alternative
way of thinking and going about certain problems. Continuations can also help
solve programming efficiency problems, like in the case of asynchronous
JavaScript programming, where we would otherwise have impractical alternatives.
Therefore, regardless of the kind of program being created, continuations can
always be a valuable concept and tool for a developer to understand in order to
be equipped to build smart and sound programs.
