//
//  Functional.swift
//  Rocket Insights
//
//  Created by Ilya Belenkiy on 3/17/21.
//  Copyright © 2021 Rocket Insights. All rights reserved.
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
