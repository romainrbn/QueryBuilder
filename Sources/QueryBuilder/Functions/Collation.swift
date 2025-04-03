//
//  Collation.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

enum Collation: String {
    case nocase = "NOCASE"
    case binary = "BINARY"
    case rtrim = "RTRIM"
}

struct Collate<Base: QueryExpression>: QueryExpression {
    let collation: Collation
    let base: Base

    var queryString: String {
        "\(base.queryString) COLLATE \(collation.rawValue)"
    }
}
