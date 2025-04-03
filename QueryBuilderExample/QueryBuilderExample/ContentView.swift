//
//  ContentView.swift
//  QueryBuilderExample
//
//  Created by Romain Rabouan on 03/04/2025.
//

import SwiftUI
import QueryBuilder

struct ContentView: View {
    @State private var tables: [TableDefinition] = [
        TableDefinition(name: "reminders", columns: [
            ColumnDefinition(name: "id", type: "Int"),
            ColumnDefinition(name: "title", type: "String"),
            ColumnDefinition(name: "isCompleted", type: "Bool"),
            ColumnDefinition(name: "priority", type: "Int?")
        ]),
        TableDefinition(name: "tags", columns: [])
    ]


    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Table Designer", destination: TableDesignerView(tables: $tables))
                NavigationLink("Query Composer", destination: QueryComposerView(tables: tables))
            }
            .navigationTitle("SQL Query Builder Demo")
        }
    }
}

struct TableDesignerView: View {
    @Binding var tables: [TableDefinition]
    @State private var tableName: String = ""
    @State private var newColumnName: String = ""
    @State private var newColumnType: String = "String"
    @State private var selectedTableIndex: Int?

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Create New Table")) {
                    TextField("Table Name", text: $tableName)
                    Button("Create Table") {
                        guard !tableName.isEmpty else { return }
                        let newTable = TableDefinition(name: tableName, columns: [])
                        tables.append(newTable)
                        tableName = ""
                    }
                }

                if let index = selectedTableIndex {
                    Section(header: Text("Edit Table: \(tables[index].name)")) {
                        HStack {
                            TextField("Column Name", text: $newColumnName)
                            TextField("Column Type", text: $newColumnType)
                            Button("Add Column") {
                                guard !newColumnName.isEmpty else { return }
                                let newColumn = ColumnDefinition(name: newColumnName, type: newColumnType)
                                tables[index].columns.append(newColumn)
                                newColumnName = ""
                                newColumnType = "String"
                            }
                        }
                        List(tables[index].columns) { column in
                            HStack {
                                Text(column.name)
                                Spacer()
                                Text(column.type)
                            }
                        }
                    }
                }
            }
            .padding()

            List(selection: $selectedTableIndex) {
                ForEach(tables.indices, id: \.self) { index in
                    Text(tables[index].name)
                }
            }
            .frame(minWidth: 200)
        }
        .navigationTitle("Table Designer")
    }
}

/// A view that lets users compose a SQL query for a selected table.
struct QueryComposerView: View {
    let tables: [TableDefinition]
    @State private var selectedTableIndex: Int = 0
    @State private var queryComposition = QueryComposition()

    var body: some View {
        VStack(alignment: .leading) {
            Picker("Table", selection: $selectedTableIndex) {
                ForEach(tables.indices, id: \.self) { index in
                    Text(tables[index].name)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            let selectedTable = tables[selectedTableIndex]

            Form {
                Section(header: Text("Select Columns")) {
                    ForEach(selectedTable.columns) { column in
                        Toggle(isOn: Binding(
                            get: {
                                queryComposition.selectedColumns.contains(column)
                            },
                            set: { isSelected in
                                if isSelected {
                                    queryComposition.selectedColumns.insert(column)
                                } else {
                                    queryComposition.selectedColumns.remove(column)
                                }
                            }
                        )) {
                            Text("\(column.name) (\(column.type))")
                        }
                    }
                }

                Section(header: Text("Ordering")) {
                    ForEach(selectedTable.columns) { column in
                        HStack {
                            Text(column.name)
                            Spacer()
                            Toggle("Ascending", isOn: Binding(
                                get: {
                                    queryComposition.orderBy.first(where: { $0.0 == column })?.1 ?? true
                                },
                                set: { isAscending in
                                    if let index = queryComposition.orderBy.firstIndex(where: { $0.0 == column }) {
                                        queryComposition.orderBy[index].1 = isAscending
                                    } else {
                                        queryComposition.orderBy.append((column, isAscending))
                                    }
                                }
                            ))
                            .labelsHidden()
                        }
                    }
                }

                Section(header: Text("Where Clause (raw SQL)")) {
                    TextField("e.g., isCompleted = 0", text: $queryComposition.whereClause)
                }
            }

            Divider()
            Text("Generated SQL Query:")
                .font(.headline)
                .padding(.top)
            ScrollView {
                Text(queryComposition.generateSQL(for: selectedTable))
                    .padding()
                    .font(.system(.body, design: .monospaced))
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Query Composer")
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
