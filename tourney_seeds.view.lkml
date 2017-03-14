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

  dimension: region {
    type: string
    sql: CASE WHEN ${group} = 'W' THEN ${season.regionw}
              WHEN ${group} = 'X' THEN ${season.regionx}
              WHEN ${group} = 'Y' THEN ${season.regiony}
              WHEN ${group} = 'Z' THEN ${season.regionz}
              ELSE null END
           ;;
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
