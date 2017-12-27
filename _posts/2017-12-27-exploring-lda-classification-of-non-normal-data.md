---
layout: post
title: "Exploring LDA Classification of Non-Normal Data"
date: 2017-12-27 13:31:48 -0500
permalink: blog/exploring-lda-classification-of-non-normal-data
use_math: true
author: Nick Zuber
tags:
 - paper
---

Last semester I took a class on machine learning and learned some really cool things. This particlar course focused on the mathematics and theory of machine learning and had a lesser focus on particular applications. The cool part about this approach is it gave me a much better opportunity to really understand these models that we use more and more each day, and help us better adapt them in real world applications. 

One of our main projects was to take an existing statistical model and do something novel with it. My partner [Lucas Tata](https://github.com/lucas-tata) and I decided to take a deep dive into the Linear Discriminant Analysis Classification model and figure out _why_ exactly it yields unexpected results when the data normality assumption is violated. Using this information, we then try some things to remedy the specific "weak" points in the algorithm (spoilers, we don't).

Overall it was a really interesting project that lead to a much deeper understanding of these kinds of linear models and their shortcomings. I encourage you to check out [our research paper on the topic](../pdf/lda.pdf) if you're interested.
