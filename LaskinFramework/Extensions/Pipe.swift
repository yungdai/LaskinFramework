//
//  Pipe.swift
//  LaskinMobileApp
//
//  Created by Christopher Szatmary on 2017-11-06.
//  Copyright © 2017 Yung Dai. All rights reserved.
//

import Foundation

precedencegroup PipePrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator |>: PipePrecedence
infix operator |>?: PipePrecedence
infix operator |>!: PipePrecedence

/// Represents any function with one parameter.
public typealias UnaryFunction<A, X> = (A) -> X

/// Represents any function with two parameters.
public typealias BinaryFunction<A, B, X> = (A, B) -> X

/// Represents any function with three parameters.
public typealias TernaryFunction<A, B, C, X> = (A, B, C) -> X

// MARK: - Pipes

/// Passes the value to the left of the operator as the parameter of the unary function to the right of the operator.
public func |> <A,X>(lhs: A, rhs: UnaryFunction<A, X>) -> X {
    return rhs(lhs)
}

/// Passes the value to the left of the operator as the first parameter of the binary function to the right of the operator.
public func |> <A,B,X>(lhs: A, rhs: (BinaryFunction<A, B, X>, B)) -> X {
    return rhs.0(lhs, rhs.1)
}

/// Passes the value to the left of the operator as the first parameter of the ternary function to the right of the operator.
public func |> <A,B,C,X>(lhs: A, rhs: (TernaryFunction<A, B, C, X>, B, C)) -> X {
    return rhs.0(lhs, rhs.1, rhs.2)
}

// MARK: - Optional Pipes

/// Passes the optional value to the left of the operator as the parameter of the unary function to the right of the operator.
public func |>? <A,X>(lhs: A?, rhs: UnaryFunction<A, X>) -> X? {
    return lhs.map(rhs)
}

/// Passes the optional value to the left of the operator as the first parameter of the binary function to the right of the operator.
public func |>? <A,B,X>(lhs: A?, rhs: (BinaryFunction<A, B, X>, B)) -> X? {
    return lhs.map { rhs.0($0, rhs.1) }
}

/// Passes the optional value to the left of the operator as the first parameter of the ternary function to the right of the operator.
public func |>? <A,B,C,X>(lhs: A?, rhs: (TernaryFunction<A, B, C, X>, B, C)) -> X? {
    return lhs.map { rhs.0($0, rhs.1, rhs.2) }
}

// MARK: - Force-unwrap Pipes

/// Force-unwraps the optional value to the left of the operator and passes it as the parameter of the unary function to the right of the operator.
public func |>! <A,X>(lhs: A?, rhs: UnaryFunction<A, X>) -> X {
    return rhs(lhs!)
}

/// Force-unwraps the optional value to the left of the operator and passes it as the first parameter of the binary function to the right of the operator.
public func |>! <A,B,X>(lhs: A?, rhs: (BinaryFunction<A, B, X>, B)) -> X {
    return rhs.0(lhs!, rhs.1)
}

/// Force-unwraps the optional value to the left of the operator and passes it as the first parameter of the ternary function to the right of the operator.
public func |>! <A,B,C,X>(lhs: A?, rhs: (TernaryFunction<A, B, C, X>, B, C)) -> X {
    return rhs.0(lhs!, rhs.1, rhs.2)
}
