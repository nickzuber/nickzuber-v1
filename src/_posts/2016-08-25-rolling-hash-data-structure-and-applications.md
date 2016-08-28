---
layout: post
title: "Rolling Hash Data Structure and Applications"
date: 2016-08-25 00:19:09 -0400
permalink: blog/rolling-hash-data-structure-and-applications
use_math: true
---

Let's say you were given a massive text document and were allotted the task of finding a particular sentence somewhere inside it. This sentence may or may not actually _exist_ inside of this document, but it's your job to try and find it anyways.

## Basic Approaches

The naive approach to this problem might be to take the sentence as a string, and compare it with every substring of the same size within the text document. It's pretty clear that this solution is far from optimal; given that the text document is of size $n$ and the target string is of size $k$, this algorithm would have a asymptotic run time of $O(n \cdot k)$. 

```
// Let D be equal to the text document
// Let K be equal to the substring we're looking for
for n := 0 to n - k
	if K == D.substring(n, n + k)
		return true
return false
```

We can make this approach more practical by introducing hashing. So, let's refer to our target string as the _key_ that we're trying to find within our document. Given a hash function $h(S)$, we define the hashed value of the _key_ as $h_k$. Now, since the _key_ is of size $k$, we will define a subset of the document as a _window_ named $w$ that starts at the $n^{th}$ character and has a length of $k$ such that $w_n=\sum_{i=n}^{k}\ s_n$. From here, we need to compare $h_{w_n}$ and $h_k$ for all $n\ \|\ 0 \leq n \leq n-k$ so that we end up with a set of _potential_ matches $P=\\{p\in S\ \|\ h_{w_n}=h_k\\}$. Assuming that we have a relatively good hash function, we can generally expect $\| P \|={1 \over \| b \|}$ such that $b$ is the image of $h(S;x)$. 

```
// Let D be equal to the text document
// Let K be equal to the substring we're looking for
// Let h be a relatively good hash function
Hk := h(K)
for n := 0 to n - k
	if Hk == h(D.substring(n, n + k))
		if K == D.substring(n, n + k)
			return true
return false
```

As we traverse the text document looking for the key, each time we shift the window and compute a new hash value to compare to the key, we're spend $O(k)$ time doing so due to the cost of recomputing the hash. If we do encounter a situation where $h_{w_n}=h_k$, we need to compare the two strings to ensure that we've indeed found a match and not a false positive -- this process still takes $O(k)$ (remember that comparing strings is expensive since what's actually going on under the hood is $k$ character comparisons). As long as the number of collisions is relatively low (which we've determined it is, given that we have a good hash function), then the entire process of finding the key within the text document is $O(n \cdot k)$.

So at this point, it might be hard to see where the optimization comes in -- even though we've traded the cost of string comparisons for number comparisons, we've consequently added the complexity of calculating and recalcuating hash values each time we want to compare the window hash to our key hash. This doesn't seem to be any different from the original non-hashing approach (because it _isn't_), but this gives us an excellent segue into the rolling hash data structure.


## The Rolling Hash

Imagine we were given the same problem as before, and took the hashing approach. If we were able to rehash the window in $O(1)$ time, our algorithm's overall runtime would drop from $O(n \cdot k)$ down to $O(n)$; this is a _significant_ improvement. We can actually accomplish this constant rehashing goal by using the [rolling hash](https://en.wikipedia.org/wiki/Rolling_hash) data structure. 

To put it simply, a rolling hash is a data structure which contains the hashed value of some sequence of elements, and is able to update that hashed value by either appending the hashed value of any single new element or by removing the hashed value of a single existing element within the hashed sequence. You can think of this process as _hot loading_ but for a hashed value. With that being said, let's lay out the abstract structure of what a rolling hash should look like -- and keep in mind that these properties will all make sense once we start to unveil how it works:

```
operations:
	skip(o: element)
	append(n: element)
	slide(o: element, n: element)
	hash(s: [ element ])
	set(s: [ element ])

internal properties:
	state: number
	BASE: number
	C: number
	INVERSE_BASE: number
	MODULAR_OFFSET: number
```

