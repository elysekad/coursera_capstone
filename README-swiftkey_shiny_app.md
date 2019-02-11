# Swiftkey Word Prediction App 

This shiny app predicts the next word given a word or phrase input. The prediction model uses [Katz's back-off model with Good-Turing smoothing](https://en.wikipedia.org/wiki/Katz%27s_back-off_model) to calculate the  probabilities for each word. The user can choose how many word predictions to return (up to 10 words). After a word or phrase is input into the text box, the app returns the word predictions with probabilities. The text that was used to create the unigram, bigram and trigram datasets were randomly sampled from twitter, news, and blog text data. Fifty thousand documents were randomly sampled from each text source. The dataset can be downloaded [here](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip).    

## Getting Started

### File descriptions

Shiny app scripts:
* ui.R - ui script for shiny app
* server.R - server script for shiny app
* word_prediction_model.R - the app calls this script to calculate the prediction probabilities after input is entered

Data:
* unigrams.Rda - unique unigrams from text sample with frequency counts 
* unigrams.Rda - unique bigrams from text sample with frequency counts
* trigrams.Rda - unique trigrams from text sample with frequency counts

Preprocessing:
* capstone_text_cleaning.Rmd - script that sampled and cleaned the text as well as split into unigram, bigram and trigram data

### Downloading

The app and data files need to be saved in the same folder in order for the app to run. 

![Alt text](/screenshot/app_example.PNG?raw=true)
