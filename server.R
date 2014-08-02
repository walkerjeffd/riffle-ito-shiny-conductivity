library(shiny)
library(ggplot2)
theme_set(theme_bw())

obs <- read.csv('data.csv')

shinyServer(function(input, output) {
  freq555 <- function(R_A, R_B, C) {
    1/(0.7*(R_A + 2*R_B)*C)
  }

  output$plotFreq <- renderPlot({
    R_A <- input$R_A*1e3
    R_B <- input$R_B*1e3
    C <- input$Cap*1e-6

    R_B_seq <- seq(1, 100)*1e2
    f_seq <- freq555(R_A, R_B_seq, C)

    f_pnt <- freq555(R_A, R_B, C)

    output$textFreq <- renderText(paste0('f(R_water = ', format(R_B, digits=3), ' ohm) = ', format(f_pnt, digits=3), ' Hz'))

    ggplot(data.frame(R_B=R_B_seq, f=f_seq), aes(R_B, f)) +
      geom_hline(yint=0, alpha=0) +
      geom_line() +
      geom_point(aes(R_B, f), data=data.frame(R_B=R_B, f=f_pnt), size=4, color='red') +
      ylim(0, 5000) +
      labs(x="Water Resistance (ohm)", y="555 Timer Frequency (Hz)")
  },  width=600, height=400)

  output$plotFreq2 <- renderPlot({
    R_A <- input$R_A_2*1e3 # kilo-ohm -> ohm
    C <- input$Cap_2*1e-6  # uFarad -> Farad
    LA <- input$LA_2       # L/A -> 1/cm

    S <- input$S_2 # uS/cm
    R <- 1/(S*1e-6) * LA # ohm

    S_seq <- seq(1, 2000) # uS/cm
    R_seq <- 1/(S_seq*1e-6) * LA
    f_seq <- freq555(R_A, R_seq, C)

    f_pnt <- freq555(R_A, R, C)

    output$textFreq2_1 <- renderText(paste0(
      'R_water(S_water = ', format(S, digits=3), ' uS/cm) = ', format(R, digits=3), ' ohm', '\n')
    )

    output$textFreq2_2 <- renderText(paste0(
      'f(S_water = ', format(S, digits=3), ' uS/cm) = ', format(f_pnt, digits=3), ' Hz')
    )

    ggplot(data.frame(S=S_seq, f=f_seq), aes(S, f)) +
      geom_hline(yint=0, alpha=0) +
      geom_line() +
      geom_point(aes(S, f), data=data.frame(S=S, f=f_pnt), size=4, color='red') +
      geom_point(aes(S, f), data=obs, color='steelblue') +
      ylim(0, 5000) +
      labs(x="Water Conductivity (uS/cm)", y="555 Timer Frequency (Hz)")
  }, width=600, height=400)

  output$plotTemp <- renderPlot({
    alpha <- input$alpha
    Temp <- input$T

    T_seq <- seq(10, 35)
    S_ratio <- 1/(1 + alpha*(T_seq-25))
    S_pnt <-  1/(1 + alpha*(Temp-25))


    output$textTemp <- renderText(paste0(
      'S_25 / S_T (T = ', format(Temp, digits=3), ' degC) = ', format(S_pnt, digits=3))
    )

    ggplot(data.frame(S=S_ratio, T=T_seq), aes(T, S)) +
      geom_line() +
      geom_point(aes(T, S), data=data.frame(S=S_pnt, T=Temp), size=4, color='red') +
      ylim(0, 4) +
      labs(x="Water Temperature, T (degC)", y=expression(paste(S[25]/S[T])))
  }, width=600, height=400)
})
