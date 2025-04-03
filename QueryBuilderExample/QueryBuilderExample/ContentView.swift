//
//  ContentView.swift
//  QueryBuilderExample
//
//  Created by Romain Rabouan on 03/04/2025.
//

import SwiftUI
import QueryBuilder

struct ContentView: View {
    var body: some View {
        let query = Reminder.select("id")

        Text(query.queryString)
    }
}

#Preview {
    ContentView()
}

struct Reminder: QueryBuilder.Table {
    struct Columns {
        let id = Column<Int>(name: "id")
        let title = Column<String>(name: "title")
        let isCompleted = Column<Bool>(name: "isCompleted")
        let priority = Column<Int?>(name: "priority")
    }

    static let columns: Columns = Columns()
    static let tableName: String = "reminders"

    let id: Int
    var title = ""
    var isCompleted = false
    var priority: Int?

    var titleIsLong: Bool { title.count >= 100 }
}
