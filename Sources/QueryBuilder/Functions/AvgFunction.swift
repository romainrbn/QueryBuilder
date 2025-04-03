//
//  AvgFunction.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

public struct AvgFunction<Base: QueryExpression>: QueryExpression {
    let base: Base
    public var queryString: String {
        "avg(\(base.queryString))"
    }
}
