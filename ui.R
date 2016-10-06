library(dplyr)
library(ggvis)
library(shiny)

shinyUI(fluidPage(
  
  h3("College Admissions"),
  p("Explore the distribution of SAT scores in different colleges"),

  sidebarLayout(position=c("right"),
    sidebarPanel(width=2,
      selectInput(inputId = "n_year", 
                  label = "Academic Year",
                  choices = c("(All)", "2013", "2014"),
                  selected = "(All)"),
      
      selectInput(inputId = "n_college", 
                  label = "College",
                  choices = c("(All)", "Arts & Sciences", "Business", "Communication", "Education", "Engineering", "Music", "Public Affairs", "Public Health"),
                  selected = "(All)"),
      
      selectInput(inputId = "n_gender",
                  label = "Gender",
                  choices = c("(All)", "Men", "Women"),
                  selected = "(All)")
      ),
    mainPanel(
      uiOutput("plot"), 
      ggvisOutput("ggvis")
    )
  ),
  h6("Source: Tableau - Sample Regional Workbook - College Worksheet")
))



