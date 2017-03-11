view: filters {
  filter: team_1 {
    label: "Select Team"
    type: string
    suggest_dimension: teams.team_name
    full_suggestions: yes
  }
  filter: season {
    type: string
    suggestions: ["2014","2015","2016"]
  }
}
