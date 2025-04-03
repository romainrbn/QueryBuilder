//
//  LengthFunction.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

public struct LengthFunction<Base: QueryExpression>: QueryExpression {
    public typealias QueryValue = Int
    let base: Base
    public var queryString: String {
        "length(\(base.queryString))"
    }
}
