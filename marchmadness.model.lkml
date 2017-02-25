connection: "zz_bq_test"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

#explore: regular_season_compact_results {}

explore: allRecords {
  join: teams {
    from: teams
    view_label: "Teams"
    type: left_outer
    sql_on: ${allRecords.team} = ${teams.team_id}  ;;
    relationship: many_to_one
  }
  join: opponent {
    from: teams
    view_label: "Opponents"
    type: left_outer
    sql_on: ${allRecords.opponent} = ${opponent.team_id}  ;;
    relationship: many_to_one
  }
  join: seasons {
    view_label: "Allrecords"
    type: left_outer
    relationship: many_to_one
    sql_on: ${allRecords.season} = ${seasons.season} ;;
    fields: [seasons.game_date_date]
  }
}
explore: a_test {}

# explore: seasons {
#   join: allRecords {
#     type: left_outer
#     sql_on: ${seasons.season}=${allRecords.season} ;;
#     relationship: one_to_many
#   }
# }

#explore: teams {}
#
# #explore: tourney_compact_results {}
#
# explore: tourneyRecords {
#   join: teams {
#     from: teams
#     view_label: "Teams"
#     type: left_outer
#     sql_on: ${tourneyRecords.team} = ${teams.team_id}  ;;
#     relationship: many_to_one
#   }
#   join: opponent {
#     from: teams
#     view_label: "Opponents"
#     type: left_outer
#     sql_on: ${tourneyRecords.opponent} = ${opponent.team_id}  ;;
#     relationship: many_to_one
#   }
# }

#explore: tourney_seeds {}

#explore: tourney_slots {}
