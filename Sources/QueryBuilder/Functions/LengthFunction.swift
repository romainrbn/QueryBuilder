//
//  LengthFunction.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

struct LengthFunction<Base: QueryExpression>: QueryExpression {
    typealias QueryValue = Int
    let base: Base
    var queryString: String {
        "length(\(base.queryString))"
    }
}
