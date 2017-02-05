view: tourney_slots {
  sql_table_name: marchMadness2017.tourneySlots ;;

  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
  }

  dimension: slot {
    type: string
    sql: ${TABLE}.slot ;;
  }

  dimension: strongseed {
    type: string
    sql: ${TABLE}.strongseed ;;
  }

  dimension: weakseed {
    type: string
    sql: ${TABLE}.weakseed ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