The `state` is the internal variable that holds the current value of the hashed sequence. We typically refer to the sequence being hashed as the _window_. Our main goal here is to try and figure out how we can shift the window through the entire text document, recomputing the hash in constant time. 

## Hashing Collections Efficiently

First, to formally define a _shift_ within the window, we're talking about taking some window `w`, such that $w \subset S$ where $S$ is defined as the sequence that we are performing the rolling hash operations on. We then go on to further define $w$ as its own sequence, starting at the $n^{th}$ character of $S$ and has a length of $k$ such that $w_n=\sum_{i=n}^{k}\ S_n$. A _shift_, or _slide_, operation on $w$ can be defined as an function $G(w;d)=w_{n+d}$ where $d$ is a fixed parameter that holds the value $-1$ or $+1$ respectively, depending on the direction you're trying to shift $w$.

Naturally, a shift operation would imply that we need to do two things: remove an element from $w$ and add an element to $w$. Let's visualize this process with an example; instead of using strings, which would typically be base 256, we're going to use a collection of base 10 numbers just because that's easier to work with mathematically:

```
// The collection that we want to apply our rolling hash to.
S := [1, 2, 3, 4, 5, 6]

// Our window which contains a sub sequence of S.
// It can be any size, but we chose 3 here for the example. 
w := [1, 2, 3]
```

We want our hashing function to first convert the sequence it's given into a number. So we do something like this:

```
// Our hash function
//  - S: sequence (ex. [1, 2, 3])
//  - b: base     (ex. 10)
HASH(S, b)
	r := 0
	for i := S.length - 1 down to 0
		r: = r + (S[S.length - 1 - i] * b^i)
	return r;

// Hash our current window
wh := HASH(w) // => 123
```

We've concluded that the hash of our window is $h(w_n)=123$; therefore, using the same hashing function, we compute the hash value of the next window in our sequence $w_{n+1}=[2, 3, 4]$ which comes out to be $h(w_{n+1})=234$. Remember that our goal is to find a way to covert $h(w_n)$ to $h(w_{n+1})$, so we basically need to find a way to convert `123` into `234`.

To put into even simpler terms, we need to get rid of the `1` from `123` and then add a `4`. To remove the `1`, we need to subtract $123 - (1 \cdot 10^2) = 23$, which translates to $h(w_n)-(x \cdot b^{k-1})$ such that $b$ represents the base of the elements of $w$, $x$ being the element we're trying to remove, and $k$ is the size or amount of digits in base $b$ within $w_n$. Now, adding the `4` is trivial -- we just need to multiply $w_n$ by $b$ and then just _add_ `4`. This would look like $(23 \cdot 10) + 4$, which translates to $(h(w_n) \cdot b) + y$, where $y$ represents the element we're adding.

This helps us with building our sliding operation on $w$; we know that if we want to get from $h(w_n)$ to $h(w_{n+1})$, we need to perform the following operation on $w$: $h(w_{n+1})=(h(w_n)-(x \cdot b^{k-1})) \cdot b + y$ which can be reduced down to $h(w_{n+1})=h(w_n) \cdot b - x \cdot b^k + y$.

## Modular Arithmetic

Cool, so we have an expression for calculating a new hash value in some constant time. Now you're probably thinking to yourself, 'can we do better'? Of course we can! There are quite a few things about that rehash function that are immediate red flags; _lots_ of multiplication, tons of dependent variables, and most importantly the result is _completely unbounded_. This implies that our rehash function is not very performant and can theoretically grow to infinity. 

