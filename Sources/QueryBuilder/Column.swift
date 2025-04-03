//
//  Column.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

/// Represents a SQL column
/// - Parameter QueryValue: The type of the column
/// - Parameter name: The name of the column
struct Column<QueryValue>: QueryExpression {
    var name: String
    var queryString: String { name }
}
