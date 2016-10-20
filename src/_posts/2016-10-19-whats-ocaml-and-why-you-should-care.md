---
layout: post
title: "What's OCaml and Why You Should Care"
date: 2016-10-19 20:53:40 -0400
permalink: blog/whats-ocaml-and-why-you-should-care
use_math: false
---

In a world where there are hundreds of different programming languages<sup>1</sup> to
choose from, choosing the correct languages for a project or task can be
overwhelming and difficult. With this being said, there are certainly different
flavors of programming languages geared towards solving different types of
problems. Among these, there is a family of general purpose functional
languages called MetaLanguage (or ML as it’s commonly referred to). Within the
family of MetaLanguage, there exists a uniquely interesting programming
language called Objective Categorical Abstract Machine Language, which is
commonly referred to as OCaml. OCaml was invented in 1996 by the Inria
corporation<sup>2</sup>. This language is primarily an extension of the Caml language
with the inclusion of some object-oriented design. OCaml’s tool set and
features are what make it a robust and powerful language to use in modern day
applications.

## Programming Paradigm

OCaml is a general purpose functional programming language. By virtue of this,
the language provides first class functions; this implies that functions are
treated as proper variables. First class functions open the door to more
powerful methods of functional programming; OCaml is able to have higher order
functions, anonymous functions, and currying. Despite the functional paradigm
that’s encouraged by the language itself, what makes this particular language
useful is its support for both imperative styles of programming as well as
object-oriented programming.

Imperative programming styles are, for the most part, fairly accounted for and
supported in OCaml. This particular feature is useful because it ultimately
gives the developer greater control over the memory representation of data and
how the program itself is executed. The language provides access to variables
and arrays; it can also record components which can be declared as mutable.
This impure functional language might allow irresponsible developers to shoot
themselves in the foot, but it also add more power to the language. The
imperative support allows OCaml program to have an extra layer of data control,
which consequently opens the door to more powerful abilities such as iteration
and rich data structures such as hashmaps.

The object-oriented features of OCaml allow developers to create objects and
classes for their programs. Similarly to how the support for imperative
programming styles benefits OCaml, the object-oriented features allow for data
organization in classes and objects, and even goes as far as to provide more
robust properties like polymorphic classes. Since OCaml’s object-oriented
pattern allows for polymorphism, this gives developers the ability to create
more complex programs and create abstract types.

Aside from the supported paradigms and styles of programming, OCaml, much like
all C and ML languages, is strict by default in the sense that it enforces
eager evaluation. Many benefits can be derived from strict languages such as
OCaml; one major point being that there is no overhead for having to keep track
of evaluations much like there is in a non-strict or lazy language. OCaml has a
strict evaluation pattern which implies that it has more control over when
expressions are evaluated; this can help with catching bugs. Examples of this
can be attempting to divide by zero in a function argument; with strict
evaluation, this argument gets evaluated first and the error is caught, whereas
with a lazy evaluation, this error isn’t caught until the function itself is
executed.

## Type System

Some of the more uniquely interesting and incredible aspects of OCaml include
its statically typed system, and its ability to leverage this to help produce
extremely performant code. The good thing about statically typed languages is
that they help eliminate type conflicts at compile time rather than at runtime.
This guarantee of safety ensures that programs are verified before they’re ever
executed<sup>5</sup>. This feature is particularly helpful because it prevents very
common human errors that occur when developing a program: conflating an integer
and pointer, accessing an invalid piece of data, or buffer overflows, just to
name a few.

Performance is a rather large benefit we get from OCaml’s statically typed
system. Since any type conflicts are resolved at compile time, this eliminates
any need for type related safety checks at runtime. These kinds of checks are
necessary for dynamically typed languages, which consequently add a slow
overhead, therefore slowing down the speed of the program itself. Most
scripting languages tend to be dynamically typed<sup>6</sup>, so this simple change of
type system puts OCaml far ahead of its peers with respect to speed. When it
comes to benchmarking, OCaml is argued to be almost as fast as C<sup>6</sup>, which is
incredibly impressive and unique considering it is a type safe language.

Not only is OCaml statically typed, but it also has type inference, which is
the ability to automatically assume the data type of an expression at compile
time, without its type needing to be explicitly defined. Rather, the compiler
will generally either attempt to predict the type based on existing atomic data
types of the language, or it will try to gather information about the data
being analyzed, and come to a conclusion that way. As a matter of fact, entire
programs can be written without explicitly declaring _any_ types, and OCaml is
able to figure out all of the types automatically. Traditionally, this power
comes at a cost; type inference is usually a relatively expensive feature to
support, and can be expected to ultimately slow down the compilation process.
In OCaml, however, this isn’t the case due to its unique and revolutionary
implementation of its type inference algorithm. OCaml has an interesting take
on the usual approach; its own algorithm is a derivation of the common type
inference algorithm known as Algorithm W, only OCaml’s interpretation utilizes
a graph based algorithm<sup>4</sup> which ends up being a much more speed efficient
variation of the traditional approach. The downside to the quick inference
implementation, is that it can result in strange type errors in more
complicated programs.

## Modules and Functors

