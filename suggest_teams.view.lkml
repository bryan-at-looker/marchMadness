view: suggest_teams {
  derived_table: {
    sql:
    SELECT team_id, team, region, seed FROM marchMadness2017.new_teams
WHERE seed is not null
Group by 1,2,3,4
    ;;
  }
  dimension: team {
    type:string
    sql: ${TABLE}.team ;;
  }
  dimension: region {
    type:string
    sql: ${TABLE}.region ;;
  }
  dimension: seed {
    type:string
    sql: ${TABLE}.seed ;;
  }

}
