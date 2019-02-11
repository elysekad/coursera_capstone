# 
# data <- unlist(train_list)
# 
# getNgramFreqs <- function(ng, data) {
#   dfm_data <- dfm(data, ngrams=ng, what = "fasterword", verbose = FALSE)
#   ngram_freq <- as.data.frame(docfreq(dfm_data))
#   setDT(ngram_freq, keep.rownames = TRUE)
#   colnames(ngram_freq) <- c('ngram', 'freq')
#   ngram_freq <- ngram_freq[order(-ngram_freq$freq),]
#   return(ngram_freq)
# }
# 
# unigrams <- getNgramFreqs(1, data)
# bigrams <- getNgramFreqs(2, data)
# trigrams <- getNgramFreqs(3, data)

#####################################################################################

word_prediction <- function(string, gamma_2=.5, gamma_3=.5, n=1) {
  
  string <- as.character(string)
  string <- gsub('[[:punct:] ]+',' ',string)
  string <- str_trim(string, side=c('both'))
  string <- str_squish(string)
  string <- tail(str_split(string, ' ')[[1]], 2)
  
#creating bigram and unigram prefixes
  if (length(string)>1) {
    big_prefix <- paste(string, collapse = '_')
    unig_prefix <- strsplit(string, ' ')[[2]]
  } else {
    unig_prefix <- string[[1]]
    big_prefix <- paste0('*_', string[[1]])
  }
  
  #find observed trigram backoff probabilities, alpha_3, and unobserved trigram tails
    regex <- paste0('^', big_prefix, '_')
    obs_trigs <- trigrams[grepl(regex, trigrams$ngram), ]
    denom <- as.numeric(bigrams[bigrams$ngram==big_prefix, 'freq'])
    obs_trig_probs <- mutate(obs_trigs, freq=(freq - gamma_3) / denom)
    names(obs_trig_probs) <- c("ngram", "prob")
    alpha_3 <- 1 - sum(obs_trig_probs$prob)
    obs_trig_tails <- str_split_fixed(obs_trigs$ngram, '_', 3)[ ,3]
    unobs_trigs_tails<- unigrams[!(unigrams$ngram %in% obs_trig_tails), ]
    
  #find alpha_2 , observed bigrams and unobserved bigrams frequency counts
    regex <- paste0("^", unig_prefix, "_")
    bigsThatStartWithUnig <- bigrams[grepl(regex, bigrams$ngram),]
    denom=as.numeric(unigrams[unigrams$ngram==unig_prefix, 'freq'])
    alpha_2 <- 1 - (sum(bigsThatStartWithUnig$freq - gamma_2) / denom)
    
    BO_bigrams <- paste0(unig_prefix, '_', unobs_trigs_tails$ngram)
    obs_BO_bigrams <- bigrams[bigrams$ngram %in% BO_bigrams, ]
    unobs_BO_bigrams <- BO_bigrams[!(BO_bigrams %in% bigrams$ngram)]
    unobs_BO_bigrams <- unigrams[unigrams$ngram %in% str_split_fixed(unobs_BO_bigrams, '_', 2)[ ,2], ]
    #getting probabilities for observed and unobserved bigrams
    denom=as.numeric(unigrams[unigrams$ngram==unig_prefix, 'freq'])
    
    obs_BO_bigrams_probs <- mutate(obs_BO_bigrams, freq=(freq - gamma_2) / denom)
    colnames(obs_BO_bigrams_probs) <- c('ngram', 'prob')
    
    denom <- sum(unobs_BO_bigrams$freq)
    unobs_BO_bigrams_probs <- mutate(unobs_BO_bigrams, freq=alpha_2 * (unobs_BO_bigrams$freq / denom))
    colnames(unobs_BO_bigrams_probs) <- c('ngram', 'prob')
    
    #getting probabilities for observed and unobserved bigrams
    denom=as.numeric(unigrams[unigrams$ngram==unig_prefix, 'freq'])
    obs_BO_bigrams_probs <- mutate(obs_BO_bigrams, freq=(freq - gamma_2) / denom)
    colnames(obs_BO_bigrams_probs) <- c('ngram', 'prob')
    w_2 <- str_split_fixed(big_prefix, '_', 2)[, 1]
    if (nrow(obs_BO_bigrams_probs)>0) {
    obs_BO_bigrams_probs$ngram = paste0(w_2, '_', obs_BO_bigrams_probs$ngram)}
    
    denom <- sum(unobs_BO_bigrams$freq)
    unobs_BO_bigrams_probs <- mutate(unobs_BO_bigrams, freq=alpha_2 * (unobs_BO_bigrams$freq / denom))
    colnames(unobs_BO_bigrams_probs) <- c('ngram', 'prob')
    unobs_BO_bigrams_probs$ngram = paste0(big_prefix, '_', unobs_BO_bigrams_probs$ngram)
    
    BO_bigrams <- rbind(obs_BO_bigrams_probs, unobs_BO_bigrams_probs)
    
    #getting unobserved trigram probabilities and finding final prediction
    denom <- sum(BO_bigrams$prob)
    unobs_trigs_prob <- mutate(BO_bigrams, prob=alpha_3 * (BO_bigrams$prob/denom))
    all_probs <- rbind(obs_trig_probs, unobs_trigs_prob)
    result=all_probs[1:n, ]
    result$ngram = str_split_fixed(result$ngram, '_', 3)[ ,3]
    result=cbind(rownames(result), result)
    colnames(result) <- c('rank', 'word', 'prob')
    
    return(result)
}

    