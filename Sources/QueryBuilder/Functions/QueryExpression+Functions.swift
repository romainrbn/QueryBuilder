//
//  QueryExpression+Functions.swift
//  QueryBuilder
//
//  Created by Romain Rabouan on 03/04/2025.
//

extension QueryExpression {
    func count(distinct: Bool = false) -> some QueryExpression {
        CountFunction(base: self, isDistinct: distinct)
    }

    func avg() -> some QueryExpression {
        AvgFunction(base: self)
    }

    func asc(nulls nullOrder: NullOrder? = nil) -> some QueryExpression {
        OrderingTerm(isAscending: true, nullOrder: nullOrder, base: self)
    }

    func desc(nulls nullOrder: NullOrder? = nil) -> some QueryExpression {
        OrderingTerm(isAscending: false, nullOrder: nullOrder, base: self)
    }
}

extension QueryExpression<String> {
    func groupConcat(separator: String? = nil) -> some QueryExpression {
        GroupConcatFunction(base: self, separator: separator)
    }

    func length() -> some QueryExpression<Int> {
        LengthFunction(base: self)
    }

    func collate(_ collation: Collation) -> some QueryExpression {
        Collate(collation: collation, base: self)
    }
}
