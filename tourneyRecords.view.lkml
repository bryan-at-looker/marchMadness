view: tourneyRecords {
  derived_table: {
    sql: SELECT result, season, daynum, team, score, opponent, opponent_score, wloc, numot, fgm, fga, fgm3, fga3, ftm, fta, o_r, dr, ast, t_o, stl, blk, pf
      FROM
      ( SELECT
        "W" as result, season as season, daynum as daynum, wteam as team, wscore as score, lteam as opponent, lscore as opponent_score, wloc as wloc, numot as numot, wfgm as fgm, wfga as fga, wfgm3 as fgm3, wfga3 as fga3, wftm as ftm, wfta as fta, wor as o_r, wdr as dr, wast as ast, wto as t_o, wstl as stl, wblk as blk, wpf as pf
        FROM marchMadness2017.tourneyDetailedResults),
      ( SELECT
        "L" as result, season as season, daynum as daynum, lteam as team, lscore as score, wteam as opponent, wscore as opponent_score, wloc as wloc, numot as numot, lfgm as fgm, lfga as fga, lfgm3 as fgm3, lfga3 as fga3, lftm as ftm, lfta as fta, lor as o_r, ldr as dr, last as ast, lto as t_o, lstl as stl, lblk as blk, lpf as pf
        FROM marchMadness2017.tourneyDetailedResults)
       ;;
      persist_for: "12 hour"
      #indexes: ["team","opponent"]
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: result {
    type: string
    sql: ${TABLE}.result ;;
  }

  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
    value_format: "0000"
  }

  dimension: daynum {
    type: number
    sql: ${TABLE}.daynum ;;
  }

  dimension: team {
    type: number
    sql: ${TABLE}.team ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.score ;;
  }

  dimension: opponent {
    type: number
    sql: ${TABLE}.opponent ;;
  }

  dimension: opponent_score {
    type: number
    sql: ${TABLE}.opponent_score ;;
  }

  dimension: wloc {
    type: string
    sql: ${TABLE}.wloc ;;
  }

  dimension: numot {
    type: number
    sql: ${TABLE}.numot ;;
  }

  dimension: fgm {
    type: number
    sql: ${TABLE}.fgm ;;
  }

  dimension: fga {
    type: number
    sql: ${TABLE}.fga ;;
  }

  dimension: fgm3 {
    type: number
    sql: ${TABLE}.fgm3 ;;
  }

  dimension: fga3 {
    type: number
    sql: ${TABLE}.fga3 ;;
  }

  dimension: ftm {
    type: number
    sql: ${TABLE}.ftm ;;
  }

  dimension: fta {
    type: number
    sql: ${TABLE}.fta ;;
  }

  dimension: o_r {
    type: number
    sql: ${TABLE}.o_r ;;
  }

  dimension: dr {
    type: number
    sql: ${TABLE}.dr ;;
  }

  dimension: ast {
    type: number
    sql: ${TABLE}.ast ;;
  }

  dimension: t_o {
    type: number
    sql: ${TABLE}.t_o ;;
  }

  dimension: stl {
    type: number
    sql: ${TABLE}.stl ;;
  }

  dimension: blk {
    type: number
    sql: ${TABLE}.blk ;;
  }

  dimension: pf {
    type: number
    sql: ${TABLE}.pf ;;
  }

  measure: count_wins {
    hidden: no
    type: count
    filters: {
      field: result
      value: "W"
    }
    drill_fields: [detail*]
  }
  measure: count_losses {
    hidden: no
    type: count
    filters: {
      field: result
      value: "L"
    }
    drill_fields: [detail*]
  }
  measure: win_percentage {
    sql: ${count_wins} / ${count} ;;
    type: number
    value_format_name: percent_2
  }
  measure: last_appearance {
    type: max
    sql: ${season} ;;
    value_format: "0000"
  }

  set: detail {
    fields: [
      result,
      season,
      daynum,
      team,
      score,
      opponent,
      opponent_score,
      wloc,
      numot,
      fgm,
      fga,
      fgm3,
      fga3,
      ftm,
      fta,
      o_r,
      dr,
      ast,
      t_o,
      stl,
      blk,
      pf
    ]
  }
}
