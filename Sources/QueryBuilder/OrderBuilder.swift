//
//  OrderBuilder.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

@resultBuilder
public enum OrderBuilder {
    public static func buildBlock(_ components: [String]) -> [String] {
        components
    }

    public static func buildOptional(_ component: [String]?) -> [String] {
        component ?? []
    }

    public static func buildEither(first component: [String]) -> [String] {
        component
    }

    public  static func buildEither(second component: [String]) -> [String] {
        component
    }

    public static func buildExpression<each OrderingTerm: QueryExpression>(
        _ orders: (repeat each OrderingTerm)
    ) -> [String] {
        var orderStrings: [String] = []
        for order in repeat each orders {
            orderStrings.append(order.queryString)
        }
        return orderStrings
    }
}
