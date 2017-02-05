view: tourney_seeds {
  sql_table_name: marchMadness2017.tourneySeeds ;;

  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
  }

  dimension: seed {
    type: string
    sql: ${TABLE}.seed ;;
  }

  dimension: team {
    type: number
    sql: ${TABLE}.team ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
