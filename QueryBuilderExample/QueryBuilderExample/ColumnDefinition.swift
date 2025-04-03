//
//  ColumnDefinition.swift
//  QueryBuilderExample
//
//  Created by Romain Rabouan on 03/04/2025.
//

import Foundation
import QueryBuilder

struct ColumnDefinition: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var type: String
}

struct TableDefinition: Identifiable {
    let id = UUID()
    var name: String
    var columns: [ColumnDefinition]
}

struct QueryComposition {
    var selectedColumns: Set<ColumnDefinition> = []
    /// Stores ordering as a tuple (Column, isAscending)
    var orderBy: [(ColumnDefinition, Bool)] = []
    /// A raw SQL where clause entered by the user.
    var whereClause: String = ""

    /// Generates a SQL query string for a given table definition.
    func generateSQL(for table: TableDefinition) -> String {
        let columnsSQL = selectedColumns.isEmpty ? "*" : selectedColumns.map { $0.name }.joined(separator: ", ")
        var sql = "SELECT \(columnsSQL)\nFROM \(table.name)"
        if !whereClause.trimmingCharacters(in: .whitespaces).isEmpty {
            sql += "\nWHERE \(whereClause)"
        }
        if !orderBy.isEmpty {
            let orderSQL = orderBy.map { "\($0.0.name) " + ($0.1 ? "ASC" : "DESC") }.joined(separator: ", ")
            sql += "\nORDER BY \(orderSQL)"
        }
        return sql
    }
}

