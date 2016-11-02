---
layout: post
title: "Automated Memory Management Systems with Garbage Collection"
date: 2016-11-02 19:34:57 -0400
permalink: blog/automated-memory-management-systems-with-garbage-collection
use_math: true
---

When creating any type of program or application, the developer almost always
needs to consider memory usage. Whether it is a simple and small program, or a
large and complex program, developers are going to have to worry about managing
their memory consumption in one way or another. Problems can arise when
mistakes are made; remembering to allocate and deallocate can become
nontrivial, especially as the complexity of a program expands. With this
problem in mind, garbage collectors were created; these tools act as a way to
automate the process of reclaiming memory in a program by realizing when
certain memory is no longer being used by the program and frees it to be used
elsewhere<sup>1</sup>. While there are many different techniques and strategies for
solving this problem of automatically collecting memory which is no longer
being used, garbage collection in general benefits the developer in many
situations so long as they are willing to give up, in many cases, some
performance and resources.

## Reference Counting

One well known technique for tracking memory and trying to figure out when to
deallocate it, is called reference counting. This refers to the process of
literally counting and keeping track of the number of references, or pointers,
there are to a particular block of data or object. The idea behind this is that
when the reference count to an object reaches zero at any point, we can assume
that there are no more references of this object anywhere else in the program,
therefore there is no possible way for the developer to access it. Since it is
now impossible for the developer to call for this data, we can assume this data
is now inaccessible and therefore can be freed. It is important to note that if
an object has been deallocated for any reason, all other objects in the program
which were being referenced by that now removed data, if any, must now all have
their reference counters decremented. This implication leads to a slippery
slope where removing a single object can potentially lead to an arbitrarily
large number of other objects being removed as well, or at least having all of
their reference counters decrement.  


Reference counting is helpful when we want to find unused memory as soon as it
becomes available. This could be important in programs that have a relatively
tight restriction on memory, which therefore would need to deallocate memory
whenever it becomes available in order for program to run correctly. Besides
this feature, reference counting also shifts the responsibility of freeing
memory from the developer and does it automatically. This is generally a good
feature since it can sometimes be unreliable to have to manually free memory in
a program since often times a developer can easily make a mistake and either
forget to delete unused memory or create other types of memory leaks.


The costs to reference counting can hurt performance and increase memory usage
when programs become rather large. Since we need to keep track of each
reference, we need to keep in mind that for each object in a given program, we
need to use additional memory to store its respective reference count. When
talking about programs with thousands of objects, this overhead can impact the
available memory drastically and may lead to problems down the road. It is also
important to realize that references to objects are generally adjusted quite
frequently, especially when considering one of the downsides previously
mentioned (where removing one object may result in having to decrementing many
other objects’ reference counters). This frequent updating can hinder the
performance of a program and ultimately lead to other speed related issues.
Despite having effectively removed the responsibility for developers to free
memory, we replace that task with having the developers manually track the
number of references by updating each time they add or remove a reference. This
almost contradicts the benefit of not having to manually free memory, since
developers can still make mistakes here by incorrectly adjusting reference
counts the wrong way, or forgetting to do so entirely. It is also important to
note that reference counting is not perfect either; reference counting fails
when it encounters cyclic objects, such that two objects reference each other
<sup>2</sup>. For example, if we simply consider a circular singly linked list such that
the tail of the list points to the second element, every element of this list
will have a reference count of one, with the exception of the second element
having a reference count of two (the head and the tail both pointing to it).
Now, if we happen to destroy the head of the linked list, every other element
of the list will all have a reference count of one, despite there being no
possible way to access this list. Hence, we clearly have a list of objects that
are considered garbage and should have their memory freed, yet they still have
reference counts of one.

## Mark & Sweep

With this problem of collecting cyclic data in mind, other garbage collection
techniques have been developed aimed to solve this. One popular technique to
garbage collection, and the first algorithm that was able to solve the cyclic
data problem <sup>3</sup>, is known as mark and sweep. In this approach, the garbage
collection process itself is divided into two different parts: the marking
phase and the sweeping phase. Before any marking or sweeping is done, it is
important to note that for every object that is created, it is decorated with a
single bit that will only be used for this garbage collection process. This bit
is initially set to zero before the actual mark and sweep process begins.


