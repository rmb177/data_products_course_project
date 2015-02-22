library(shiny)
library(ggplot2)

# Calculate the energy savings for each year adjusting for inflation
# over the time period entered by the user
calculateEnergySavings <- function(initialSavings, numYears, inflationRate) 
{
    savings <- numeric(numYears)
    savings[1] <- initialSavings
    for (i in 2:numYears) 
    {
        savings[i] <- savings[i - 1] * (1 + inflationRate / 100)
    }
    savings
}

# Return the cash flow for each year
#  Year 0 = rebate - costOfEquipment
#  Every other year = the annual energy savings
getAnnualCashFlows <- function(costOfEquipment, rebate, energySavings)
{
    c(rebate - costOfEquipment, energySavings)
}

getAnnualNetPresentValues <- function(discountRate, annualCashFlows, numYears)
{
    npValues <- numeric(numYears + 1)
    for (i in 0:numYears)
    {
        npValues[i + 1] <- annualCashFlows[i + 1] / (1 + (discountRate / 100))^i
    }
    npValues
}

# Calculate the cash flow for each year
shinyServer
(
    function(input, output) 
    {
        energySavings1 <- reactive({calculateEnergySavings(input$project1EnergSavings, input$numYears, input$inflationRate)})
        annualCashFlows1 <- reactive({getAnnualCashFlows(input$project1CostOfEquipment, input$project1Rebate, energySavings1())})
        npvValues1 <- reactive({getAnnualNetPresentValues(input$discountRate, annualCashFlows1(), input$numYears)})
        
        energySavings2 <- reactive({calculateEnergySavings(input$project2EnergSavings, input$numYears, input$inflationRate)})
        annualCashFlows2 <- reactive({getAnnualCashFlows(input$project2CostOfEquipment, input$project2Rebate, energySavings2())})
        npvValues2 <- reactive({getAnnualNetPresentValues(input$discountRate, annualCashFlows2(), input$numYears)})
        
        projects <- reactive({c(rep("Project 1", input$numYears + 1), rep("Project 2", input$numYears + 1))})
        years <- reactive({c(seq(0,input$numYears), seq(0,input$numYears))})
        cashFlows <- reactive({c(cumsum(annualCashFlows1()), cumsum(annualCashFlows2()))})
        npvs <- reactive({c(cumsum(npvValues1()), cumsum(npvValues2()))})
        df <- reactive({data.frame(projects=projects(), years=years(), cashFlows=cashFlows(), npvs=npvs())})
        output$test <- renderTable(df())
        
        output$cashFlows <- renderPlot(
        {
            cashFlowsPlot <- ggplot(df(), aes(x = years, y = cashFlows, fill=factor(projects))) + 
             geom_bar(stat = "identity", position=position_dodge()) +
             scale_y_continuous("Dollars") + 
             scale_x_continuous("End of Year", breaks=seq(0, input$numYears, 1)) +
             scale_fill_discrete(name ="Projects") +
             ggtitle("Cumulative Cash Flow")
            
            print(cashFlowsPlot)            
        })
        
        output$presentValue <- renderPlot(
        {
            npvPlot <- ggplot(df(), aes(x = years, y = npvs, fill=factor(projects))) + 
             geom_bar(stat = "identity", position=position_dodge()) +
             scale_y_continuous("Dollars") + 
             scale_x_continuous("End of Year", breaks=seq(0, input$numYears, 1)) +
             scale_fill_discrete(name ="Projects") +
             ggtitle("Cumulative Net Present Value")
          
            print(npvPlot)
        })
    }
)