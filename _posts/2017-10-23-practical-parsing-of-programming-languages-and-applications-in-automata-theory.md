---
layout: post
title: "Practical Parsing of Programming Languages and Applications in Automata Theory"
date: 2017-10-23 21:11:37 -0400
permalink: blog/practical-parsing-of-programming-languages-and-applications-in-automata-theory
use_math: true
---

In the ever evolving world of software engineering, the ability to write programs that solve a variety of different kinds of problems we encounter on a day to day basis is paramount. However, having a system or tool in place that is capable of understanding and interpreting these programs is even more important. Through the use of programming languages, we're able to define a standard way to design certain programs. Using the formal grammar that these languages provide, we're able to parse any program written in one of these languages and transform it into a more structural, and usually meaningful, representation of the program.

Parsing describes the process of analyzing the syntax of a stream of input strings with respect to some grammar defined by a formal language. This means that given some set of strings that have a set of well defined production rules, the parsing process looks at the strings and applies these rules to create a more meaningful understanding of the program, usually in the form of a parse tree or an abstract syntax tree.

### Automaton and Context Free Grammars

When it comes to programming languages, they are generally defined with some variation of a context free grammar. This is because in order to make the parsing process as efficient as possible, we need a simple and deterministic way to describe a programming language with certain production rules -- a deterministic context free grammar is good at doing exactly this. The reason a parser would need to be deterministic in the context of programming languages is due to the nature of many programs needing to be predictable, such that a program should be expected to produce the same results each time it is parsed.

A parser can be often described by a deterministic pushdown automata, which is essentially just a simple machine that utilizes a stack and can recognize deterministic formal languages. One important attribute that separates a regular pushdown automata from a deterministic one is how there can only be one transition for any given combination of state, stack contents, and input.

These automaton are very often used to design parsers because of how parsing is done by applying a set of production rules to a set of strings and iteratively transforming the input into some structure based on those rules, and this is what pushdown automaton are good at doing. In that case of a deterministic pushdown automata, since there is only at most one possible transition for each state and stack combination, it makes reading and parsing a programming language relatively simple and less computationally demanding.


## Lexers

The first logical step to parsing a stream of symbols and strings is to transform that data into something more meaningful. Recall the definition of a parser and what it tries to accomplish; a parser analyzes the syntax of a stream of input strings with respect to some grammar defined by a formal language. So we first need to transform the input of strings into members of the formal language our parser is working with. When designing a lexer, these elements of the formal language are often referred to as tokens. The process of generating a list of these tokens from the stream of input, also known as tokenization, is done by recognizing a slightly different grammar which specifically defines the syntax of the language.

### Identifying Tokens

Most programming languages don't have all their keywords consisting of a single character or symbol, but rather as a sequence of characters. These keywords are the among the members of a programming language's alphabet and we need a way to recognize these keywords and generate tokens before we pass off any data to the parser. We do this my defining another formal grammar, but this time we do it for the syntax itself.

Fortunately, it is often the case that these lexical grammars can be represented as a regular language. This makes tokenization slightly simpler because it is implied that we can define the grammar rules using regular expressions. These regular expressions can be used to identify and capture all of the character patterns in the input to generate these tokens we need for the parsing phase. The lexing step can be seen as a way of filtering the raw input data from characters or symbols the parser doesn't care about and combining other characters or symbols into items that the parser does care about.

### Optimizing the Lexer

We can further improve upon a simple lexer design by attempting to optimize for a few different things. The first and most obvious thing to focus on is the speed at which the raw input can be tokenized. Since there's no avoiding having to look at every character of the input at least once, the best we can hope for is to have only a single pass through during this entire process. Doing this is usually pretty simple and straightforward for basic tokens -- if a regular expression matches with a collection of characters from the input, we can generate the respective token and continue analyzing. However, while its not particularly standard practice in a common lexer, you can have more complicated tokens that require some more involved algorithms to implement.

We can recognize that the amount of work the parser needs to do is directly related to the amount of tokens it needs to analyze. With this is mind, if we're able to reduce the amount of tokens we pass off to the parser, we're able to reduce the amount of work that the parser needs to do. One way of doing this is to generate more sophisticated tokens which the parser can understand easier.

#### Compounded Tokens

To visualize a simple example of this, consider the raw string of "3 + (5 + 4)". A simple lexer might consider the open and close parentheses to be their own tokens, however the parser might need to know what the contents are in between two parentheses. This ends up making the parser do more work to figure out what all the tokens are in between the open and close parentheses before it can continue parsing which could affect the speed at which the parser operates. Now, if the lexer was able to generate a smarter token that had already done the work of combining the inner contents of the parentheses, then the parser wouldn't have to worry about doing that work itself.

<img src="../img/posts/token.png" />

Of course, this comes with a trade off -- the lexer now is required to do more work in order to condense the tokens. In some cases, the amount of work doesn't change -- instead of the parser doing it, now the lexer does. However, it is possible for this process be simpler and more efficient to be done by the lexer since the parser can oftentimes be trying to interpret tokens and will end up wasting time trying to group them together first. So long as the time at which the lexer operates isn't slowed down, it can be worthwhile to compound tokens in this way if it means it will reduce the amount of work the parser needs to do.

