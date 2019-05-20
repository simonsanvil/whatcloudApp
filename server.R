library(shiny)

if (!require(wordcloud)){
  install.packages('wordcloud')}
library(wordcloud)

shinyServer(function(input, output, session) {
  # Define a reactive expression for the document term matrix

  data <- reactive({
    validate(
      need(input$text != '', "Please introduce a file")
    )
  })

  terms <- reactive({
    # Change when the "update" button is pressed...

    input$goButton

    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        if(input$other == 'Yes'){getChat(input$text,T)}
         else{getChat(input$text,F)}
      })
    })
  })
  
  col <- reactive({
      #input$goButton
      input$background.color
  })
  
  observe({
  col <- col()
  output$plot <- renderPlot({
    data()
    v <- terms()
    v <- na.exclude(v)
    opt <- input$palette
    if(opt == 1){pal = brewer.pal(8, "Dark2")
    }else if(opt == 2){pal = brewer.pal(8,"Paired")
    }else if(opt == 3){pal = rev(rev(brewer.pal(8,'Greys'))[c(1,2,3,4)])
    }else if(opt == 4){pal = rev(rev(brewer.pal(8,'Blues'))[c(0,1,2,3,4,5)])
    }else if(opt == 5){pal = rev(rev(brewer.pal(8,'Oranges'))[c(0,1,2,3,4,5)])
    }else{ pal = brewer.pal(8,'Set3')
    }
    par(mar = rep(0, 4))
    set.seed(floor(runif(1, 1,301)))
    wordcloud(names(v), v, #scale=c(4,0.5),
                  min.freq = input$min.freq,
                  max.words=input$max.words,
                  colors=pal,
                  random.order = F,
                  rot.per = .3, main = 'title')
    if (input$name == 'Yes'){
        text(0.5,0.006,substr(input$text$name,0,nchar(input$text$name)-4),col = input$textCol)
        }
  },res = 90, bg = col) # #bg.col
  })
})



