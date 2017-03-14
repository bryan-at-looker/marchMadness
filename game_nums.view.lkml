view: game_nums {
  derived_table: {
    sql: SELECT game_num FROM ( SELECT row_number() OVER() as game_num, daynum FROM regularSeasonCompactResults LIMIT 70 )
      ;;
  }

  filter: team_1 {
    label: "Select Team"
    type: string
    suggest_explore: suggest_teams
    suggest_dimension: suggest_teams.team
    full_suggestions: yes
  }
  filter: season {
    type: string
    suggestions: ["2014","2015","2016", "2017"]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: game_num {
    primary_key: yes
    type: number
    sql: ${TABLE}.game_num ;;
  }

  set: detail {
    fields: [game_num]
  }
}
