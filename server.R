#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$kmeans <- renderPlot({
        k2 <- kmeans(indexed, centers = 2)
        fviz_cluster(k2, data = indexed) + ggtitle(paste(" K = ",2))

    })
    
    output$silhoutte <- renderPlot({
        fviz_nbclust(indexed, kmeans, method = "silhouette")+ ggtitle("Recommending K Cluster")
    })
    
    output$most <- renderPlot({
        by_word %>%
            top_n(100, -avg_rating) %>%
            ggplot(aes(nb_reviews, avg_rating)) +
            geom_point(aes(color=avg_rating), show.legend=FALSE) +
            scale_colour_gradient(low="white", high="red") +
            geom_text(aes(label=word), vjust=1, hjust=1, check_overlap=TRUE) +
            theme_dark() +
            theme(text=element_text(size=20)) +
            scale_x_log10() +
            labs(title= "Kata review buruk",
                 subtitle=paste(100," kata bermakna negatif"))
        
    })
    output$wordcloud <- renderPlot({
        wordcloud(corpus.clean,min.freq = 4,max.words=100,random.order=F,colors=brewer.pal(8,"Dark2"))
        
    })
    
    output$topic <- renderPlot({
        tidy(topic_model_6) %>%
            group_by(topic) %>%
            top_n(12 , beta) %>%
            mutate(term = reorder_within(term, beta, topic)) %>%
            ggplot(aes(beta, term, fill = factor(topic))) +
            geom_col(show.legend=FALSE) +
            scale_y_reordered() +
            theme_dark() +
            theme(text=element_text(size=20)) +
            facet_wrap(~ topic, scales = "free_y")
    })

})
