//
// Copyright (c) 2023 DEPT Digital Products, Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

public func concat<A, B>(_ f: @escaping (A) -> B, _ g: @escaping (inout B, A) -> Void) -> (A) -> B {
    { var b = f($0); g(&b, $0); return b }
}

// MARK: - Operators

precedencegroup ForwardApplication {
  associativity: left
}

infix operator |>: ForwardApplication

public func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

public func |> <A>(a: inout A, f: (inout A) -> Void) {
    f(&a)
}

public func |> <A>(a: A, f: (inout A) -> Void) -> A {
    var res = a; f(&res); return res
}

precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    {  g(f($0)) }
}

public func >>> <A, B>(f: @escaping (A) -> B, g: @escaping (inout B) -> Void) -> ((A) -> B) {
    {  var res = f($0); g(&res); return res }
}

precedencegroup SingleTypeComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator <> : SingleTypeComposition

public func <> <A>(f: @escaping (A) -> A, g: @escaping (A) -> A) -> ((A) -> A) {
    f >>> g
}

public func <> <A>(f: @escaping (inout A) -> Void, g: @escaping (inout A) -> Void) -> ((inout A) -> Void) {
    { a in f(&a); g(&a) }
}

public func <> <A>(f: @escaping (A) -> A, g: @escaping (inout A) -> Void) -> (A) -> A {
    { a in var b = f(a); g(&b); return b }
}

public func <> <A>(g: @escaping (inout A) -> Void, f: @escaping (A) -> A) -> (A) -> A {
    { a in var b = f(a); g(&b); return b }
}
