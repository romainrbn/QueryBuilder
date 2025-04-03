import Testing
import InlineSnapshotTesting
@testable import QueryBuilder

@Suite(.snapshots(record: .failed))
struct QueryBuilderTests {
    @Test
    func selectWithColumns() {
        assertInlineSnapshot(
            of: Reminder.select("id", "title", "priority"),
            as: .sql
        ) {
            """
            SELECT id, title, priority
            FROM reminders
            """
        }
    }

    @Test
    func selectAll() {
        assertInlineSnapshot(
            of: Reminder.all(),
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            """
        }
    }

    @Test
    func selectCount() {
        assertInlineSnapshot(
            of: Tag.count(),
            as: .sql
        ) {
            """
            SELECT count(*)
            FROM tags
            """
        }
    }

    @Test
    func fancySelect() {
        assertInlineSnapshot(
            of: Reminder
                .select {
                    ($0.id, $0.title, $0.priority, $0.isCompleted)
                },
            as: .sql
        ) {
            """
            SELECT id, title, priority, isCompleted
            FROM reminders
            """
        }
    }

    @Test
    func selectCountColumn() {
        assertInlineSnapshot(
            of: Reminder.select { $0.id.count() }, // count(id)
            as: .sql
        ) {
            """
            SELECT count(id)
            FROM reminders
            """
        }
    }

    @Test
    func selectCountDistinctColumn() {
        assertInlineSnapshot(
            of: Reminder.select { $0.id.count(distinct: true) }, // count(DISTINCT id)
            as: .sql
        ) {
            """
            SELECT count(DISTINCT id)
            FROM reminders
            """
        }
    }

    @Test
    func selectAvg() {
        assertInlineSnapshot(
            of: Reminder.select { $0.priority.avg() }, // avg(priority)
            as: .sql
        ) {
            """
            SELECT avg(priority)
            FROM reminders
            """
        }
    }

    @Test
    func selectAvgAndCount() {
        assertInlineSnapshot(
            of: Reminder.select { ($0.priority.avg(), $0.id.count()) }, // avg(priority), count(id)
            as: .sql
        ) {
            """
            SELECT avg(priority), count(id)
            FROM reminders
            """
        }
    }

    @Test
    func selectAdvanced() {
        assertInlineSnapshot(of: Reminder.select {
            (
                $0.id.count(distinct: true),
                $0.title.groupConcat(),
                $0.priority.avg()
            )
        }, as: .sql) {
            """
            SELECT count(DISTINCT id), group_concat(title), avg(priority)
            FROM reminders
            """
        }
    }

    @Test
    func selectOrder() {
        assertInlineSnapshot(
            of: Reminder.all().order { $0.title },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY title
            """
        }
    }

    @Test
    func selectOrderByMultipleColumns() {
        assertInlineSnapshot(
            of: Reminder.all().order { ($0.priority, $0.title) },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY priority, title
            """
        }
    }

    @Test
    func selectOrderByMultipleColumnsDesc() {
        assertInlineSnapshot(
            of: Reminder.all().order { ($0.priority.desc(), $0.title) },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY priority DESC, title
            """
        }
    }

    @Test
    func selectOrderByMultipleColumnsDescNulls() {
        assertInlineSnapshot(
            of: Reminder.all().order {
                (
                    $0.priority.desc(nulls: .first),
                    $0.title
                )
            },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY priority DESC NULLS FIRST, title
            """
        }
    }

    @Test
    func selectWithMultipleOrders() {
        assertInlineSnapshot(
            of: Reminder.all()
                .order { $0.priority.desc(nulls: .first) }
                .order { $0.title }
                .order { $0.id },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY priority DESC NULLS FIRST, title, id
            """
        }
    }

