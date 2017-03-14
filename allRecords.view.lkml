view: allRecords {
  derived_table: {
    sql:
    SELECT CONCAT( STRING(season) , "_" ,  game_type , "_",
        STRING(daynum)  , "_" , STRING(team) ) as primary_key,
        result, game_type, season, daynum, STRING(team) as team, score, STRING(opponent) as opponent, opponent_score, wloc, numot, fgm, fga, fgm3, fga3, ftm, fta, o_r, dr, ast, t_o, stl, blk, pf
      FROM
      ( SELECT
        "W" as result, "Regular Season" as game_type, season as season, daynum as daynum, wteam as team, wscore as score, lteam as opponent, lscore as opponent_score, wloc as wloc, numot as numot, wfgm as fgm, wfga as fga, wfgm3 as fgm3, wfga3 as fga3, wftm as ftm, wfta as fta, wor as o_r, wdr as dr, wast as ast, wto as t_o, wstl as stl, wblk as blk, wpf as pf, null as game_num
        FROM marchMadness2017.regularSeasonDetailedResults),
      ( SELECT
        "L" as result, "Regular Season" as game_type, season as season, daynum as daynum, lteam as team, lscore as score, wteam as opponent, wscore as opponent_score, wloc as wloc, numot as numot, lfgm as fgm, lfga as fga, lfgm3 as fgm3, lfga3 as fga3, lftm as ftm, lfta as fta, lor as o_r, ldr as dr, last as ast, lto as t_o, lstl as stl, lblk as blk, lpf as pf, null as game_num
        FROM marchMadness2017.regularSeasonDetailedResults),
      ( SELECT
        "W" as result, "NCAA Tournament" as game_type, season as season, daynum as daynum, wteam as team, wscore as score, lteam as opponent, lscore as opponent_score, wloc as wloc, numot as numot, wfgm as fgm, wfga as fga, wfgm3 as fgm3, wfga3 as fga3, wftm as ftm, wfta as fta, wor as o_r, wdr as dr, wast as ast, wto as t_o, wstl as stl, wblk as blk, wpf as pf, null as game_num
        FROM marchMadness2017.tourneyDetailedResults),
      ( SELECT
        "L" as result, "NCAA Tournament" as game_type, season as season, daynum as daynum, lteam as team, lscore as score, wteam as opponent, wscore as opponent_score, wloc as wloc, numot as numot, lfgm as fgm, lfga as fga, lfgm3 as fgm3, lfga3 as fga3, lftm as ftm, lfta as fta, lor as o_r, ldr as dr, last as ast, lto as t_o, lstl as stl, lblk as blk, lpf as pf, null as game_num
        FROM marchMadness2017.tourneyDetailedResults),
      ( SELECT
        "W" as result, "Regular Season" as game_type, season2017.season as season, season2017.daynum as daynum, INTEGER(t.team_id) as team, season2017.wscore as score, INTEGER(o.team_id) as opponent, season2017.lscore as opponent_score, season2017.wloc as wloc, season2017.numot as numot, season2017.wfgm as fgm, season2017.wfga as fga, season2017.wfgm3 as fgm3, season2017.wfga3 as fga3, season2017.wftm as ftm, season2017.wfta as fta, season2017.wor as o_r, season2017.wdr as dr, season2017.wast as ast, season2017.wto as t_o, season2017.wstl as stl, season2017.wblk as blk, season2017.wpf as pf, season2017.game_num as game_num
        FROM marchMadness2017.season2017 as season2017
        INNER JOIN marchMadness2017.new_teams as t ON t.espn_id = season2017.wteam
        INNER JOIN marchMadness2017.new_teams as o ON o.espn_id = season2017.lteam),
      ( SELECT
        "L" as result, "Regular Season" as game_type, season2017.season as season, season2017.daynum as daynum, INTEGER(t.team_id) as team, season2017.lscore as score, INTEGER(o.team_id) as opponent, season2017.wscore as opponent_score, season2017.wloc as wloc, season2017.numot as numot, season2017.lfgm as fgm, season2017.lfga as fga, season2017.lfgm3 as fgm3, season2017.lfga3 as fga3, season2017.lftm as ftm, season2017.lfta as fta, season2017.lor as o_r, season2017.ldr as dr, season2017.last as ast, season2017.lto as t_o, season2017.lstl as stl, season2017.lblk as blk, season2017.lpf as pf, season2017.game_num as game_num
        FROM marchMadness2017.season2017 as season2017
        INNER JOIN marchMadness2017.new_teams as t ON t.espn_id = season2017.lteam
        INNER JOIN marchMadness2017.new_teams as o ON o.espn_id = season2017.wteam
        )
       ;;
    persist_for: "96 hours"
    #indexes: ["team","opponent"]
  }


  measure: count {
    group_label: "Standings"
    type: count
    drill_fields: [detail*]
  }

  dimension: game_num {
    sql: ${TABLE}.game_num ;;
    type: number
  }

  dimension: primary_key {
    primary_key: yes
    type: string
    sql: ${TABLE}.primary_key ;;
#     sql: CONCAT( STRING(${season}) , "_" ,  ${game_type} , "_"
#     , STRING(${daynum})  , "_" , STRING(${team}) ) ;;
  }

  dimension: result {
    type: string
    sql: ${TABLE}.result ;;
  }
  dimension: game_type {
    type: string
    sql: ${TABLE}.game_type ;;
  }
  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
    value_format: "0000"
  }

  dimension: daynum {
    hidden: no
    type: number
    sql: ${TABLE}.daynum ;;
  }

  dimension: team {
    type: string
    sql: ${TABLE}.team ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.score ;;
  }

  dimension: opponent {
    type: string
    sql: ${TABLE}.opponent ;;
  }

  dimension: final_score {
    type: string
    sql: CASE WHEN ${result} = 'W' THEN CONCAT ( STRING(${score}), '-', STRING(${opponent_score}) )
              WHEN ${result} = 'L' THEN CONCAT ( STRING(${opponent_score}), '-', STRING(${score}) )
              ELSE null END;;
  }

  dimension: opponent_score {
    type: number
    sql: ${TABLE}.opponent_score ;;
  }

  dimension: wloc {
    hidden: yes
    type: string
    sql: ${TABLE}.wloc ;;
    sql: CASE WHEN ${TABLE}.result="L"
          THEN ( CASE
            WHEN ${TABLE}.wloc="H" THEN "A"
            WHEN ${TABLE}.wloc="A" THEN "H"
            WHEN ${TABLE}.wloc="N" THEN "N"
            ELSE "Unknown"
            END )
          ELSE ${TABLE}.wloc END;;
  }
  dimension: game_location {
    type: string
    group_label: "Game Data"
    sql: CASE WHEN ${wloc}="H" THEN "Home"
                      WHEN ${wloc}="A" THEN "Away"
                      WHEN ${wloc}="N" THEN "Neutral"
                      ELSE "Unknown" END;;
  }

  measure: overtime_periods {
    type: sum
    sql: ${TABLE}.numot ;;
  }

  dimension: fgm {
    group_label: "Game Data"
    hidden: yes
    type: number
    sql: ${TABLE}.fgm ;;
  }
  measure: sum_fgm {
    label: "Field Goals Made"
    group_label: "Game Data"
    type: sum
    sql: ${fgm} ;;
    value_format_name: decimal_0
  }

  dimension: fga {
    group_label: "Game Data"
    hidden: yes
    type: number
    sql: ${TABLE}.fga ;;
  }

  measure: sum_fga {
    label: "Field Goals Attempted"
    group_label: "Game Data"
    type: sum
    sql: ${fga} ;;
    value_format_name: decimal_0
  }

  dimension: fgm3 {
    group_label: "Game Data"
    hidden: yes
    type: number
    sql: ${TABLE}.fgm3 ;;
  }

  measure: sum_fgm3 {
    label: "Three Pointers Made"
    group_label: "Game Data"
    type: sum
    sql: ${fgm3} ;;
    value_format_name: decimal_0
  }

  dimension: fga3 {
    hidden: yes
    group_label: "Game Data"
    type: number
    sql: ${TABLE}.fga3 ;;
  }
  measure: sum_fga3 {
    group_label: "Game Data"
    label: "Three Pointers Attempted"
    type: sum
    sql: ${fga3} ;;
    value_format_name: decimal_0
  }

  dimension: ftm {
    group_label: "Game Data"
    type: number
    sql: ${TABLE}.ftm ;;
  }

  dimension: fta {
    group_label: "Game Data"
    type: number
    sql: ${TABLE}.fta ;;
  }

  measure: rebounds_offensive {
    group_label: "Game Data"
    type: sum
    sql: ${TABLE}.o_r ;;
  }

  measure: rebounds_defensive {
    group_label: "Game Data"
    type: sum
    sql: ${TABLE}.dr ;;
  }

  measure: rebounds {
    group_label: "Game Data"
    type: sum
    sql: ${TABLE}.dr + ${TABLE}.dr ;;
  }

  measure: assists {
    group_label: "Game Data"
    type: sum
    sql: ${TABLE}.ast ;;
    value_format_name: decimal_0
  }
  measure: assists_per_game {
    group_label: "Stats"
    type: average
    sql: ${TABLE}.ast ;;
    value_format_name: decimal_1
  }

  measure: turn_overs {
    group_label: "Game Data"
    type: sum
    sql: ${TABLE}.t_o ;;
  }
  measure: turn_overs_per_game {
    group_label: "Stats"
    type: average
    sql: ${TABLE}.t_o ;;
    value_format_name: decimal_1
  }

  dimension: stl {
    group_label: "Game Data"
    type: number
    sql: ${TABLE}.stl ;;
  }

  dimension: blk {
    group_label: "Game Data"
    type: number
    sql: ${TABLE}.blk ;;
  }

  dimension: pf {
    group_label: "Game Data"
    type: number
    sql: ${TABLE}.pf ;;
  }

  measure: count_wins {
    group_label: "Standings"
    hidden: no
    type: count
    filters: {
      field: result
      value: "W"
    }
    drill_fields: [detail*]
  }
  measure: count_losses {
    group_label: "Standings"
    hidden: no
    type: count
    filters: {
      field: result
      value: "L"
    }
    drill_fields: [detail*]
  }
  measure: win_percentage {
    group_label: "Standings"
    sql: ${count_wins} / ${count} ;;
    type: number
    value_format_name: percent_2
  }
  dimension: point_difference {
    group_label: "Stats"
    type: number
    sql: ${score} - ${opponent_score}  ;;
    value_format_name: decimal_0
  }
  measure: average_point_difference {
    group_label: "Stats"
    type: average
    sql: ${point_difference} ;;
    value_format_name: decimal_2
  }
  measure: field_goal_percentage {
    group_label: "Stats"
    type: number
    sql: ${sum_fgm}/${sum_fga} ;;
    value_format_name: percent_2
  }
  measure: 3pt_field_goal_percentage {
    group_label: "Stats"
    type: number
    sql: ${sum_fgm3}/${sum_fga3} ;;
    value_format_name: percent_2
  }
  measure: points_per_game {
    group_label: "Stats"
    type: average
    sql: ${score} ;;
    value_format_name: decimal_1
    drill_fields: [detail*]
  }
  measure: points_allowed_per_game {
    group_label: "Stats"
    type: average
    sql: ${opponent_score} ;;
    value_format_name: decimal_1
  }

  set: detail {
    fields: [
      result,
      season,
      daynum,
      seasons.game_date_date,
      team,
      teams.name,
      score,
      opponent,
      opponent_score,
      wloc,
      overtime_periods,
      fgm,
      fga,
      fgm3,
      fga3,
      ftm,
      fta,
      rebounds_offensive,
      rebounds_defensive,
      assists,
      turn_overs,
      stl,
      blk,
      pf
    ]
  }
}
