---
title: Miscellaneous bugs that this post may help you solve
tags: software, code, coding
date: 2020-05-07
---
A collection (starting with one...) of little tidbits not deserving of their own post, but
posted in case the stray googler now finds their way home.

## Python
When building a wheel, if you see `doesn't exist or not a regular file`, the package likely has
an undeclared dependency on `setuptools`
