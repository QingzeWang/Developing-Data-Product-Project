library(shiny)
library(ggplot2)
library(dplyr)
library(quantmod)

shinyUI(pageWithSidebar(
    headerPanel("Stocks"),
    
    sidebarPanel(
        #Create check box for different stocks
        wellPanel(
            p(strong("Stocks")),
            checkboxInput(inputId = "stock_aapl",  label = "Apple (AAPL)",     value = TRUE),
            checkboxInput(inputId = "stock_nflx",  label = "Netflix (NFLX)",   value = FALSE),
            checkboxInput(inputId = "stock_gild",  label = "Gilead Sci. (GILD)",    value = TRUE)
        ), 
        
        #create a slider that indicates the price you are interested
        sliderInput('price', 'Price you are intersted at', value = 100, min = 80, max= 120, step = 5),
        
        #create a date range
        dateRangeInput(inputId = "daterange", label = "Date range",
                       start = Sys.Date() - 730, end = Sys.Date()),
        #add a interactive "go!" button 
        actionButton("goButton","Go!")
        ),
    
    
    #main panel that lists at most three output figures for the three stocks we input
    mainPanel(

        conditionalPanel(condition = "input.stock_aapl",
                         br(),
                         div(plotOutput(outputId = "plot_aapl"))),
        
        conditionalPanel(condition = "input.stock_nflx",
                         br(),
                         div(plotOutput(outputId = "plot_nflx"))),
        
        conditionalPanel(condition = "input.stock_gild",
                         br(),
                         plotOutput(outputId = "plot_gild"))
    )
))