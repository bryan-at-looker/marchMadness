view: tourney_compact_results {
  sql_table_name: marchMadness2017.tourneyCompactResults ;;

  dimension: daynum {
    type: number
    sql: ${TABLE}.daynum ;;
  }

  dimension: lscore {
    type: number
    sql: ${TABLE}.lscore ;;
  }

  dimension: lteam {
    type: number
    sql: ${TABLE}.lteam ;;
  }

  dimension: numot {
    type: number
    sql: ${TABLE}.numot ;;
  }

  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
  }

  dimension: wloc {
    type: string
    sql: ${TABLE}.wloc ;;
  }

  dimension: wscore {
    type: number
    sql: ${TABLE}.wscore ;;
  }

  dimension: wteam {
    type: number
    sql: ${TABLE}.wteam ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
