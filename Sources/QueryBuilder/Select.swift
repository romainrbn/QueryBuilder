//
//  Select.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

/// A query builder for constructing SELECT SQL queries.
public struct Select<From: Table>: QueryExpression {
    var columns: [String]
    var orders: [String] = []
    var wheres: [String] = []

    public var queryString: String {
        var sql = """
        SELECT \(columns.isEmpty ? "*" : columns.joined(separator: ", "))
        FROM \(From.tableName)
        """
        if !wheres.isEmpty {
            sql.append("\nWHERE \(wheres.joined(separator: " AND "))")
        }
        if !orders.isEmpty {
            sql.append("\nORDER BY \(orders.joined(separator: ", "))")
        }
        return sql
    }

    /// Adds an ORDER BY clause using a result builder.
    /// ```swift
    /// Reminder.all()
    ///    .order {
    ///        if shouldSortByTitle {
    ///            ($0.title.collate(.nocase).desc(), $0.priority)
    ///        } else {
    ///            ($0.isCompleted, $0.id.desc())
    ///        }
    ///    }
    /// ```
    ///
    /// Is equivalent to:
    /// ```SQL
    /// SELECT *
    /// FROM reminders
    /// ORDER BY isCompleted, id DESC
    /// ```
    public func order(
        @OrderBuilder build orders: (From.Columns) -> [String]
    ) -> Select {
        Select(
            columns: columns,
            orders: self.orders + orders(From.columns),
            wheres: self.wheres
        )
    }

    /// Adds an ORDER BY clause with a variadic list of ordering terms.
    /// ```swift
    /// Reminder.all().order { ($0.priority, $0.title) }
    /// ```
    ///
    /// Is equivalent to:
    /// ```SQL
    /// SELECT *
    /// FROM reminders
    /// ORDER BY priority, title
    /// ```
    public func order<each OrderingTerm: QueryExpression>(
        _ orders: (From.Columns) -> (repeat each OrderingTerm)
    ) -> Select {
        let orders = orders(From.columns)
        var orderStrings: [String] = []
        for order in repeat each orders {
            orderStrings.append(order.queryString)
        }

        return Select(
            columns: columns,
            orders: self.orders + orderStrings,
            wheres: self.wheres
        )
    }

    /// Adds a WHERE clause based on the given predicate.
    /// ```swift
    /// Reminder.all().where { $0.isCompleted }
    /// ```
    ///
    /// Gives us:
    /// ```SQL
    /// SELECT *
    /// FROM reminders
    /// WHERE isCompleted
    /// ```
    public func `where`(
        _ predicate: (From.Columns) -> some QueryExpression<Bool>
    ) -> Select {
        Select(
            columns: columns,
            orders: orders,
            wheres: wheres + [predicate(From.columns).queryString]
        )
    }
}
