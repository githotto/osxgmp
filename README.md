OSXGMP: Objective-C, Swift, Xcode wrapper for GNU Multiple Precision Arithmetic Library
=======================================================================================
This project contains an Objective-C and Swift wrapper for the GNU Multiple Precision
library (=OSXGMP in short).
Users can develop and play within this Xcode project with multiple precision arithmetic
either in Objective-C or in Swift.

Motivation
==========
In 2014 I heard about the Project Euler website (see: https://projecteuler.net), and
since I like to solve mathematical related problems, I promised myself to try it with
Apple's latest Swift language only!
Because Swift doesn't have a multiple precision library for this, like C#'s BigInteger or
Java's BigDecimal, I decided to create my own.

In July I started to play with Swift beta version 4 and really liked the new operator
overloading features. Because in various beta versions some syntax / compiler
features changed, I decided to wait until the official Xcode / Swift release. I then
started working seriously on OSXGMP in September.

Starting with a fresh project and adopting the nice Xcode 6 / XCTestCase integration, I
began working on it in a test-driven-development way.

This project is a work in progress, and actually my first GitHub contribution!

I really hope that people can play with it and contribute to it or can give me some feedback.
Although my time is limited (I mainly have some hours left in the weekends to work on this)
I'ld love to extend the library with e.g. wrappers for BigFloat and BigRational.

Requirements
============
* Swift 1.2, Xcode 6.4 and OSX 10.9 or higher. This is the default master branch!
* Swift 2.0, Xcode 7.0 and OSX 10.10 or higher. For this you need the swift2_xcode7 branch!

Contents
========
OSXGMP is made with Xcode 6.4 / Xcode 7.0 and contains:
- A GMP header file, a binary library build with the latest GMP 6.0.0.a release
(https://gmplib.org) and the latest documentation in PDF format.
- Ready to use Xcode project created with the OSX 'Command Line Tool' template and
having two targets: the OSXGMP command line tool (Swift interface) and an OSXGMPTest
target having test-classes for the Objective-C and Swift wrappers.

Installation
============
* Download the OSXGMP project on your computer (see above requirements to take into
account your swift-version and which branch to select).
* Note that the project is ready to use for playing with the Swift binding!
If you want to use only the Objective-C binding, you've to create a new
Objective-C 'Command Line Tool' project and copy / paste the appropriate files.

Usage
=====
* Navigate to and double-click the OSXGMP.xcodeproj file, which should startup your Xcode.
* If you select in the OSXGMP project the OSXGMP.scheme you can start playing with the
Swift wrapper by adding your own code in the OSXGMP/main.swift file and use 'Xcode>Product>Run'
to view the output in Xcode's console.

Depending on which github-branch you downloaded, you will find either one of the
following examples:

Swift 1.2 / Xcode 6.4 example code for multiplying two BigInt's:
```
print("Hello, OSXGMP / BigInt World!\n")
var err : NSError?
var bi1 = BigInt(nr: 12468642135797531)
var bi2 = BigInt(nr: "12345678901011121314151617181920", error: &err)
var res = bi1 * bi2
println("Multiply 2 BigInts: bi1 * bi2 = \(res.toString())")
```
yields the following result:
```
Multiply 2 BigInts: bi1 * bi2 = 153933852140173822960829726365674325601913839520
```

Swift 2.0 / Xcode 7 example code for multiplying two BigInt's:
```
print("Hello (Swift2.0/Xcode7), OSXGMP / BigInt World!\n")

var bi1 = BigInt(intNr: 12468642135797531)
do {
    var bi2 = try BigInt(stringNr: "12345678901011121314151617181920")
    var res = bi1 * bi2
    print("Multiply 2 BigInts: bi1 * bi2 = \(res.toString())")
} catch BigIntError.EmptyStringNumber {
    print("EmptyStringNumber for bi2")
} catch BigIntError.InvalidBaseNumber {
    print("InvalidBaseNumber for bi2")
} catch BigIntError.InvalidNumberFormat {
    print("InvalidNumberFormat for bi2")
}
```
yields the following result:
```
Multiply 2 BigInts: bi1 * bi2 = 153933852140173822960829726365674325601913839520
```

Tests
=====
GNU GMP has its own testsuite which is executed when building the libgmp.a. On my machine
(MacMini 2014, OSX 10.9.5 and Xcode 6.1) all tests passed successfully, and within the
OSXGMP-project the binary libgmp.a is included.

In order to test the appropriate wrappers I added in the OSXGMP-project a BigIntObjCTest
and BigIntSwiftTest class for respectively testing the Objecive-C and Swift-wrapper. If
you select the OSXGMPTest.scheme in Xcode and run it with 'Xcode>Product>Test' all
testcases should be executed.

I encourage you to critically look at the test-cases, and add where necessary, new ones.
In the accompanying test-code and 'BigInt.swift'-file enough comment / suggestions should
be present ("the code is the documentation") in order to create your own test-cases.

Roadmap
=======
* In the first version I'ld like to accomplish full coverage of all standard mathematical
related computations regarding large integer (whole) numbers.
* In the second version I'ld like to do the same for large floating point numbers.
* In the third version I'ld like to accomplish the same for rational numbers.
* In the fourth version I'ld like to add number theoretic related functions, some of which
may come in handy for solving 'Project Euler' problems.
* Depending on results (and feedback) in the previous versions, there's still a lot of
interesting stuff to do and add.

Contributors
============
Currently I'm the only developer, but hopefully this list can be extended with other
contributors.<br>More info about me can be found at: http://nl.linkedin.com/in/ottovanverseveld/

Thanks goes to Apple in providing Xcode's Objective-C and Swift tools and especially to
all the people involved in building and maintaining the GNU GMP library (https://gmplib.org/devel/).

License
=======
* The included GMP documentation (gmp-man-6.0.0a.pdf) falls under the terms of
the 'GNU Free Documentation License'.
* The GNU MP library is dual licensed under the conditions of the GNU Lesser General
Public License version 3, or the GNU General Public License version 2. More on this on page 1
of the gmp-man-6.0.0a.pdf document.
* All the Objective-C and Swift code files are licensed under the terms of the
GNU Lesser General Public License version 3 (see COPYINGv3), or any later version.
* Note: If you are using any code of this project in an app submitted to the AppStore, I would love to hear it such that I can make a list of references to Apps benefitting from my work. Thanks in advance!
