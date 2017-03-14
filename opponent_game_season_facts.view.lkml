view: opponent_game_season_facts {
  derived_table: {
    sql:
      SELECT
        CONCAT( STRING(allRecords.season) , "_" ,  allRecords.game_type , "_",
        STRING(allRecords.daynum)  , "_" , STRING(allRecords.team) ) as primary_key,
        teams.team_id as team_id,
        allRecords.daynum  AS daynum,
        DATE(DATE_ADD(TIMESTAMP(season_view.dayzero), allRecords.daynum, "DAY")) as game_date,
        teams.team  AS team_name,
        opponent.team as opponent_name,
        allRecords.game_type  AS game_type,
        allRecords.season  AS season,
        allRecords.opponent  AS opponent,
        allRecords.result  AS result,
        SUM(CASE WHEN (allRecords.result = 'W') THEN 1 ELSE NULL END) OVER (PARTITION BY teams.team_id, allRecords.season ORDER BY allRecords.daynum ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_wins,
        SUM(CASE WHEN (allRecords.result = 'L') THEN 1 ELSE NULL END)  OVER (PARTITION BY teams.team_id, allRecords.season ORDER BY allRecords.daynum ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum_losses,
        ROW_NUMBER() OVER (PARTITION BY teams.team_id, allRecords.season ORDER BY allRecords.daynum) as game_num,
        SUM(allRecords.score) OVER (PARTITION BY teams.team_id, allRecords.season ORDER BY allRecords.daynum) as running_score,
        SUM(allRecords.opponent_score) OVER (PARTITION BY teams.team_id, allRecords.season ORDER BY allRecords.daynum) as running_opponent_score,
        SUM(CASE WHEN (allRecords.result = 'W') THEN 1 ELSE NULL END) OVER (PARTITION BY teams.team_id, allRecords.season) as season_wins,
        SUM(CASE WHEN (allRecords.result = 'L') THEN 1 ELSE NULL END) OVER (PARTITION BY teams.team_id, allRecords.season) as season_losses

      FROM ${allRecords.SQL_TABLE_NAME} AS allRecords
      LEFT JOIN marchMadness2017.new_teams  AS teams ON allRecords.team = teams.team_id
      LEFT JOIN marchMadness2017.new_teams  AS opponent ON allRecords.opponent = opponent.team_id
      LEFT JOIN marchMadness2017.seasons AS season_view ON allRecords.season = season_view.season
      WHERE {% condition game_by_game_comparison.season %} STRING(allRecords.season) {% endcondition %}
       AND ( teams.team_id IN ( SELECT opponent FROM ${team_game_season_mOpp.SQL_TABLE_NAME} ) )
      ORDER BY teams.team, allRecords.season, allRecords.daynum
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

  measure: measure_team_name {
    type: string
    sql: MAX(${team_name}) ;;
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

  dimension: opponent_name {
    type: string
    sql: ${TABLE}.opponent_name ;;
  }

  dimension: matchup {
    type: string
    sql: CASE WHEN ${result} = 'W' THEN CONCAT( ${team_name}, '-', ${opponent_name} )
              WHEN ${result} = 'L' THEN CONCAT( ${opponent_name}, '-', ${team_name} )
              ELSE null END;;
  }

  dimension: daynum {
    type: number
    sql: ${TABLE}.daynum ;;
    html: <a href="http://www.google.com/search?q=site:espn.com+ncaa+men+basketball+{{team_game_season_facts.matchup._value | url_encode}}+{{allRecords.final_score._value | url_encode}}&btnI=1"> {{value}} </a>;;
  }

  dimension_group: game {
    type: time
    timeframes: [date,week,month]
    sql: ${TABLE}.game_date ;;
    html: <a href="http://www.google.com/search?q=site:espn.com+ncaa+men+basketball+{{team_game_season_facts.matchup._value | url_encode}}+{{allRecords.final_score._value | url_encode}}&btnI=1"> {{value}} </a>;;
  }


  dimension: result {
    type: string
    sql: ${TABLE}.result ;;
  }

  dimension: result_expanded {
    type: string
    sql: CASE  WHEN ${result} = 'W' THEN 'Winner' WHEN ${result}='L' THEN 'Loser' ELSE null END ;;
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
    type: string
    sql: MAX(${record}) ;;
  }

  dimension: final_record {
    type: string
    sql: CONCAT( STRING(${season_wins}),'-',STRING(${season_losses}) ) ;;
  }

  measure: max_final_record {
    type: string
    sql: MAX(${final_record}) ;;
  }

  dimension: pregame_record {
    type: string
    sql: CASE WHEN ${result} = 'W' THEN CONCAT( STRING(${sum_wins}-1),'-',STRING(${sum_losses}) )
      WHEN ${result} = 'L' THEN CONCAT( STRING(${sum_wins}-1),'-',STRING(${sum_losses}-1) ) END;;
  }

  measure: measure_pregame_record{
    type: string
    sql: MAX(${pregame_record}) ;;
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
