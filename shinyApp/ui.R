library(shiny)

shinyUI(navbarPage
(
    tags$head
    (
        tags$style(
            HTML
            ("
                 .col-sm-4
                 {
                     padding-left: 2em;
                 }
     
                 .form-control 
                 {
                     width: 6em;
                 }
     
                 label
                 {
                     font-size: 10px;
                 }
             "))
    ),    
    
    tabPanel("Energy Efficiency Project Comparison Tool",
        fluidRow(
            column
            (
                width=4,            
                fluidRow
                (
                    numericInput('numYears', 'Number of Years', 5, min=2, max=10, step=1),
                    numericInput('discountRate', 'Discount Rate', 10, min=1, max=100, step=.1),
                    numericInput('inflationRate', 'Inflation Rate', 3, min= 1, max=100, step=.1)
                ),
                      
                fluidRow
                (
                    column
                    (
                        width=6,
                        h4("Project 1"),
                        numericInput('project1CostOfEquipment', 'Cost of Equipment', 5000, min=1, max=1000000, step=10),
                        numericInput('project1Rebate', 'Rebate/Incentive', 500, min=1, max=1000000, step=10),
                        numericInput('project1EnergSavings', 'Energy Savings (Year 1)', 2000, max=1000000, step=10)
                    ),
                                      
                    column
                    (
                        width=6,
                        h4("Project 2"),
                        numericInput('project2CostOfEquipment', 'Cost of Equipment', 12500, min=1, max=1000000, step=10),
                        numericInput('project2Rebate', 'Rebate/Incentive', 600, min=1, max=1000000, step=10),
                        numericInput('project2EnergSavings', 'Energy Savings (Year 1)', 4000, max=1000000, step=10)
                    )
                )
            ),
                              
            column
            (
                width=8,
                plotOutput("cashFlows"),
                plotOutput("presentValue")
            )
        )
    ),
    
    tabPanel("Instructions",
        p("The Energy Efficiency Project Comparison Tool allows you to compare two potential energy efficiency projects to determine which project
          presents a better financial opportunity. The tool calculates both the cash flow and Net Present Value for
          each project. The cash flow metric gives you an idea of how each project will affect the amount of 
          cash available to you or your business. Net Present Value gives you an idea of cash flows over time when
          adjusting for inflation and considering other potential investment opportunities.
          
          To use the tool enter values for the following fields:"),
        
        HTML("<ul><li>Number of Years: The expected lifetime of the project.</li>
                  <li>Discount Rate: The rate of return you could expect from other potential investment opportunities (e.g. investing in the stock market).</li>
                  <li>Inflation Rate: The expected inflation rate over the lifetime of the project.</li>
             </ul>"),
        
        p("For each individual project, enter values for the following fields:"),
        
        HTML("<ul><li>Cost of Equipment: The cost of the equipment installed.</li>
                  <li>Rebate/Incentive: The incentive received from your utility for installing the equipment.</li>
                  <li>Energy Savings: The expected savings on your utility bill in the first year of equipment use.</li>
              </ul>"),
        
        HTML('<p>Code for this application can be found on <a href="http://github.com/rmb177/data_products_course_project">GitHub</a>.')
    )
))