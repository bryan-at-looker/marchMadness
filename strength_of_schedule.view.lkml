view: strength_of_schedule {
  sql_table_name: marchMadness2017.strengthOfSchedule ;;

  dimension: d1_w_l {
    type: string
    sql: ${TABLE}.D1_W_L ;;
  }

  dimension: rk {
    type: number
    sql: ${TABLE}.RK ;;
  }

  dimension: rpi {
    type: number
    sql: ${TABLE}.RPI ;;
  }

  dimension: season {
    type: number
    sql: ${TABLE}.SEASON ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.SOURCE ;;
  }

  dimension: team {
    hidden: yes
    type: string
    sql: ${TABLE}.TEAM ;;
  }

  dimension: team_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.Team_ID ;;
  }

  dimension: team_name {
    type: string
    sql: ${TABLE}.Team_Name ;;
  }

  measure: strength_of_schedule_index  {
    type: max
    sql: ${rpi} ;;
    value_format_name: decimal_4
  }

  measure: count {
    type: count
    approximate_threshold: 100000
    drill_fields: [team_name, teams.team_id, teams.team_name]
  }
}
