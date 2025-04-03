//
//  Internal.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 10/03/2025.
//

import Foundation
import InlineSnapshotTesting
@testable import QueryBuilder

extension Snapshotting where Value: QueryExpression, Format == String {
    static var sql: Self {
        Snapshotting<String, String>.lines.pullback(\.queryString)
    }
}
