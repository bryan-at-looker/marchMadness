view: tourney_detailed_results {
  sql_table_name: marchMadness2017.tourneyDetailedResults ;;

  dimension: daynum {
    type: number
    sql: ${TABLE}.daynum ;;
  }

  dimension: last {
    type: number
    sql: ${TABLE}.last ;;
  }

  dimension: lblk {
    type: number
    sql: ${TABLE}.lblk ;;
  }

  dimension: ldr {
    type: number
    sql: ${TABLE}.ldr ;;
  }

  dimension: lfga {
    type: number
    sql: ${TABLE}.lfga ;;
  }

  dimension: lfga3 {
    type: number
    sql: ${TABLE}.lfga3 ;;
  }

  dimension: lfgm {
    type: number
    sql: ${TABLE}.lfgm ;;
  }

  dimension: lfgm3 {
    type: number
    sql: ${TABLE}.lfgm3 ;;
  }

  dimension: lfta {
    type: number
    sql: ${TABLE}.lfta ;;
  }

  dimension: lftm {
    type: number
    sql: ${TABLE}.lftm ;;
  }

  dimension: lor {
    type: number
    sql: ${TABLE}.lor ;;
  }

  dimension: lpf {
    type: number
    sql: ${TABLE}.lpf ;;
  }

  dimension: lscore {
    type: number
    sql: ${TABLE}.lscore ;;
  }

  dimension: lstl {
    type: number
    sql: ${TABLE}.lstl ;;
  }

  dimension: lteam {
    type: number
    sql: ${TABLE}.lteam ;;
  }

  dimension: lto {
    type: number
    sql: ${TABLE}.lto ;;
  }

  dimension: numot {
    type: number
    sql: ${TABLE}.numot ;;
  }

  dimension: season {
    type: number
    sql: ${TABLE}.season ;;
  }

  dimension: wast {
    type: number
    sql: ${TABLE}.wast ;;
  }

  dimension: wblk {
    type: number
    sql: ${TABLE}.wblk ;;
  }

  dimension: wdr {
    type: number
    sql: ${TABLE}.wdr ;;
  }

  dimension: wfga {
    type: number
    sql: ${TABLE}.wfga ;;
  }

  dimension: wfga3 {
    type: number
    sql: ${TABLE}.wfga3 ;;
  }

  dimension: wfgm {
    type: number
    sql: ${TABLE}.wfgm ;;
  }

  dimension: wfgm3 {
    type: number
    sql: ${TABLE}.wfgm3 ;;
  }

  dimension: wfta {
    type: number
    sql: ${TABLE}.wfta ;;
  }

  dimension: wftm {
    type: number
    sql: ${TABLE}.wftm ;;
  }

  dimension: wloc {
    type: string
    sql: ${TABLE}.wloc ;;
  }

  dimension: wor {
    type: number
    sql: ${TABLE}.wor ;;
  }

  dimension: wpf {
    type: number
    sql: ${TABLE}.wpf ;;
  }

  dimension: wscore {
    type: number
    sql: ${TABLE}.wscore ;;
  }

  dimension: wstl {
    type: number
    sql: ${TABLE}.wstl ;;
  }

  dimension: wteam {
    type: number
    sql: ${TABLE}.wteam ;;
  }

  dimension: wto {
    type: number
    sql: ${TABLE}.wto ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
