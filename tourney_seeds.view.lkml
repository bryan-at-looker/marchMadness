view: tourney_seeds {
  sql_table_name: marchMadness2017.tourneySeeds ;;

  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
  }

  dimension: seed {
    type: string
    sql: SUBSTR(${TABLE}.seed, -2,2) ;;
  }
  dimension: group {
    type: string
    sql:  SUBSTR(${TABLE}.seed, 1,1) ;;
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
