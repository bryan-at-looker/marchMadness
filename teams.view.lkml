view: teams {
  sql_table_name: marchMadness2017.teams ;;

  dimension: team_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.team_id ;;
  }

  dimension: team_name {
    type: string
    sql: ${TABLE}.team_name ;;
  }

  measure: count {
    type: count
    drill_fields: [team_id, team_name]
  }
}
