//
//  AvgFunction.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//


struct AvgFunction<Base: QueryExpression>: QueryExpression {
    let base: Base
    var queryString: String {
        "avg(\(base.queryString))"
    }
}