## Parser Design

Like we've said before, a parser's main goal is to understand what a program is trying to do and to construct a more meaning representation of that program; usually some form of a parse tree or an abstract syntax tree. Recall how programming languages are defined using a deterministic context free grammar. Some of the main advantages we get from doing this are how we get unambiguous and deterministic results from parsing, and how efficiently we can create parsers that can interpret these kinds of languages.

When parsing a language that is represented using a deterministic context free grammar, it's implied that for any point while parsing, the next step is completely dependent on the input. There are a few different approaches when it comes to parsing: universal, top-down, and bottom-up. Universal parsing is used for parsing any kind of grammar, but since it's too inefficient to implement in any practical sense, it's not a good approach when designing parsers. This also demonstrates again why we care about deterministic context free grammars when talking about programming languages and parsers -- we know there are reliable and efficient ways to create these kinds of parsers.

### Different Types of Parsers

Efficient parsers are often developed using either the top-down or bottom-up approach. As their names suggest, a top-down implementation will construct a parse tree or abstract syntax tree by starting at the root and working its way down to the leaves, while a bottom-up implementation will start at the bottom of the tree with the leaves and work its way up to the root. Both approaches can be used for writing efficient parsers that run in linear time, however there can be certain scenarios where it might be advantageous to use one implementation over another.

#### Top-down Parsing

A simple way to think about top-down parsing is finding the leftmost derivation of some input by scanning from left to right. Most approaches that involve a top-down technique implement some form of recursive decent. Recursive decent is when a collection of recursive procedures are imposed on the input in order to process the data. In a naive implementation, this approach can lead to many cases of backtracking where we explore each possible path for a nonterminal production rule and try to find matches. If a production rule that we consider turns out to not be the correct path, we need to recursively backtrack and try the next path. 

<img src="../img/posts/top-down.png" />

Since backtracking is inherently slow relative to linear parsing, there are ways to avoid it in recursive decent using a technique called predictive parsing. Predictive parsing works by predicting which production rule is going to be used next when analyzing some input. However, this comes at a slight cost -- instead of moving backwards when making an incorrect move, we look forward into the input and make sure we make the correct move. 

#### Lookaheads

Lookahead defines the amount of tokens that a parser can analyze before making a choice on which production rule to move forward with. When a lookahead parser is designed, the amount of tokens that it is allowed to look forward at is specified as a fixed number that does not change. Naturally, the most efficient top-down parser that can be designed involves a lookahead of zero. Since there most of the grammars that can be parsed correctly with this technique that doesn't involve looking ahead to any tokens aren't particularly sophisticated, most modern programming languages would require to have some amount of lookahead greater than zero.

In a general sense, there are a few specific actions that the parser can take after it has looked at some fixed number of tokens: it can shift, reduce, end, error, or conflict. End and error actions generally signal a stopping point the parser; the end action signifies the end of the input and error occurs when there are no valid production rules for the current input. A conflict occurs when the decision for shifting or reducing is ambiguous, and this is something that needs to be resolved by the parser from either specifying some sort of precedent or removing the ambiguity all together.

#### Shifting

The concept of shifting is simple; the current token is pushed onto the stack for later use. This would mean that we've identified a production rule to impose on the current token and we want to push it onto the stack so it can be consumed later. There are often plenty of syntactic constructs that are created using multiple tokens, so that's why it's advantageous to push tokens onto the stack if we know that we need them later.

#### Reducing

Reducing is the main action that a parser can take; the tokens that we've stored on the stack so far are popped and used to create a syntactic element as part of the parser's output. At this point, all the elements in the stack are combined according to the respective production rule, and since we were able to look ahead to other tokens, this rule is generally known ahead of time.

Despite having to spend time looking ahead at a certain amount of tokens, this process can be much more efficient than the alternative method of backtracking. Since a parser with lookahead is much more concise and explicit with the different kinds of possible states in the machine, this approach will almost always have many less states than a parser without any lookahead. Another advantage is the context; being able to know which tokens should be expected when trying to understand a program gives way to having an intrinsically deeper understanding of the program itself. With this, the parser will have a better idea of why a program might have failed during the parsing stage and can provide intelligent and informed feedback as to why it might have failed.

#### Bottom-up Parsing

The bottom-up approach to parsing can be thought of as almost the opposite of top-down; it attempts to construct the rightmost derivation of some input in reverse. By reverse, it's meant that we invert the production rules such that we begin with the terminals and replace them with the left side of a production rule. So given some input, we decide on a terminal to begin with and then start running production rules backwards until we finish at the start symbol.

<img src="../img/posts/bottom-up.png" />

## Closing

Being able to write sophisticated programs that solve a wide variety of different problems is more important than ever before in the modern world. In order to devise a structured and reliable way to understand these kinds of programs, there needs to be some kind of deterministic parsing step that is able to break down the program into its meaningful parts and analyze what it is try to accomplish. Parsing is a vital part of how we think about and design programming languages, and through the use of formal languages and context free grammars we can design efficient parsers using a variety of different approaches.
