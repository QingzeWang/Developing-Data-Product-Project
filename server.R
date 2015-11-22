library(shiny)
library(ggplot2)
library(quantmod)
library(dplyr)
if (!require(quantmod) & !require(ggplot2) &!require(dplyr)) {
    stop("This app requires the quantmod, ggplot2 and dplyr packages. Please install them!")
}

# Download data for a stock if needed, and return the data
require_symbol <- function(symbol, envir = parent.frame()) {
    if (is.null(envir[[symbol]])) {
        envir[[symbol]] <- getSymbols(symbol, auto.assign = FALSE)
    }
    
    envir[[symbol]]
}

shinyServer(function(input, output) {
    
    # load and process the data
    symbol_env <- new.env()
    
    data.load <- function(symbol) {
        data.symbol <- as.data.frame(require_symbol(symbol,symbol_env))
        data.symbol <- mutate(data.symbol,date = as.Date(rownames(data.symbol)))
        #Find data between the inputed date range
        start <- input$daterange
        start[1]
        good <- data.symbol$date<start[2] & data.symbol$date>start[1]
        data.symbol <- data.symbol[good,]
        data.symbol
   }

    #Create output for stocks I selected: AAPL, NFLX and GILD 
    output$plot_aapl <- renderPlot({
        input$goButton
        isolate({
        data.aapl <- data.load("AAPL");
        g <- ggplot(data.aapl, aes(y = AAPL.Adjusted, x = date));
        g <- g+geom_line(colour = "gold",size = 1);
        g <- g + xlab("") +ylab("Price of APPLE($)") + ggtitle("Stock price of Apple");
        price <- input$price;
        isolate(g <- g+ geom_hline(yintercept = price, color = "black",lintype = "dashed"));
        print(g)})
    })

    
    output$plot_nflx <- renderPlot({
        input$goButton
        isolate({
        data.nflx <- data.load("NFLX");
        g <- ggplot(data.nflx, aes(y = NFLX.Adjusted, x = date));
        g <- g+geom_line(colour = "gold",size = 1);
        g <- g + xlab("") +ylab("Price of Netflix($)") + ggtitle("Stock price of Netflix");
        price <- input$price;
        g <- g + geom_hline(yintercept = price, color = "black",lintype = "dashed");
        print(g)})
    })
    output$plot_gild <- renderPlot({
        input$goButton
        isolate({
        data.gild <- data.load("GILD");
        g <- ggplot(data.gild, aes(y = GILD.Adjusted, x = date));
        g <- g+geom_line(colour = "gold",size = 1);
        g <- g + xlab("") +ylab("Price of Gilead Science($)") + ggtitle("Stock price of Gilead");
        price <- input$price;
        isolate(g <- g +geom_hline(yintercept = price, color = "black",lintype = "dashed"));
        print(g)})
    })
})