One way of keeping this hash value controlled under some upper bound is to use [modular arithmetic](https://en.wikipedia.org/wiki/Modular_arithmetic). Let's assume we've picked a reasonably sized number $p$; we can now write our rehash function as $h(w_{n+1})=[h(w_n) \cdot b - x \cdot b^k + y] \mod p$. We can distribute the modulo and transform this method further: $h(w_{n+1})=[[h(w_n) \mod p] \cdot b - [x \cdot b^k \mod p] + y] \mod p$. To make things a little clearer, we can simplify this a bit since we know that our hash value is some number $h(w) \mod p$, we can just rewrite $h(w_n) \mod p \to h(w_n)$.

Okay, so our current rehash function is a little better now. Our main goal here is to leave us with a hashing function that we can compute quickly in constant time, so some more refactoring is needed. We want to get rid of any large numbers and expensive operations (such as division, multiplication, and modulo) in our hashing function, since doing arithmetic with large numbers is slow. Let's take a look at our current rehash function:

$$
h(w_{n+1})=[h(w_n) \cdot b - x \cdot b^k \mod p + y] \mod p
$$

We're looking for any expensive expressions within our algorithm, and we identify $b^k \mod p$ as a candidate. You might have already noticed, but this expression is a constant -- which means we can precompute this value. So let us define a constant named $C=b^k \mod p$. So now, let's take a look at our rehash function:

$$
h(w_{n+1})=[h(w_n) \cdot b - x \cdot C + y] \mod p
$$

Since we know that $h(w)$, $b$, $x$, $y$, $p$, and $C$ are _all_ reasonable small numbers, we can conclude that this hashing function will compute relatively quickly in constant time. Woo!

## Settings Things Up

There are a few things we need to precompute and prepare before we start hammering away at the rolling hash methods. One of the most important parts of this process is to define what we want our hashing upper bound $p$ to be. To give us the best results, we want a number that will give us the least amount of collisions, while still being a reasonable size. In general, independent of a particular use case, we want $p$ to be as close to a typical [word](https://en.wikipedia.org/wiki/Word_(computer_architecture)) size as possible (which is usually $2^{32}$), and for a good hashing number, we want to use a [prime number that is as far away from a factor of 2 as possible](http://stackoverflow.com/a/1147232/5055063). For the sake of an example, let's set $p=3,221,225,533$, which is a good prime number between $2^{31}$ and $2^{32}$. Of course, this number can vary depending on the use case; but it is _important_ to make sure we use a prime number that is as far away from a factor of $2$ as possible.

There are a few other things that we need to precompute, like the [modular inverse](https://en.wikipedia.org/wiki/Modular_multiplicative_inverse) of our base, and a particular modular offset. We'll go over these and how to implement them when we get to it, but for now, just keep this in mind as something we'll want to precompute ahead of time.

## Breaking Down the Methods

Now that we know the secret formula for the rolling hash, let's break it down into its components and methods. Let's start with the constructor:

```
_constructor (base, p) {
	// The prime modular base for our rolling hash
	this.PRIME_BASE = p;

	// The base of the number system
	this.BASE = base;
	
	// The internal hash of the window
	this.state = 0;
	
	// The expensive bit of code we want to precompute.
	// Since this represents base^size mod p, it makes
	// sense to initialize this value to 1
	this.C = 1;
	
	// The modular inverse of our base
	this.INVERSE_BASE = modular_inverse(base, p) % p;

	// An offset we use to ensure that our computations
	// will not go negative.
	this.MODULAR_OFFSET = p * base;
}
```

#### Append

Now that our rolling hash is set up, let's start with implementing the `append` method. Let's keep in mind that we've already figured out how to append an element to our window: $(h(w_n) \cdot b) + y$, where $y$ represents the element to add, so implementing the `append` method should be relatively trivial; we just need to make sure to incorporate the modular math that we've already figured out. We also can't forget to adjust our constant `C` that we're trying to precompute. Remember that $C=b^k \mod p$, where $k$ represents the size of our window. Since appending an element is consequently increasing our window size, we need to account for this:

```
append (y) {
	// Append the element
	this.state = (this.state * this.BASE + y) % this.PRIME_BASE;

	// Update our precomputed constant
	this.C = (this.C * this.BASE) % this.PRIME_BASE;
}
```

#### Skip

The `skip` method is a little more involved than its `append` counterpart; there are a few _gotcha_'s here to look out for. Similarly to `append`, we've already done the hard part and figured out how we skip or remove the trailing element from the hash: $h(w_n)-(x \cdot b^{k-1})$ (let's not forget to incorporate the modular math we've already figured out as well). We need to do two things in our implementation of `skip`; update the hash value and update the constant `C`. Instead of trying to update the hash value first, _then_ updating `C`, we can take advantage of the fact that we need to compute $b^{k-1}$ at some point to update the hash. This means we can update `C` first, which will effectively result in $C=b^{k-1} \mod p$ before the method is complete.

Remember when I said we needed to precompute some weird things like the inverse of our base and this mysterious modular offset? Well, you can scoot back from the edge of your seat, because you're about to find out why.

For `append`, when we needed to update `C`, all it took was increasing $b^k \mod p$ by a factor of $b$. However, for `skip`, we need to _reduce_ `C` by a factor of $b$. This is tricky because we're dealing with numbers that are being affected by a modulo bound -- we can't just divide `C` by $2$ here. The trick to solving this is to multiply `C` by the [modular inverse](https://en.wikipedia.org/wiki/Modular_multiplicative_inverse) of what we're trying to decrease it by, in our case $b$. 

Another tricky _gotcha_ is how we're performing subtraction. What's tricky about subtraction, you ask? Well, when performing a calculation similar to $h(w_n)-(x \cdot b^{k-1})$, we need to realize that there is a possibility for $x \cdot b^{k-1}$ to be _greater_ than $h(w_n)$ -- this would result in a negative number. When performing modular arithmetic on negative numbers, [we expect to get a positive result](http://math.stackexchange.com/a/519856/296221). However, this behavior isn't consistent throughout programming languages; for example, in JavaScript, `-5 % 2` will return `-1`. To combat this, we can take advantage of how modular arithmetic works. Since we're taking the modulo of $p$, we can add any multiple of $p$ to our equation without changing the result. We can deduce that $x < b$ and that $b^{k-1} < p$, therefore $x \cdot b^{k-1}$ will always be smaller than $b \cdot p$. Because of this, by adding a factor of $b \cdot p$ to our equation, we can ensure that it never goes negative without affecting the outcome.

So with all of this in mind, let's build the `skip` method:

```
skip (x) {
	// Update our precomputed constant first
	this.C = (this.C * this.INVERSE_BASE) % this.PRIME_BASE;

	// Then, remove the element
	this.state = (this.state - x * this.C + this.MODULAR_OFFSET) % this.PRIME_BASE;
}
```

#### Slide

If you've noticed, each time we `append` or `skip` in our rolling hash, we have to update `C`, which kind of defeats the purpose of having it precomputed, right? So in practice, when we have our window size all set and are ready to start rolling, we don't want to `append` n' `skip`, but rather take advantage of our precomputed constants and just `slide`. Implementing the `slide` method is easy since we already did all of the work for it; recall when we solved our rehash function: $h(w_{n+1})=[h(w_n) \cdot b - x \cdot C + y] \mod p$.

```
slide (x, y) {
	this.state = (this.state * this.BASE - x * this.C + y + this.MODULAR_OFFSET) % this.PRIME_BASE;
}
```

#### Set

The `set` method is very simple -- just `append` each element in the input.

```
set (S) {
	for (let i=0; i<S.length; ++i) {
		this.append(S[i]);
	}
}
```

#### Hash

This just refers to our _good_ hashing function. As long as we remember to hash responsibly and make sure each step keeps us within the bounds of $p$, we should be all set. That could look something like this:

```
hash (S) {
	var hash = 0;
	for (let i=0; i<S.length; ++i){
      hash += (S[i] % this.PRIME_BASE * (Math.pow(this.BASE, (S.length-1-i)) % this.PRIME_BASE) % this.PRIME_BASE);
    }
    return hash % this.PRIME_BASE;
}
```

## Conclusion

As arguably _one of_ the most efficient ways to search for or iterate sequentially over a collection of items, the rolling hash does serve us well. Also, you can see, once we've written out an implementation of this data structure, it becomes clear that we're able to rehash in a relatively _good_ constant time; `append`, `skip`, and especially `slide` are all $O(1)$ operations. 

If you're interested in analyzing an [implementation of a rolling hash in JavaScript](https://github.com/nickzuber/needle/blob/master/src/lib/rollingHash.js) that I wrote a little while back, feel free to check it out. I've also written various other data structures in JavaScript, keeping them nice and organized in a library called [Needle](https://github.com/nickzuber/needle) if you're interested in giving them a look. Enjoy!
