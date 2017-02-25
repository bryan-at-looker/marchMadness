view: a_test {
  sql_table_name: tourneyDetailedResults ;;
  filter: date1 {
    type: date
  }
  filter: date2 {
    type: date
  }
  dimension: date1_ts {
    type: string
    sql: CONCAT(STRFTIME_UTC_USEC(${date1}, '%Y-%m-%d %H:%M:%S'), "+00") ;;
  }
  dimension: date2_ts {
    type: string
    sql: CONCAT(STRFTIME_UTC_USEC(${date2}, '%Y-%m-%d %H:%M:%S'), "+00") ;;
  }
  dimension: date3 {
    type: string
    sql: concat(${date1_ts},${date2_ts}) ;;
  }
}