Alongside these features, OCaml also comes with a mature module system that can
be categorized into three key parts: signatures, structures, and functors. The
signature of a module defines what type of data it can be parameterized with,
where the structure relates to how the body of the module is designed. Functors
are a very powerful feature in this module system; this is gives developers the
ability to parameterize a module with _other_ modules<sup>10</sup>. This opens the door
to all sorts of complex programs; having modules that can be constructed using
one or more other modules adds layers of abstraction that otherwise wouldn’t be
achievable in OCaml. A simple use case of functors could be the following:
let’s say you have a module that creates a set of items, and in order to check
if an item already exists within a given set, we need to apply a custom
equality function. We can create an equality module and use it to parameterize
our set module so that we can apply our custom equality function within the set
module; this makes the set module a functor. Besides the support of functors,
this module system can also be particularly helpful to developers for the
simple added bonus of having namespacing within modules; this can help avoid
any naming conflicts that may occur in a program.

## Structure and Tool Set

OCaml provides an extensive set of tools and libraries when it comes to
development, one of which being the interactive toplevel interpreter; this
system is designed in a read-eval-print loop where it repeatedly reads
expressions from the input, type checks, compiles, evaluates, then prints the
result<sup>7</sup>. This is similar to how Racket’s interactive toplevel interpreter
works (or Node.js, or most other interactive toplevel interpreters for that
matter). Having this kind of tool makes the developer’s life very easy when
they want to just test out some code quickly. The toplevel interpreter is also
used to interpret entire files of OCaml code; the general syntax is `ocaml
options objects scriptfile`. Before a scriptfile is read by the interpreter,
OCaml will first search the current directory, and, if not found, then the
`HOME` directory for a `.ocamlinit` file. This file can be used to import
necessary libraries that the program might need, or provide any other set up
related tasks.

OCaml also provides the developers with a bytecode compiler and a native code
compiler. Similar to a C compiler, dependency ordering matters when trying to
link and compile several files. This compiler will build and provide optimized
executable files that generally run faster than simply interpreting the source
code, with the native code compiler usually being faster<sup>8</sup>. The main purpose
of these compilers is for both portability and efficiency; OCaml is able to
build your files into very fast executables which, as we’ve mentioned earlier,
are roughly the same speed as C<sup>6</sup>. There are some third party tools that
assist the developer in linking dependencies, one of the more popular ones
being `ocamake`; you feed it your source files and it will link them together
automatically and the build them into an executable using the bytecode
compiler. Tools like these alongside the compilers themselves really benefit
the language in both efficiency and with being able to move code around on
different systems.

Managing packages in OCaml is relatively easy due to the open source package
manager called OPAM. This package manager supports multiple simultaneous
compiler installations and also integrates well with a git based development
workflows<sup>11</sup>. OPAM is a way for engineers to easily install and share any open
sourced packages that they create and publish to the OPAM package registry,
which helps increase the speed of the development process by sharing commonly
used code. Especially for an emerging language like OCaml, the ability to
simply distribute code and build a strong set of libraries really help the
language grow and thrive as more developers begin to use it.

## In Closing

OCaml is a powerful, general purpose functional programming language that has a
wide support for different needs. With its support of both imperative and
object-oriented programming paradigms, it’s needless to say that this language
is very flexible when it comes to what the developer might need. With its
statically typed system and very efficient implementation of its type inference
algorithm, leveraging the native code compiler can result in OCaml programs
turning out to be almost as fast as C programs. With these strong
characteristics and features, it’s no wonder that OCaml is quickly growing in
the open source software community; Facebook’s JavaScript static type checker,
Flow<sup>9</sup>, is written in OCaml and proves to be one of the most revolutionary
tools a JavaScript developer can use. From using OCaml’s robust tool set and
speedy execution, this software has quickly become one of the most popular
static type analyzers in the JavaScript community. All of OCaml’s features and
benefits cause it to be an incredible language and tool to use in modern day
applications, and is slowly taking the world by storm as developers realize how
powerful it is.

---

## Cited Sources

<sup>1</sup> [https://dzone.com/articles/big-list-256-programming](https://dzone.com/articles/big-list-256-programming) <br />
<sup>2</sup> [http://caml.inria.fr/about/history.en.html](http://caml.inria.fr/about/history.en.html) <br />
<sup>3</sup> [http://www.cs.cornell.edu/Courses/cs3110/2009fa/lectures/lec01.html](http://www.cs.cornell.edu/Courses/cs3110/2009fa/lectures/lec01.html) <br />
<sup>4</sup> [https://www.cl.cam.ac.uk/teaching/1415/L28/type-inference.pdf](https://www.cl.cam.ac.uk/teaching/1415/L28/type-inference.pdf) <br />
<sup>5</sup> [https://ocaml.org/learn/description.html](https://ocaml.org/learn/description.html) <br />
<sup>6</sup> [http://www2.lib.uchicago.edu/keith/ocaml-class/why.html](http://www2.lib.uchicago.edu/keith/ocaml-class/why.html) <br />
<sup>7</sup> [http://caml.inria.fr/pub/docs/manual-ocaml/toplevel.html](http://caml.inria.fr/pub/docs/manual-ocaml/toplevel.html) <br />
<sup>8</sup> [https://ocaml.org/learn/tutorials/compiling_ocaml_projects.html](https://ocaml.org/learn/tutorials/compiling_ocaml_projects.html) <br />
<sup>9</sup> [https://flowtype.org/](https://flowtype.org/) <br />
<sup>10</sup> [http://mirror.pkill.info/ocaml-tutorial.org/modules.html](http://mirror.pkill.info/ocaml-tutorial.org/modules.html) <br />
<sup>11</sup> [https://opam.ocaml.org/](https://opam.ocaml.org/) <br />