Firstly we have the marking phase: in this phase of the process, we create a
collection of _roots_, which consist of all the initial pointers that are being
held in registers <sup>3</sup>. When we have this collection, we perform a depth first
search on the roots, marking every object that we are able to find. These
marked objects represent all of the reachable objects within the given program.
The next phase is the sweep phase: this is where each object that is being
stored in memory is check to see if it had been marked or not. Every object
that isn’t marked is put into a queue that keeps track of locations in memory
we can free later down the road if we ever need more memory. Mark and sweep is
only invoked when the program runs out of memory, therefore the process does
not hinder the performance of the program unnecessarily. This also implies that
the unmarked blocks of memory which need to be freed aren’t _actually_ freed
until the program needs more memory.


There are a few problems with this approach that should immediately stick out;
one of which being how the garbage collection process doesn’t start until the
program needs more memory, but we would need some memory to store the list of
reference roots. Since this list is arbitrarily large, there is no way to
reserve a spot in memory for this list in advance. Similarly to this problem,
the list of unmarked memory which can be freed would also need to be stored
somewhere. However, there are some clever ways these issues can be resolved:
instead of storing the reference roots in a list, this data can be stored
within the objects’ memory themselves with a technique known as pointer
reversal <sup>3</sup>. This approach can be used in the place of storing a list of root
references; the idea here is to have each reference we visit (during the depth
first traversal of the marking phase) point back to its parent, so that when we
get to the end of a particular reference chain, we can find our way back to the
initial root reference and continue the process.


Solving the issue with tracking the memory blocks that can be freed is somewhat
similar in nature, but relatively simpler; since this data is no longer
important, we can write over some of it without consequence, so this allows us
to mark part of memory as perhaps the size of the block followed by the
location in memory of the next memory block to free. This way, we don’t need to
use any auxiliary memory for tracking the list of memory that can be freed.

## Stop & Copy

Another popular method of garbage collection is what’s known as stop and copy.
With this approach, the memory for a given program is divided into two
sections: an old space and a new space <sup>4</sup>. The idea behind this approach is to
use the memory in the old space until it’s full, copy over the reachable object
references into the new space, then free all the remaining memory in the old
space (since we can assume the memory left over is garbage since its
unreachable), and then switch the roles of the two spaces and repeat. One of
the great features of this approach is its fast and simple allocation strategy;
there’s a single heap pointer in the old space which points to the next
available location in memory. As that block of memory gets used, this heap
pointer simple increments to the next location in the space.  


However, one of the downsides to this approach is the difficult challenge that
comes with deep reference copying. When some object gets copied into the new
space, all of the objects that it points to are also marked as reachable and
therefore copied into the new space as well. The challenging part here is to
fix the pointers to make sure that the object copies point to the correct
object copies. There are ways to solve this problem, one of which being a
technique using forwarding pointers and partitioning the new space further into
additional sections. Here, the goal is to copy an object into the new space,
marking the old reference as a copied element and adding a forwarding pointer
from the old reference to the newly copied reference. We then process all of
the pointers in the new block we had just copied, and as we copy its references
we fix its pointers to point to the new copies instead of the old reference
<sup>4</sup>. Despite this algorithm being relatively complicated, the reason why this
approach isn’t ideal isn’t because of the complexity, but rather because of the
expensive nature of all these operations. It’s also important to note that a
large portion of the memory in a program which implements a stop and copy
garbage collection is dedicated to the garbage collection process itself, which
inherently limits the finite amount of memory within the program.

## Conclusion

The ability to automate the process of deallocating and freeing unused memory
in a program can be beneficial to developers and help mitigate the human error
that comes into play when having to deal with memory management manually. Like
most great things, there are always important tradeoffs to consider; in the
case of garbage collection, we know that these processes can take additional
resources to work properly, slow down programs and hinder performance, and
ultimately are not perfect solutions.  

---

<sup>1</sup> [https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science)) <br />
<sup>2</sup> [http://www.brpreiss.com/books/opus5/html/page423.html](http://www.brpreiss.com/books/opus5/html/page423.html) <br />
<sup>3</sup> [http://www.brpreiss.com/books/opus5/html/page424.html](http://www.brpreiss.com/books/opus5/html/page424.html) <br />
<sup>4</sup> [http://www.brpreiss.com/books/opus5/html/page426.html](http://www.brpreiss.com/books/opus5/html/page426.html) <br />
