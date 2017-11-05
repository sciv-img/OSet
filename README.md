# OSet [![Build Status](https://travis-ci.org/sciv-img/OSet.svg?branch=master)](https://travis-ci.org/sciv-img/OSet)

Fast, idiomatic Ordered Set data structure for Swift.

## Installation

Use Swift Package Manager:

```swift
.Package(url: "https://github.com/sciv-img/OSet", Version(0, 4, 0))
```

If you don't want to/cannot use SwiftPM, you can always copy the source over (it's one file).

## Usage

`OSet` supports all the same operations available in the standard `Set`, by implementing the [`SetAlgebra`](https://developer.apple.com/documentation/swift/setalgebra) protocol. For example:

```swift
  1> import OSet
  2> let oset1 = OSet([1, 2, 3]); print(oset1)
OSet([1, 2, 3])
  3> let oset2 = OSet([3, 4, 5]); print(oset2)
OSet([3, 4, 5])
  4> print(oset1.union(oset2))
OSet([1, 2, 3, 4, 5])
  5> print(oset1.symmetricDifference(oset2))
OSet([1, 2, 4, 5])
  6> print(oset1.intersection(oset2))
OSet([3])
```

It also implements [`MutableCollection`](https://developer.apple.com/documentation/swift/mutablecollection) and [`RandomAccessCollection`](https://developer.apple.com/documentation/swift/randomaccesscollection) protocols. This gives access to iteration, subscript get/set, swapping, sorting, etc. For example:

```swift
  1> import OSet
  2> var oset = OSet([3, 1, 2]); print(oset)
OSet([3, 1, 2])
  3> print(oset[1])
1
  4> oset[1] = 7; print(oset[1])
7
  5> oset.swapAt(0, 2); print(oset)
OSet([2, 7, 3])
  6> oset.sort(); print(oset)
OSet([2, 3, 7])
  7> for item in oset { print(item) }
2
3
7
```

Complete documentation can be read directly in the [source](https://github.com/sciv-img/OSet/blob/master/Sources/OSet.swift).

## Benchmarks?

Are available [here](https://github.com/sciv-img/OSetBenchmarks).
