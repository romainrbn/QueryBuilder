//
//  GroupConcatFunction.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

public struct GroupConcatFunction<Base: QueryExpression>: QueryExpression {
    let base: Base
    let separator: String?
    public var queryString: String {
        "group_concat(\(base.queryString)\(separator.map { ", '\($0)'" } ?? ""))"
    }
}
