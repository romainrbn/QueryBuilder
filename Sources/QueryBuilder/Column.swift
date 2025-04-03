//
//  Column.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

/// Represents a SQL column
/// - Parameter QueryValue: The type of the column
/// - Parameter name: The name of the column
public struct Column<QueryValue>: QueryExpression {
    public var name: String
    public var queryString: String { name }

    public init(name: String) {
        self.name = name
    }
}
