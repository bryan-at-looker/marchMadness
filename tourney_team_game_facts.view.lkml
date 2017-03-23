view: tourney_team_game_facts {
  derived_table: {
    sql:
      SELECT
        game_by_game_comparison.game_num  AS game_num,
        COALESCE(CAST(SUM(allRecords.fgm ) AS FLOAT), 0) AS sum_fgm,
        COALESCE(CAST(SUM(allRecords.fga ) AS FLOAT), 0) AS sum_fga,
        COALESCE(CAST(SUM(allRecords.ast ) AS FLOAT), 0) AS sum_assists,
        COALESCE(CAST(SUM(allRecords.o_r ) AS FLOAT), 0) AS sum_rebounds_offensive,
        COALESCE(CAST(SUM(allRecords.dr ) AS FLOAT), 0) AS sum_rebounds_defensive,
        COALESCE(CAST(SUM(allRecords.fga3 ) AS FLOAT), 0) AS sum_fga3,
        COALESCE(CAST(SUM(allRecords.fgm3 ) AS FLOAT), 0) AS sum_fgm3,
        COALESCE(CAST(SUM(allRecords.t_o ) AS FLOAT), 0) AS sum_turn_overs,
        COUNT(allRecords.primary_key ) AS count_games,
        COALESCE(CAST(SUM(allRecords.dr + allRecords.dr ) AS FLOAT), 0) AS sum_rebounds
      FROM (SELECT game_num FROM ( SELECT row_number() OVER() as game_num, daynum FROM regularSeasonCompactResults LIMIT 70 )
            ) AS game_by_game_comparison
      INNER JOIN (SELECT
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

            FROM [fiery-celerity-147420:scratch2.LR_HJ0QU5WFHUQ74STQ25E5C_allRecords] AS allRecords
            LEFT JOIN marchMadness2017.new_teams  AS teams ON allRecords.team = teams.team_id
            LEFT JOIN marchMadness2017.new_teams  AS opponent ON allRecords.opponent = opponent.team_id
            LEFT JOIN marchMadness2017.seasons AS season_view ON allRecords.season = season_view.season
            WHERE ((STRING(allRecords.season)) = '2017')
             AND ( ((teams.team IS NOT NULL))  )
            ORDER BY teams.team, allRecords.season, allRecords.daynum
             ) AS team_game_season_facts ON game_by_game_comparison.game_num = team_game_season_facts.game_num
      LEFT JOIN [fiery-celerity-147420:scratch2.LR_HJ0QU5WFHUQ74STQ25E5C_allRecords] AS allRecords ON team_game_season_facts.primary_key = allRecords.primary_key
      LEFT JOIN marchMadness2017.new_teams  AS teams ON allRecords.team = teams.team_id

      WHERE
        teams.Seed is not null
      GROUP BY 1
      ORDER BY 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: game_num {
    type: number
    sql: ${TABLE}.game_num ;;
  }



  dimension: sum_fgm {
    type: number
    sql: ${TABLE}.sum_fgm ;;
  }

  measure: total_sum_fgm {
    type: sum
    sql: ${sum_fgm} ;;
  }

  dimension: sum_fga {
    type: number
    sql: ${TABLE}.sum_fga ;;
  }
  measure: total_sum_fga {
    type: sum
    sql: ${sum_fga} ;;
  }


  dimension: sum_assists {
    type: number
    sql: ${TABLE}.sum_assists ;;
  }
  measure: total_sum_assists {
    type: sum
    sql: ${sum_assists} ;;
  }


  dimension: sum_rebounds_offensive {
    type: number
    sql: ${TABLE}.sum_rebounds_offensive ;;
  }
  measure: total_sum_rebounds_offensive {
    type: sum
    sql: ${sum_rebounds_offensive} ;;
  }


  dimension: sum_rebounds_defensive {
    type: number
    sql: ${TABLE}.sum_rebounds_defensive ;;
  }
  measure: total_sum_rebounds_defensive {
    type: sum
    sql: ${sum_rebounds_defensive} ;;
  }


  dimension: sum_fga3 {
    type: number
    sql: ${TABLE}.sum_fga3 ;;
  }
  measure: total_sum_fga3 {
    type: sum
    sql: ${sum_fga3} ;;
  }


  dimension: sum_fgm3 {
    type: number
    sql: ${TABLE}.sum_fgm3 ;;
  }
  measure: total_sum_fgm3 {
    type: sum
    sql: ${sum_fgm3} ;;
  }


  dimension: sum_turn_overs {
    type: number
    sql: ${TABLE}.sum_turn_overs ;;
  }
  measure: total_sum_turn_overs {
    type: sum
    sql: ${sum_turn_overs} ;;
  }


  dimension: count_games {
    type: number
    sql: ${TABLE}.count_games ;;
  }
  measure: total_count_games {
    type: sum
    sql: ${count_games} ;;
  }


  dimension: sum_rebounds {
    type: number
    sql: ${TABLE}.sum_rebounds ;;
  }
  measure: total_sum_rebounds {
    type: sum
    sql: ${sum_rebounds} ;;
  }


  set: detail {
    fields: [
      game_num,
      sum_fgm,
      sum_fga,
      sum_assists,
      sum_rebounds_offensive,
      sum_rebounds_defensive,
      sum_fga3,
      sum_fgm3,
      sum_turn_overs,
      count_games,
      sum_rebounds
    ]
  }
}
