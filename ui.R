library(shiny)

shinyUI(fluidPage(
  titlePanel("Riffle-ito 555 Conductivity"),
  withMathJax(),

  tabsetPanel(
    tabPanel("Frequency vs. Resistance",
            sidebarLayout(
              sidebarPanel(
                numericInput("R_A", "Series Resistance (\\(R_A\\), k\\(\\Omega\\))", min = 0.001, max = 100, value = 3.3),
                numericInput("Cap", "Capacitor (\\(C\\), \\(\\mu\\)F)", min = 0.001, max = 1000, value = 0.1),
                hr(),
                h5('Move Red Point'),
                numericInput("R_B", "Water Resistance (\\(R_{water}\\), k\\(\\Omega\\))", min = 0.001, max = 100, value = 2.3)
              ),
              mainPanel(
                plotOutput("plotFreq"),
                verbatimTextOutput("textFreq"),
                helpText('$$f = \\frac{1}{0.7*(R_A + 2R_{water})*C}$$'),
                helpText('$$ f = \\text{Frequency Measured by 555 Timer }(Hz)$$'),
                helpText('$$ R_A = \\text{Circuit Series Resistor }(\\Omega) $$'),
                helpText('$$ R_{water} = \\text{Water Resistance }(\\Omega) $$'),
                helpText('$$ C = \\text{Circuit Capacitor }(F)$$'),
                p('Reference: ', a(href='http://publiclab.org/notes/donblair/05-28-2014/riffle-dev-fun-w-five-five-fives', "Riffle dev: 'Fun w/ Five-Five-Fives'"))
              )
            )
    ),
    tabPanel("Frequency vs. Conductivity",
             sidebarLayout(
               sidebarPanel(
                 numericInput("R_A_2", "Series Resistance (\\(R_A\\), k\\(\\Omega\\))", min = 0.001, max = 100, value = 3.3),
                 numericInput("Cap_2", "Capacitor (\\(C\\), \\(\\mu\\)F)", min = 0.001, max = 1000, value = 0.1),
                 numericInput("LA_2", "Length-Area Ratio (\\(l/A\\), 1/cm)", min = 0.00001, max = 10, value = 1),
                 hr(),
                 h5('Move Red Point'),
                 numericInput("S_2", "Water Conductivity (\\(S_{water}\\), \\(\\mu\\)S/cm)", min = 0.1, max = 10000, value = 1000)
               ),
               mainPanel(
                 plotOutput("plotFreq2"),
                 p('Blue points are measurements made by Don Blair. Data available at ', a(href='https://docs.google.com/spreadsheets/d/1VYbCg0TOsdpzL2XVZbKudoSGCnire0_Q3z77r4luqtA/edit', 'Google Sheet')),
                 verbatimTextOutput("textFreq2_1"),
                 verbatimTextOutput("textFreq2_2"),
                 helpText('$$R_{water} = \\frac{1}{S_{water}} \\frac{l}{A}$$'),
                 helpText('$$f = \\frac{1}{0.7*\\left(R_A + 2R_{water}\\right)*C}$$'),
                 helpText('$$f = \\frac{1}{0.7*\\left(R_A + \\frac{2}{S_{water}} \\left(\\frac{l}{A}\\right)\\right)*C}$$'),
                 helpText('$$ R_{water} = \\text{Water Resistance }(\\Omega) $$'),
                 helpText('$$ S_{water} = \\text{Water Conductivity }(\\mu S/cm) $$'),
                 helpText('$$ f = \\text{Frequency Measured by 555 Timer }(Hz) $$'),
                 helpText('$$ l = \\text{Distance between Electrodes }(cm) $$'),
                 helpText('$$ A = \\text{Surface Area of Electrodes }(cm^2) $$'),
                 helpText('$$ R_A = \\text{Circuit Series Resistor }(\\Omega) $$'),
                 helpText('$$ C = \\text{Circuit Capacitor }(F) $$'),
                 p('Reference: ', a(href='http://publiclab.org/notes/donblair/05-28-2014/riffle-dev-fun-w-five-five-fives', "Riffle dev: 'Fun w/ Five-Five-Fives'")),

                 p('Reference: ', a(href='http://en.wikipedia.org/wiki/Electrical_conductivity', "Electrical Conductivity"))
               )
             )
    ),
    tabPanel("Temperature Correction",
             sidebarLayout(
               sidebarPanel(
                 sliderInput("alpha", "Temp Coefficient (\\(\\alpha\\), 1/degC)", min = 0, max = 0.2, value = 0.05, step=0.01),
                 hr(),
                 h5('Move Red Point'),
                 numericInput("T", "Temperature (\\(T_{water}\\), degC)", min = 0, max = 50, value = 25)
               ),
               mainPanel(
                 plotOutput("plotTemp"),
                 verbatimTextOutput("textTemp"),
                 helpText('$$\\frac{S_{25}}{S_T} = \\frac{1}{1 + \\alpha(T-25)}$$'),
                 helpText('$$ S_{25} = \\text{Specific Conductivity @ 25 degC }(\\mu S/cm) $$'),
                 helpText('$$ S_{T} = \\text{Conductivity at Temperature } T ( \\mu S/cm) $$'),
                 helpText('$$ \\alpha = \\text{Temperature Coefficient }(1/degC)$$'),
                 helpText('$$ T = \\text{Water Temperature }(degC) $$'),
                 p('Reference: ', a(href="http://www.analyticexpert.com/2011/03/temperature-compensation-algorithms-for-conductivity/", "Temperature Compensation Algorithms for Conductivity"))
               )
             )
    )
  ),
  hr(),
  p('Developed by ', a(href="http://walkerjeff.com", "Jeff Walker"), " for the ", a(href="http://openwaterproject.io", "Open Water Project"))
))
