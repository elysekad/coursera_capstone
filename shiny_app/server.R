library(shiny)
library(stringr)
library(quanteda)
library(data.table)
library(dplyr)




#importing, unigram, bigram and trigram data
source("word_prediction_model.R")
unigrams <<- readRDS('unigrams.Rda')
bigrams <<- readRDS('bigrams.Rda')
trigrams <<- readRDS('trigrams.Rda')

#req(input$datasetName)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  
  output$word_predictions <- renderTable({
    
    req(input$prefix_input)
    
    #generating table of word predictions
    word_prediction(input$prefix_input, gamma_2 = .5, gamma_3 = .5, input$n_words)
    
    
  })
  
})