    @Test
    func selectOrderByExpression() {
        assertInlineSnapshot(
            of: Reminder.all().order { ($0.title.length().desc(), $0.isCompleted.desc()) },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY length(title) DESC, isCompleted DESC
            """
        }
    }

    @Test
    func selectOrderByExpressionCollation() {
        assertInlineSnapshot(
            of: Reminder.all().order { $0.title.collate(.nocase).desc() },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY title COLLATE NOCASE DESC
            """
        }
    }

    @Test
    func complexOrderBy() {
        let shouldSortByTitle = true
        assertInlineSnapshot(
            of: Reminder.all()
                .order {
                    if shouldSortByTitle {
                        $0.title.collate(.nocase).desc()
                    }
                },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY title COLLATE NOCASE DESC
            """
        }
    }

    @Test
    func complexOrderByFalseCondition() {
        let shouldSortByTitle = false
        assertInlineSnapshot(
            of: Reminder.all()
                .order {
                    if shouldSortByTitle {
                        $0.title.collate(.nocase).desc()
                    }
                },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            """
        }
    }

    @Test
    func complexOrderByElseCondition() {
        let shouldSortByTitle = false
        assertInlineSnapshot(
            of: Reminder.all()
                .order {
                    if shouldSortByTitle {
                        ($0.title.collate(.nocase).desc(), $0.priority)
                    } else {
                        ($0.isCompleted, $0.id.desc())
                    }
                },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY isCompleted, id DESC
            """
        }
    }

    @Test
    func complexOrderByElseTrueCondition() {
        let shouldSortByTitle = true
        assertInlineSnapshot(
            of: Reminder.all()
                .order {
                    if shouldSortByTitle {
                        $0.title.collate(.nocase).desc()
                    } else {
                        $0.isCompleted
                    }
                },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY title COLLATE NOCASE DESC
            """
        }
    }

    @Test
    func orderBySwitch() {
        enum Order { case title, priority }
        let order = Order.title
        assertInlineSnapshot(
            of: Reminder.all()
                .order {
                    switch order {
                    case .title: ($0.title.collate(.nocase).desc(), $0.isCompleted)
                    case .priority: $0.priority
                    }
                },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            ORDER BY title COLLATE NOCASE DESC, isCompleted
            """
        }
    }

    @Test
    func whereClause() {
        assertInlineSnapshot(
            of: Reminder.all().where { $0.isCompleted },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            WHERE isCompleted
            """
        }
    }

    @Test
    func whereClauseNegate() {
        assertInlineSnapshot(
            of: Reminder.all().where { !$0.isCompleted },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            WHERE NOT (isCompleted)
            """
        }
    }

    @Test
    func whereHighPriority() {
        assertInlineSnapshot(
            of: Reminder.all().where { $0.priority == 3 },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            WHERE (priority = 3)
            """
        }
    }

    @Test
    func whereTitleLengthEqual3() {
        assertInlineSnapshot(
            of: Reminder.all().where { $0.title.length() == 3 },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            WHERE (length(title) = 3)
            """
        }
    }

    @Test
    func whereTitleLengthEqualPriority() {
        assertInlineSnapshot(
            of: Reminder.all().where { $0.title.length() == $0.priority },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            WHERE (length(title) = priority)
            """
        }
    }

    @Test
    func whereIncompleteOrHighPriority() {
        assertInlineSnapshot(
            of: Reminder.all().where { !$0.isCompleted || $0.priority == 3 },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            WHERE (NOT (isCompleted) OR (priority = 3))
            """
        }
    }

    @Test
    func whereIncompleteAndHighPriority() {
        assertInlineSnapshot(
            of: Reminder.all().where { !$0.isCompleted && $0.priority == 3 },
            as: .sql
        ) {
            """
            SELECT *
            FROM reminders
            WHERE (NOT (isCompleted) AND (priority = 3))
            """
        }
    }
}

struct Reminder: Table {
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

struct Tag: Table {
    struct Columns {}
    static let tableName: String = "tags"
    static let columns: Columns = Columns()
}
