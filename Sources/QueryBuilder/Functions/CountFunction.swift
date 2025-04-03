//
//  CountFunction.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

public struct CountFunction<Base: QueryExpression>: QueryExpression {
    let base: Base
    let isDistinct: Bool
    public var queryString: String {
        "count(\(isDistinct ? "DISTINCT " : "")\(base.queryString))"
    }
}
