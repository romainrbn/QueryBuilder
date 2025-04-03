//
//  Table.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

/// Represents a database table.
protocol Table {
    associatedtype Columns
    static var tableName: String { get }
    static var columns: Columns { get }
}

/// Provides convenience methods for constructing SQL queries on tables.
extension Table {
    /// Constructs a SELECT query with the specified column names.
    static func select(_ columns: String...) -> Select<Self> {
        Select(columns: columns)
    }

    /// Constructs a SELECT query using column expressions provided by a result builder.
    static func select<each ResultColumn: QueryExpression>(
        _ columns: (Columns) -> (repeat each ResultColumn)
    ) -> Select<Self> {
        let columns = columns(Self.columns)
        var columnStrings: [String] = []
        for column in repeat each columns {
            columnStrings.append(column.queryString)
        }
        return Select(
            columns: columnStrings
        )
    }

    /// Constructs a SELECT query that selects all columns.
    ///
    /// For example:
    /// ```swift
    /// let query = Reminder.all()
    /// print(query.queryString)
    /// ```
    /// Gives:
    /// ```SQL
    /// SELECT *
    /// FROM reminders
    /// ```
    static func all() -> Select<Self> {
        Select(columns: [])
    }

    /// Constructs a SELECT query that counts the rows.
    ///
    /// ```swift
    /// let query = Reminder.select { $0.id.count() }
    /// print(query.queryString)
    /// ```
    /// Gives:
    /// ```SQL
    /// SELECT count(id)
    /// FROM reminders
    /// ```
    static func count() -> Select<Self> {
        Select(columns: ["count(*)"])
    }
}
