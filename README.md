# Practical MySQL Query Optimization Patterns

> Real-world MySQL optimization techniques, anti-patterns, and performance tuning examples collected from production experience, database investigations, and performance analysis.

This repository demonstrates practical query optimization patterns for MySQL 8+, including indexing strategies, JOIN optimization, pagination techniques, aggregation tuning, execution-plan pitfalls, and scalable query design.

## Who is this repository for?

- Backend engineers
- Database engineers
- Java/Spring developers
- SRE / platform engineers
- Developers preparing for senior interviews
- Engineers troubleshooting slow SQL queries

| Topic | Problem | Main Idea |
|---|---|---|
| [Index to match your WHERE + ORDER BY](scripts/index_to_match_your_WHERE_ORDER_BY.sql) | MySQL performs filesort or full scans | Design composite indexes that align with filtering and sorting patterns |
| [Avoid SELECT * in large/hot queries](scripts/avoid_SELECT_all_large-hot_queries.sql) | Excessive I/O and unnecessary column reads | Select only required columns to reduce memory, network, and disk overhead |
| [Avoid functions on indexed columns in WHERE](scripts/avoid_functions_on_indexed_columns_in_WHERE.sql) | Index becomes unusable | Rewrite predicates to preserve index range scans |
| [Optimize IN / OR conditions](scripts/optimize_IN_OR_conditions.sql) | Poor index usage and planner confusion | Rewrite conditions or split queries to improve access paths |
| [Pagination: OFFSET vs seek method](scripts/pagination_OFFSET_vs_seek_method.sql) | Large OFFSET values cause deep scans | Use keyset/seek pagination for scalable page navigation |
| [JOINs: index foreign keys and join columns](scripts/joins_index_foreign_keys_and_join_columns.sql) | Expensive join operations and table scans | Add indexes on join keys to improve lookup efficiency |
| [GROUP BY / aggregation optimization](scripts/group_by_aggregation_optimization.sql) | Temporary tables and filesorts slow queries | Use covering indexes and pre-filtering before aggregation |
| [Avoid hidden implicit type conversions](scripts/avoid_hidden_implicit_type_conversions.sql) | Indexes silently ignored | Ensure matching data types in joins and predicates |
| [IN (SELECT …) → JOIN (or EXISTS)](scripts/in_select_join_or_exists.sql) | Subqueries may produce inefficient execution plans | Replace dependent subqueries with JOIN or EXISTS patterns |
| [NOT IN with NULLs → NOT EXISTS](scripts/not_in_with_nulls_not_exists.sql) | NULL semantics can break logic and performance | Use NOT EXISTS for predictable behavior and optimization |
| [DISTINCT used as a band-aid → better join/schema](scripts/distinct_used_as_band-aid_better_join_schema.sql) | Duplicate elimination hides schema or join problems | Fix join logic or schema design instead of masking duplicates |
| [LIKE '%term%' → index-friendly search](scripts/like_term_index_friendly_search.sql) | Leading wildcards disable indexes | Use prefix searches, full-text indexes, or search engines |
| [Many-to-many junction optimization](scripts/many_to_many_junction_optimization.sql) | Junction tables become bottlenecks at scale | Optimize composite indexes and access order for junction tables |
| [HAVING vs WHERE](scripts/having_vs_where.sql) | Filtering happens too late | Push predicates into WHERE whenever possible |
| [Eliminating row explosion in JOINs](scripts/eliminating_row_explosion_in_joins.sql) | Joins multiply rows and increase workload | Reduce join cardinality before aggregation or projection |
| [Moving calculations out of the query](scripts/moving_calculations_out_of_the_query.sql) | CPU-heavy computations slow execution | Precompute or move calculations outside hot query paths |
| [Avoid DATE() on indexed datetime columns](scripts/avoid_function_on_datetime_index.sql) | Function calls prevent index range scans | Use explicit datetime ranges instead of DATE() |
| [Composite index leftmost prefix rule](scripts/leftmost_prefix_trap.sql) | Composite indexes partially ignored | Align query predicates with leftmost index columns |
| [Deep pagination with delayed join](scripts/deep_pagination_delayed_join.sql) | Large paginated joins become extremely expensive | First paginate lightweight IDs, then join full records |
| [Partitioning + partition pruning](scripts/partitioning_partition_pruning.sql) | Large time-series tables scan too much data | Partition tables to reduce scanned partitions and improve pruning |
| [Use covering indexes for hot queries](scripts/use_covering_indexes_for_hot_queries.sql) | Extra table lookups increase I/O cost | Include queried columns in indexes to satisfy queries directly from the index |
| [Remove unused or redundant indexes](scripts/remove_unused_or_redundant_indexes.sql) | Too many indexes slow down writes and waste memory | Eliminate duplicate or unused indexes to reduce maintenance overhead |
| [Temporary tables & "Using temporary; Using filesort"](scripts/temporary_tables_using_temporary_using_filesort.sql) | Sorting and aggregation spill into expensive temporary operations | Optimize indexes and query structure to reduce temporary tables and filesorts |
| [Using STRAIGHT_JOIN when planner guesses wrong](scripts/using_STRAIGHT_JOIN_when_planner_guesses_wrong.sql) | Query planner chooses inefficient join order | Force a more efficient join sequence when optimizer estimates are poor |
| [Removing useless ORDER BY in subqueries](scripts/removing_useless_ORDER_BY_in_subqueries.sql) | Unnecessary sorting increases execution time | Remove ORDER BY clauses that do not affect final results |
| [Turning a big UPDATE into smaller batches](scripts/turning_big_update_into_smaller_batches.sql) | Large updates create locks, replication lag, and long transactions | Split updates into smaller chunks for safer incremental processing |
| [Small summary / reporting table](scripts/small_summary_reporting_table.sql) | Expensive aggregations repeatedly scan huge datasets | Pre-aggregate data into lightweight reporting tables |
| [UNION vs UNION ALL](scripts/union_vs_union_all.sql) | Duplicate elimination adds unnecessary sorting and overhead | Use UNION ALL when deduplication is not required |
| [Pre-filter join input with a temp table](scripts/pre_filter_join_input_with_temp_table.sql) | Large joins process too many irrelevant rows | Reduce join input size before executing expensive joins |
| [UNION ALL instead of OR on different indexed columns](scripts/union_all_instead_of_or.sql) | OR conditions prevent efficient index usage | Split predicates into separate indexed queries combined with UNION ALL |

## References:
1. Daniel Nichter Efficient MySQL Performance.Best Practices and Techniques. O'REILLY, 2022, 335 pages.
2. Jesper Wisborg Krogh. MySQL 8 Query Performance Tuning: A Systematic Method for Improving Execution Speeds. Apress, 2020, 1002 pages.
3. Common sense and experience.
