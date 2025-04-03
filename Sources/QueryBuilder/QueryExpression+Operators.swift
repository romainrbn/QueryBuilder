//
//  Negate.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

// MARK: - NOT Condition

/// Negates a boolean query expression.
///
/// For example, you can build a query like this:
/// ```swift
/// Reminder.all().where { !$0.isCompleted }
/// ```
///
/// Which is equivalent to:
/// ```SQL
/// SELECT *
/// FROM reminders
/// WHERE NOT (isCompleted)
/// ```
prefix func ! (expression: some QueryExpression<Bool>) -> some QueryExpression<Bool> {
    Negate(base: expression)
}

/// Negates a boolean query expression.
struct Negate<Base: QueryExpression<Bool>>: QueryExpression {
    typealias QueryValue = Bool
    let base: Base
    var queryString: String {
        "NOT (\(base.queryString))"
    }
}

// MARK: Equals

/// Overloads the equality operator for non-optional query expressions.
func == <T>(lhs: some QueryExpression<T>, rhs: some QueryExpression<T>) -> some QueryExpression<Bool> {
    Equals(lhs: lhs, rhs: rhs)
}

/// Overloads the equality operator for an optional and non-optional query expression.
func == <T>(lhs: some QueryExpression<T?>, rhs: some QueryExpression<T>) -> some QueryExpression<Bool> {
    Equals(lhs: lhs, rhs: rhs)
}

/// Overloads the equality operator for a non-optional and optional query expression.
func == <T>(lhs: some QueryExpression<T>, rhs: some QueryExpression<T?>) -> some QueryExpression<Bool> {
    Equals(lhs: lhs, rhs: rhs)
}

/// Represents an equality comparison between two query expressions.
/// - Parameter lhs: The first element to compare
/// - Parameter rhs: The second element to compare
/// - Returns: A `QueryExpression` for the `=` condition between the two elements.
struct Equals<LHS: QueryExpression, RHS: QueryExpression>: QueryExpression {
    typealias QueryValue = Bool
    let lhs: LHS
    let rhs: RHS

    var queryString: String {
        "(\(lhs.queryString) = \(rhs.queryString))"
    }
}

// MARK: OR

/// Logical OR operator for boolean query expressions.
func || (lhs: some QueryExpression<Bool>, rhs: some QueryExpression<Bool>) -> some QueryExpression<Bool> {
    Or(lhs: lhs, rhs: rhs)
}

/// Represents a logical OR between two boolean query expressions.
/// - Parameter lhs: The first element to compare
/// - Parameter rhs: The second element to compare
/// - Returns: A `QueryExpression` for the OR condition between the two elements.
struct Or<LHS: QueryExpression, RHS: QueryExpression>: QueryExpression {
    typealias QueryValue = Bool
    let lhs: LHS
    let rhs: RHS

    var queryString: String {
        "(\(lhs.queryString) OR \(rhs.queryString))"
    }
}

// MARK: - AND

/// Logical AND operator for boolean query expressions.
func && (lhs: some QueryExpression<Bool>, rhs: some QueryExpression<Bool>) -> some QueryExpression<Bool> {
    And(lhs: lhs, rhs: rhs)
}

/// Represents a logical AND between two boolean query expressions.
/// - Parameter lhs: The first element to compare
/// - Parameter rhs: The second element to compare
/// - Returns: A `QueryExpression` for the AND condition between the two elements.
struct And<LHS: QueryExpression, RHS: QueryExpression>: QueryExpression {
    typealias QueryValue = Bool
    let lhs: LHS
    let rhs: RHS

    var queryString: String {
        "(\(lhs.queryString) AND \(rhs.queryString))"
    }
}

// MARK: - Misc

extension Int: QueryExpression {
    typealias QueryValue = Self
    var queryString: String { "\(self)" }
}
