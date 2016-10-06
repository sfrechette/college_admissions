library(dplyr)
library(ggvis)
library(shiny)

sat_score = read.csv("data/TableauDataSet_Education.csv")
sat_score$Total.Score <- as.numeric(as.character(sub(",", "", sat_score$Total.Score)))
sat_score$Academic.Year <- as.numeric(as.character(sub(",", "", sat_score$Academic.Year)))

shinyServer(function(input, output) {
  data <- reactive ({
    if (input$n_college == "(All)" && input$n_gender == "(All)"  && input$n_year == "(All)"){
      by_college <- group_by (sat_score, College, Total.Score)
      college_score <- summarise(by_college , NumberOfStudents = n())
    } 
    else if (input$n_college == "(All)" && input$n_gender == "(All)" && input$n_year != "(All)"){
      by_college <- group_by (sat_score, College, Academic.Year, Total.Score)
      college_score <- summarise(by_college , NumberOfStudents = n())
      college_score <- filter(college_score, Academic.Year == input$n_year)
    } 
    else if (input$n_college == "(All)" && input$n_gender != "(All)" && input$n_year != "(All)"){
      by_college <- group_by (sat_score, College, Gender, Academic.Year, Total.Score)
      college_score <- summarise(by_college , NumberOfStudents = n())
      college_score <- filter(college_score, Gender == input$n_gender, Academic.Year == input$n_year)
    } 
    else if (input$n_college != "(All)" && input$n_gender != "(All)" && input$n_year != "(All)"){
      by_college <- group_by (sat_score, College, Gender, Academic.Year, Total.Score)
      college_score <- summarise(by_college , NumberOfStudents = n())
      college_score <- filter(college_score, College == input$n_college, Gender == input$n_gender, Academic.Year == input$n_year)
    } 
    else if (input$n_college != "(All)" && input$n_gender != "(All)" && input$n_year == "(All)"){
      by_college <- group_by (sat_score, College, Gender, Total.Score)
      college_score <- summarise(by_college , NumberOfStudents = n())
      college_score <- filter(college_score, College == input$n_college, Gender == input$n_gender)
    } 
    else if (input$n_college != "(All)" && input$n_gender == "(All)" && input$n_year == "(All)"){
      by_college <- group_by (sat_score, College, Total.Score)
      college_score <- summarise(by_college , NumberOfStudents = n())
      college_score <- filter(college_score, College == input$n_college)
    } 
    else if (input$n_college != "(All)" && input$n_gender == "(All)" && input$n_year != "(All)"){
      by_college <- group_by (sat_score, College, Academic.Year, Total.Score)
      college_score <- summarise(by_college , NumberOfStudents = n())
      college_score <- filter(college_score, College == input$n_college, Academic.Year == input$n_year)
    } 
    else if (input$n_college == "(All)" && input$n_gender != "(All)" && input$n_year == "(All)"){
      by_college <- group_by (sat_score, College, Gender, Total.Score)
      college_score <- summarise(by_college , NumberOfStudents = n())
      college_score <- filter(college_score, Gender == input$n_gender)
    }
  })
  
  college_tooltip <- function(x){
    with(sat_score[x$id, ], paste("<b>", "College of ", x$College, "</b><br>",
                                      "Total Score: ", "<b>", x$Total.Score, "</b><br>",
                                      "# number of Students: ", "<b>", x$NumberOfStudents, "</b><br>"))
  }

  data %>%
    ggvis(y=~NumberOfStudents, x=~Total.Score, stroke:="black", fill=~College) %>%
    layer_points() %>%
    add_axis("x", title="SAT Score") %>%
    add_axis("y", title="Number of Students") %>%
    add_tooltip(college_tooltip, "hover") %>%
    set_options(width=1000, height=700) %>%
    bind_shiny("ggvis", "plot")
  data
})

