//
//  NullOrder.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

public enum NullOrder: String {
    case first = "FIRST"
    case last = "LAST"
}

public struct OrderingTerm<Base: QueryExpression>: QueryExpression {
    let isAscending: Bool
    let nullOrder: NullOrder?
    public let base: Base

    public var queryString: String {
        var sql = "\(base.queryString)\(isAscending ? " ASC" : " DESC")"
        if let nullOrder {
            sql.append(" NULLS \(nullOrder.rawValue)")
        }
        return sql
    }
}
