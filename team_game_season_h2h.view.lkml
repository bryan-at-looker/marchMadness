view: team_game_season_h2h {
  derived_table: {
    sql: SELECT * FROM ${team_game_season_facts.SQL_TABLE_NAME}
    WHERE opponent IN (SELECT team_id FROM ${team_game_season_facts.SQL_TABLE_NAME} )  ;;
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

  dimension: team_name {
    type: string
    sql: ${TABLE}.team_name ;;
  }

  measure: measure_team_name {
    type: max
    sql: ${team_name} ;;
    html: {{value}} ;;
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
    sql: CASE ${TABLE}.result WHEN 'W' THEN 'Winner' WHEN 'L' THEN 'Loser' ELSE null END ;;
  }

  dimension: sum_wins {
    type: number
    sql: COALESCE ( ${TABLE}.sum_wins , 0 ) ;;
  }

  dimension: sum_losses {
    type: number
    sql: COALESCE ( ${TABLE}.sum_losses , 0 ) ;;
  }

  dimension: season_wins {
    type: number
    sql: ${TABLE}.season_wins ;;
  }
  dimension: season_losses {
    type: number
    sql: ${TABLE}.season_losses ;;
  }

  dimension: record {
    type: string
    sql: CONCAT( STRING(${sum_wins}),'-',STRING(${sum_losses}) ) ;;
  }

  measure: record_measure {
    type: max
    sql: ${record} ;;
  }

  dimension: final_record {
    type: string
    sql: CONCAT( STRING(${season_wins}),'-',STRING(${season_losses}) ) ;;
  }

  measure: max_final_record {
    type: max
    sql: ${final_record} ;;
  }

  dimension: pregame_record {
    type: string
    sql: CASE WHEN ${result} = 'W' THEN CONCAT( STRING(${season_wins}-1),'-',STRING(${season_losses}) )
      WHEN ${result} = 'L' THEN CONCAT( STRING(${season_wins}-1),'-',STRING(${season_losses}-1) ) END;;
  }

  measure: measure_pregame_record{
    type: max
    sql: ${final_record} ;;
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

}
