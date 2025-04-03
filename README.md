# Swift SQL Query Builder

A type-safe, expressive SQL query builder for Swift that enables you to write SQL queries using Swift's native syntax.

## Features

- 🔒 Type-safe query building
- 💪 Powerful expression composition
- 🎯 Intuitive Swift-like syntax
- 📦 Zero dependencies

## Usage

### Basic Queries

```

// SELECT * FROM reminders
Reminder.all()

// SELECT id, title, priority FROM reminders
Reminder.select("id", "title", "priority")

// SELECT count(*) FROM reminders
Reminder.count()
```

### Column Selection

```

// SELECT id, title, priority, isCompleted FROM reminders
Reminder.select { 
    ($0.id, $0.title, $0.priority, $0.isCompleted)
}
```

### Aggregate Functions

```

// SELECT count(DISTINCT id), group_concat(title), avg(priority) FROM reminders
Reminder.select {
    (
        $0.id.count(distinct: true),
        $0.title.groupConcat(),
        $0.priority.avg()
    )
}
```

### WHERE Clauses

```

// SELECT * FROM reminders WHERE NOT isCompleted
Reminder.all().where { !$0.isCompleted }

// SELECT * FROM reminders WHERE (NOT isCompleted AND priority = 3)
Reminder.all().where { !$0.isCompleted && $0.priority == 3 }

// SELECT * FROM reminders WHERE (NOT isCompleted OR priority = 3)
Reminder.all().where { !$0.isCompleted || $0.priority == 3 }
```

### ORDER BY Clauses

```

// Simple ordering
Reminder.all().order { $0.title }

// Multiple columns
Reminder.all().order { ($0.priority, $0.title) }

// Descending order with NULLS handling
Reminder.all().order { $0.priority.desc(nulls: .first) }

// Complex ordering with string collation
Reminder.all().order { $0.title.collate(.nocase).desc() }
```

### Conditional Ordering

```

let shouldSortByTitle = true
Reminder.all().order {
    if shouldSortByTitle {
        ($0.title.collate(.nocase).desc(), $0.priority)
    } else {
        ($0.isCompleted, $0.id.desc())
    }
}
```

## Setting Up a Table

Define your tables by conforming to the `Table` protocol:

```

struct Reminder: Table {
    struct Columns {
        let id = Column<Int>(name: "id")
        let title = Column<String>(name: "title")
        let isCompleted = Column<Bool>(name: "isCompleted")
        let priority = Column<Int?>(name: "priority")
    }

    static let columns: Columns = Columns()
    static let tableName: String = "reminders"
}
```

## Available Functions

- `count()` / `count(distinct:)`
- `avg()`
- `length()`
- `groupConcat(separator:)`
- `collate(_:)` with `.nocase`, `.binary`, and `.rtrim` options

## Operators

- Equality: `==`
- Logical: `&&`, `||`
- Negation: `!`

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```

dependencies: [
    .package(url: "https://github.com/username/SQLQueryBuilder.git", from: "1.0.0")
]
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details. 
