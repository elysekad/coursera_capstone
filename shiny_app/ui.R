#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Theme
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel(h3("Swiftkey Word Prediction App")),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    sidebarPanel(
      
      h5('Please enter text into the box below and choose the number of words you would like predicted:'),
      
      #text input where user can type prefix 
      textInput('prefix_input', 'Please enter your text below:', ''),
      
      sliderInput('n_words', 'Number of word predictions:', min=1, max=10, step=1, value=1)
      
      
      #input where user can choose the number of word predictions to return
    
      ),
    
    # Show a plot of the generated distribution
    mainPanel(
       tableOutput('word_predictions')
    )
  )
))
