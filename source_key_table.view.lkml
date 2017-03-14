view: source_key_table {
  sql_table_name: marchMadness2017.source_key_table ;;

  dimension: espn_id {
    type: number
    sql: ${TABLE}.ESPN_ID ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME ;;
  }

  dimension: primary_key {
    primary_key: yes
    type: number
    sql: ${TABLE}.PRIMARY_KEY ;;
  }

#   dimension: final_record {
#     type: string
#     sql: ${team_game_season_facts.final_record} ;;
#     html: <p> {{value}} </p> ;;
#   }
#
# <p> {{team_game_season_facts.final_record._value}} </p>
  measure: count {
    type: count
    approximate_threshold: 100000
    drill_fields: [name]
  }
}
