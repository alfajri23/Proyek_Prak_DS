#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinycssloaders)
library(shinydashboard)

source("dataPrep.R")

# Define UI for application that draws a histogram
shinyUI(dashboardPage(

    # Application title
    dashboardHeader(title = "Analisis Sentimen Pada Tempat Wisata Disneyland"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Home", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("K-Means", tabName = "kmeans", icon = icon("poll")),
            menuItem("Wordcloud", tabName = "wdsh", icon = icon("poll")),
            menuItem("Topik", tabName = "topic",icon = icon("poll"))
        )
    ),
    
    dashboardBody(
        tags$style(HTML("
                    .box.box-solid.box-info>.box-header {
                    background:#000000
                    }
                    .box.box-solid.box-info{
                    border-color:#000000;
                    background:#ADD1FF
                    }
                    .btn{
                    width: 100%
                    }
                    .control-label h5{
                    color: white;
                    }
                    ")),
        tabItems(
            tabItem(
                tabName = "dashboard",
                fluidRow(
                    box(plotOutput("most", height = 500, width = 1250), width = 750),
                    
                ),
            ),
            tabItem(
                tabName = "kmeans",
                fluidRow(
                    box(plotOutput("kmeans", height = 750), width = 750),
                )
            ),
            tabItem(
                tabName = "wdsh",
                #hasil cloud
                fluidRow(
                    box(plotOutput("wordcloud", height = 750), width = 750),
                ),
            ),
            tabItem(
                tabName = "topic",
                fluidRow(
                    box(plotOutput("topic", height = 750), width = 750),
                ),
            )
        )
        
    )
))
