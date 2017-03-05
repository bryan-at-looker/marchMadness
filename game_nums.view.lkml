view: game_nums {
  derived_table: {
    sql: SELECT game_num FROM ( SELECT row_number() OVER() as game_num, daynum FROM regularSeasonCompactResults LIMIT 70 )
      ;;
  }

  filter: team_1 {
    type: string
    suggest_dimension: team_game_season_facts.team_name
  }
  filter: team_2 {
    type: string
    suggest_dimension: team_game_season_facts.team_name
  }
  filter: season {
    type: string
    suggest_dimension: team_game_season_facts.season
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: game_num {
    type: number
    sql: ${TABLE}.game_num ;;
  }

  set: detail {
    fields: [game_num]
  }
}
