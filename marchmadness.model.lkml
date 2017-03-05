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
  join: team_game_season_facts {
    type: left_outer
    relationship: one_to_one
    sql_on: ${allRecords.primary_key} = ${team_game_season_facts.primary_key} ;;
  }
}
explore: team_1_facts2 {
  from: team_game_season_facts2
  always_filter: {
    filters: {
      field: game_nums.team_1
      value: "Kansas"
    }
    filters: {
      field: game_nums.team_2
      value: "Duke"
    }
    filters: {
      field: game_nums.season
      value: "2016"
    }
  }
  sql_always_where: ${team_1_facts2.result} = 'W' ;;
  join: game_nums {
    sql_on: ${game_nums.game_num} = ${team_1_facts2.game_num}  ;;
    relationship: one_to_many
    type: full_outer_each
  }
  join: team_2_facts {
    from: team_game_season_facts2
    sql_on: ${team_1_facts2.opponent} = ${team_2_facts.team_id}
      AND ${team_2_facts.daynum} = ${team_1_facts2.daynum} AND ${team_1_facts2.season} = ${team_2_facts.season}  ;;
    relationship: one_to_one
    type: left_outer
  }
}

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
