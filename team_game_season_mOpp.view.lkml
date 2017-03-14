view: team_game_season_mOpp {
  derived_table: {
    sql: SELECT primary_key, team_id, daynum, season, opponent, opponent_name, count(distinct team_id) OVER (PARTITION BY opponent) as count_opponent  FROM ${team_game_season_facts.SQL_TABLE_NAME}
         WHERE NOT ( {% condition game_by_game_comparison.team_1 %} opponent_name {% endcondition %}  )
        ;;
  }

  measure: count {
    type: count
  }

  dimension: primary_key {
    type: string
    sql: ${TABLE}.primary_key ;;
    primary_key: yes
  }

  dimension: team_id {
    type: number
    sql: ${TABLE}.team_id ;;
  }

  dimension: daynum {
    type: number
    sql: ${TABLE}.daynum ;;
  }

  dimension: count_opponent {
    type: number
    sql: ${TABLE}.count_opponent ;;
  }

}
