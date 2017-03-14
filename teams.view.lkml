view: teams {
  sql_table_name: marchMadness2017.new_teams ;;

  dimension: espn_id {
    type: number
    sql: ${TABLE}.espn_id ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: rpi {
    type: number
    sql: ${TABLE}.RPI ;;
  }

  dimension: rpi_rk {
    type: number
    sql: ${TABLE}.rpi_rk ;;
  }

  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
  }

  dimension: seed {
    type: string
    sql: ${TABLE}.Seed ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: team {
    type: string
    sql: ${TABLE}.team ;;
  }

  dimension: in_tourney {
    type: yesno
    sql: ${seed} is not null ;;
  }

  dimension: team_alt2 {
    type: string
    sql: ${TABLE}.team_alt2 ;;
  }

  dimension: team_alternate {
    type: string
    sql: ${TABLE}.team_alternate ;;
  }

  dimension: team_id {
    type: string
    # hidden: yes
    sql: ${TABLE}.team_id ;;
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

  measure: count {
    type: count
    approximate_threshold: 100000
    drill_fields: [teams.team_id, teams.team_name]
  }

  measure: strength_of_schedule_index  {
    type: max
    sql: ${rpi} ;;
    value_format_name: decimal_4
  }
}
