view: team_game_season_facts {
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
        teams.espn_id as espn_id,
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
       AND ( {% condition game_by_game_comparison.team_1 %} teams.team {% endcondition %}  )
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
  }

  dimension_group: game {
    type: time
    timeframes: [date,week,month]
    sql: ${TABLE}.game_date ;;
#     html: <a href="http://www.google.com/search?btnI&q=ncaa+game+summary+{{team_game_season_facts.matchup._value | url_encode | replace:'-','+'}}+{{allRecords.final_score._value | | replace:'-','+'}}+site:espn.com"> {{value}} </a>;;
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

  dimension: espn_id {
    type: string
    sql: STRING(${TABLE}.espn_id) ;;
  }

  measure: espn_url_id {
    label: " "

    type: max
    sql: ${espn_id} ;;
    link: {
      label: "ESPN"
      url: "http://www.espn.com/mens-college-basketball/team/_/id/{{rendered_value}}/"
      icon_url: "http://a.espncdn.com/favicon.ico"
    }
    html: <a href="http://www.espn.com/mens-college-basketball/team/_/id/{{rendered_value}}/"> <img style="margin:0px auto;display:block;h:auto;w:100%" src="http://a.espncdn.com/combiner/i?img=/i/teamlogos/ncaa/500/{{rendered_value}}.png&h=150&w=150"/> <p style="font-size:160%;" align="center">{{team_game_season_facts.max_final_record._value}} </p>  </a> ;;
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
