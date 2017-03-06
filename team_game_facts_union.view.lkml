view: team_game_facts_union {
  derived_table: {
    sql:
    SELECT *
      FROM (
        SELECT  * FROM ${team_game_season_facts.SQL_TABLE_NAME}
        WHERE {% condition game_nums.team_1 %} teams.team_name {% endcondition %} ) , (
        SELECT  * FROM ${team_game_season_facts.SQL_TABLE_NAME}
        WHERE {% condition game_nums.team_2 %} teams.team_name {% endcondition %} )
      ORDER BY teams.team_name, allRecords.season, allRecords.daynum )
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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

  dimension: team_name {
    type: string
    sql: ${TABLE}.team_name ;;
  }

  dimension: game_type {
    type: string
    sql: ${TABLE}.game_type ;;
  }

  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
  }

  dimension: opponent {
    type: number
    sql: ${TABLE}.opponent ;;
  }

  dimension: daynum {
    type: number
    sql: ${TABLE}.daynum ;;
  }

  dimension: result {
    type: string
    sql: ${TABLE}.result ;;
  }

  dimension: sum_wins {
    type: number
    sql: COALESCE ( ${TABLE}.sum_wins , 0 ) ;;
  }

  dimension: sum_losses {
    type: number
    sql: COALESCE ( ${TABLE}.sum_losses , 0 ) ;;
  }

  dimension: record {
    type: string
    sql: CONCAT( STRING(${sum_wins}),'-',STRING(${sum_losses}) ) ;;
  }

  dimension: win_percentage {
    type: number
    sql: 1.0 * ${sum_wins} / ${game_num} ;;
    value_format_name: percent_2
  }

  measure: win_percentage_2 {
    type: average
    sql: ${win_percentage} ;;
    value_format_name: percent_2
  }

  dimension: game_num {
    type: number
    sql: ${TABLE}.game_num ;;
  }

  dimension: running_score {
    type: number
    sql: ${TABLE}.running_score ;;
  }

  dimension: running_opponent_score {
    type: number
    sql: ${TABLE}.running_opponent_score ;;
  }

  set: detail {
    fields: [
      team_id,
      team_name,
      game_type,
      season,
      opponent,
      daynum,
      result,
      sum_wins,
      sum_losses,
      game_num,
      running_score,
      running_opponent_score
    ]
  }

}
