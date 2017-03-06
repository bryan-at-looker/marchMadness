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
