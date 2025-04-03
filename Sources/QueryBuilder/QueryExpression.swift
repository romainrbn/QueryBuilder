//
//  QueryExpression.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

/// A protocol that represents a component of a SQL query.
protocol QueryExpression<QueryValue> {
    associatedtype QueryValue = ()
    var queryString: String { get }
}
