if (!require(tm)){
    install.packages('tm')}
library(tm)

if (!require(wordcloud)){
    install.packages('wordcloud')}
library(wordcloud)

if (!require(memoise)){
    install.packages('memoise')}
library(memoise)

if (!require(dplyr)){
  install.packages('dplyr')}
require(dplyr)

if (!require(textclean)){
  install.packages('textclean')}
require(textclean)

if (!require(stringr)){
  install.packages('stringr')}
require(stringr)

#options(encoding = 'UTF-8')
# Using "memoise" to automatically cache the results
getChat <- function(f,type) {
  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  
  cat("\n", file = f$datapath, append = TRUE)
  if(type == T){
      tryCatch(text <- readLines(f$datapath,encoding = "UTF-8"), finally = text <-  enc2utf8(readLines(f$datapath,encoding = "ISC")))
      }else{try(text <-  enc2utf8(readLines(f$datapath,encoding = "ISC")))}
  text <- replace_non_ascii(text)
  text <- add_comma_space(text)
  text <- replace_email(text, replacement = '')
  text <- replace_url(text, replacement = '')
  
  
  len = length(text)
  
  if(type == T){reg <- ".*?:\\s(.*)"}else{reg <- c(' ')}
  txtdf = character(0)
  
  if(type == T){
      for(i in 1:len){
          m <- str_match(text[i], reg)
          txtdf <- c(txtdf, m[2])
      }
  }else{for(i in 1:len){txtdf[i] <- c(text[i])}}
  txtdf <- as.data.frame(txtdf)
  colnames(txtdf) <- 'chat'
  txtdf <- na.omit(txtdf)
  
  myCorpus = Corpus(VectorSource(txtdf$chat))
  
  suppressWarnings({
    myCorpus <- tm_map(myCorpus, removePunctuation)
    myCorpus <- tm_map(myCorpus, removeWords, stopwords('spanish'))
    myCorpus <- tm_map(myCorpus, removeWords, stopwords('english'))
    myCorpus <- tm_map(myCorpus, removeWords, c("media", "omitted",'this','deleted','message','voice','missed','call','llamada','perdida','voz','Missed','video'))
    myCorpus <- tm_map(myCorpus, function(x) removeWords(x,c('media','que')))
    myCorpus <- tm_map(myCorpus, content_transformer(tolower))
    myCorpus <- tm_map(myCorpus, removeNumbers)
    myCorpus <- tm_map(myCorpus, removeWords,
                      c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but",'dy','cent','si'))
    })
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1,wordLengths=c(0,Inf)))
  
  #txt = as.matrix(myDTM)
  
  freq_terms <- findFreqTerms(myDTM, 4)
  if(length(freq_terms)>0){
    
    txt.m <- as.matrix(myDTM[freq_terms,])
    # Create a dataframe with each word and it's frequency:
    txt <- as.matrix(txt.m)
  }else{txt <- as.matrix(myDTM)}
  
  txt = sort(rowSums(txt), decreasing = TRUE)
  
}

