//
//  Collation.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

public enum Collation: String {
    case nocase = "NOCASE"
    case binary = "BINARY"
    case rtrim = "RTRIM"
}

public struct Collate<Base: QueryExpression>: QueryExpression {
    let collation: Collation
    let base: Base

    public var queryString: String {
        "\(base.queryString) COLLATE \(collation.rawValue)"
    }
}
