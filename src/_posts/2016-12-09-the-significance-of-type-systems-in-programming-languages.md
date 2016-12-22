---
layout: post
title: "The Significance of Type Systems in Programming Languages"
date: 2016-12-09 13:21:44 -0500
permalink: blog/the-significance-of-type-systems-in-programming-languages
use_math: true
---

No matter what programming language is being used or how careful the developer
is while using it, human error is always an unavoidable issue when building out
programs of any scale. Among some of the popular approaches to mitigate the
problem of human error, integrating type systems into a programming language
can be a powerful way to go. Type systems introduce the concept of assigning
types to different constructs within a program such as variables, functions,
and expressions, and enforce consistency among the rules associated with each
type. A type can be understood as just a classification of data which has an
interface associated with it that describes how it is intended to be used. With
a type system, the program is able to avoid type related errors, such as
performing an operation on a type that does not support that operation. While
there are many tradeoffs and design decisions that go into implementing a type
system in a programming language, considering a type system and weighing the
different tradeoffs relative to the program being built is an important
decision to consider, and the benefits can be very worthwhile.

## Benefits of Type Systems

There are plenty of benefits to reap from having a type system in a programming
language, both qualitatively and quantitatively. In general, having the ability
to explicitly define types of variables and functions can greatly increase
readability and make the author’s intent more clear; at the end of the day,
humans are the ones reading and writing the code, so this benefit cannot be
easily overlooked. By reducing any ambiguity, a byproduct of manifest typing
can also be the improve of the development process by making it more clear as
to what the program is doing and how it’s doing it.  

One of the primary advantages to having a type system is the elimination of
type errors before any program runs. A type system will analyze the code during
the compilation process and flag any type related errors that it finds.
This makes it so any code that makes it through the type checking process and
gets run is type safe. The entire process of type checking a program before it
runs is to mitigate human errors that are written into the code during the
development process. Without a type system to find and catch these errors, the
only way they would be found in the future is if they were encountered during
the program’s life cycle, which isn’t practical for production code that is
indented to be released to users who expect bug free programs. This is clearly
not ideal, and this benefit alone can be a strong argument for utilizing a type
system.  

Alongside the benefit of finding bugs before code is run, ensuring type safe
code can also have a small boost on performance in certain situations. This is
because if the developer knows what the type of a variable or expression is,
there’s no need for manual type checking within the program itself; this manual
type checking pattern slows down the performance of the program to some degree,
therefore when eliminating the need for this entirely, the program can run
faster. With this in mind, if a type system is implemented efficiently enough,
then it can absolutely be worthwhile to use.  

## Drawbacks and Tradeoffs

While there are many advantages to having guarenteed type safety in programs,
there are drawbacks and other tradeoffs that need to be considered. One of the
more prominent downsides to a type system is that it can reject some correct
programs. It’s not uncommon to encounter a program that works as intended and
is objectively correct in the sense of how it should run and perform, but still
have a type system reject and find errors within it. This has to do with
how type systems are traditionally implemented; there are many different types
of shortcuts a type system has to implement in order to perform efficiently
enough to be worthwhile to use. For example, when analyzing _if_ statement, if
the type checker was to consider both branches separately and check them
individually, it’s clear to see how the work that the type checker has to do
would double every time it encounters this situation, effectively creating
potentially exponential growth. One way to avoid this problem is to require
both branches to be of the same type; this solves the issue but as a result,
makes it so correct programs that happen to break this rule will be rejected by
the type system.

With that in mind, its clear to see one of the major issues with type systems.
It’s hard to make a system that accepts as many correct programs as possible
while still being fast enough for it to be worthwhile to use. If a type system
is too slow, then most of the benefits it provides can become moot; when the
type checking process takes longer than just running the program, it can become
less efficient to bother running the type checker than just running the
program.

## Type Inference and Polymorphism

Without manifest types being explicitly defined on a variable or expression, it
is still possible to assign those constructs types. The concept of trying to
assign every variable or expression some type such that the type checking
process is successful, and reject the program if no solution can be found, is
known as type interference. While there are many different variations of
implementations for type inference, a good example for how it works would be
how its traditionally implemented in ML. Firstly, types of bindings are
generally determined in the order in which they appear, which is why it’s
important to write any functions or methods before the functions that use them;
without doing so, the inferred types will not be in the environment by the time
they are needed and the system will simply throw a type error. When a
binding is being inferred, all of the relevant definitions and facts are
analyzed and used to determine what the type can possibly be; for example, if
some variable _x_ is used with the addition operator on some number, it can be
inferred that _x_ must be of the type integer. If any of these facts that were
gathered happen to conflict with one another, this implies that there exists a
type error in the program.  

Even after this inference analysis process, it is still possible for an
expression or variable to still not have enough constraints associated to it
for the type checker to determine its type. In this situation, it’s common to
assign this expression or variable a polymorphic type by giving it a fresh and
arbitrary type. This new type generally implies that it can hold any type
value; this is commonly seen when a function parameter is never used within the
function, therefore it’s clear that this can be anything and has no constraints
associated with it. Type inference is a useful tool when implemented well; it
adds the benefit of having less verbose code while maintaining the type safety
of the program. However, type inference isn’t perfect; problems don’t arise
often, but when they do, they tend to be particularly hard to debug. When an
expression or variable is inferred with the wrong type, errors can occur well
past the actual spot that is causing the error, which can lead to strange and
unhelpful bugs.

## In Closing

Type systems can be a very powerful and useful asset to any programming
language under the right circumstances. It’s always important to weigh the
different kinds of tradeoffs when considering whether or not a type system
would be worthwhile to include in a given project or program, as there are
clearly advantages to having a type system as well as not having one. With the
use of other strategies, such as type inference, having a type system can be
beneficial without any added work of manually adding type annotations, so there
is little extra work that needs to be done to achieve type safety. With all of
this in mind, it’s always important to at least consider the possibility of
incorporating a type system in any project.
