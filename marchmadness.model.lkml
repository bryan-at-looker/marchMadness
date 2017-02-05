connection: "zz_bq_test"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

#explore: regular_season_compact_results {}

explore: regularRecords {
  join: teams {
    from: teams
    view_label: "Teams"
    type: left_outer
    sql_on: ${regularRecords.team} = ${teams.team_id}  ;;
    relationship: many_to_one
  }
  join: opponent {
    from: teams
    view_label: "Opponents"
    type: left_outer
    sql_on: ${regularRecords.opponent} = ${opponent.team_id}  ;;
    relationship: many_to_one
  }
}

#explore: seasons {}

#explore: teams {}

#explore: tourney_compact_results {}

explore: tourneyRecords {
  join: teams {
    from: teams
    view_label: "Teams"
    type: left_outer
    sql_on: ${tourneyRecords.team} = ${teams.team_id}  ;;
    relationship: many_to_one
  }
  join: opponent {
    from: teams
    view_label: "Opponents"
    type: left_outer
    sql_on: ${tourneyRecords.opponent} = ${opponent.team_id}  ;;
    relationship: many_to_one
  }
}

#explore: tourney_seeds {}

#explore: tourney_slots {}
