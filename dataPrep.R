library(tidyverse)
library(tidytext)
library(widyr)
library(stm)
library(e1071) #untuk naive bayes
library(caret) #untuk klasifikasi data
library(syuzhet)
library(tm)
library(dplyr)
library(wordcloud)
library(cluster)    # clustering algorithms
library(factoextra)

park_reviews <- read_csv("C:/Drive D/Kuliah/Sem 5/Praktikum Data Science/akhir/Annas/ProjectAkhirDS-master/DisneylandReviews.csv", show_col_types=FALSE) %>%
  rename_with(str_to_lower)
park_min <- park_reviews %>% head(100)

#hotel_reviews <- read_csv("C:/Drive D/Kuliah/Sem 5/Praktikum Data Science/akhir/Annas/ProjectAkhirDS-master/tripadvisor_hotel_reviews.csv", show_col_types=FALSE) %>%
  #rename_with(str_to_lower)
#hotel_min <- hotel_reviews %>% head(100)


park_words <- park_reviews %>%
  unnest_tokens(word, review_text) %>%
  anti_join(stop_words, by="word") %>%
  filter(str_detect(word, "[a-z]")) %>%
  count( word)

park_review_words <- park_reviews %>%
  mutate(park_id = row_number()) %>%
  unnest_tokens(word, review_text) %>%
  anti_join(stop_words, by = "word") %>%
  filter(!word %in% c("n't", "park")) %>%
  count(park_id, rating, word) %>%
  group_by(word)

review_matrix <- park_review_words %>%
  filter(n >= 5) %>%
  cast_sparse(park_id, word, n) 

topic_model_6 <- stm(review_matrix,
                     K=6,
                     verbose = TRUE,
                     init.type = "Spectral",
                     emtol = 5e-5)

user_review_words <- park_reviews %>%
  mutate(park_id = row_number()) %>%
  unnest_tokens(word, review_text) %>%
  anti_join(stop_words, by="word") %>%
  filter(str_detect(word, "[a-z]"),
         !word %in% c("n't", 'park')) %>%
  count(park_id,rating, word, sort=TRUE)

by_word <- user_review_words %>%
  group_by(word) %>%
  summarize(avg_rating = mean(rating),
            nb_reviews = n()) %>%
  arrange(desc(nb_reviews)) %>%
  filter(nb_reviews >= 500) %>%
  arrange(desc(avg_rating))

df<-park_reviews
set.seed(20)
df<-df[sample(nrow(df)),]
df<-df[sample(nrow(df)),]
corpus<-Corpus(VectorSource(df$review_text))
corpus.clean<-corpus%>%
  tm_map(content_transformer(tolower))%>%
  tm_map(removePunctuation)%>%
  tm_map(removeNumbers)%>%
  tm_map(removeWords,stopwords(kind="en"))%>%
  tm_map(stripWhitespace)

length <- nrow(df)
length_train <- as.integer(length*0.75)
df.train<-df[1:length_train,]
df.test<-df[length_train:length,]
corpus.clean.train<-corpus.clean[1:15368]
corpus.clean.test<-corpus.clean[15368:20491]

indexed <- by_word
indexed <- indexed %>% column_to_rownames(., var = "word")

