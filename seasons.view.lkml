view: seasons {
  sql_table_name: marchMadness2017.seasons ;;

  dimension_group: dayzero {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.dayzero ;;
  }

  dimension_group: game_date {
    type: time
    group_label: "Game Data"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: DATE_ADD(${dayzero_raw},${allRecords.daynum},"DAY") ;;
  }

  dimension: regionw {
    type: string
    sql: ${TABLE}.regionw ;;
  }

  dimension: regionx {
    type: string
    sql: ${TABLE}.regionx ;;
  }

  dimension: regiony {
    type: string
    sql: ${TABLE}.regiony ;;
  }

  dimension: regionz {
    type: string
    sql: ${TABLE}.regionz ;;
  }

  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
