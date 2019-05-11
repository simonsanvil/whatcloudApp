library(shiny)
require('colourpicker')


shinyUI(
  fluidPage(
    
    # App title ----
    titlePanel("WhatCloud: Whatsapp Word Cloud Generator:"),
    # tags$style(type="text/css",
    #            ".shiny-output-error { visibility: hidden; }",
    #            ".shiny-output-error:before { visibility: hidden; }"
    # ),
    # 
    # Sidebar layout with input and output definitions ----
    
    mainPanel(
        
        # Output: wordcloud ----
        plotOutput("plot",width = "660px", height="660px")
    ),
    
    sidebarLayout(
      
      # Sidebar panel for inputs ----
      sidebarPanel(
        
        # Input: Select a file ----
        fileInput("text", "Choose .TXT File", multiple = FALSE),
        
        div("Instructions on how to download your whatsapp chats as a *.TXT file can be found at the bottom of this page. None of the data you upload to this website will be collected. Everything is done on the client-side.", style = "color:grey"),
        
        # Horizontal line ----
        tags$hr(),
        
        
        radioButtons("other", "Is the file a chat?",
                     c("Yes", "No"), inline = T),
        
        # Horizontal line ----
        tags$hr(),
        
        # Input: Checkbox if file has header ----
        sliderInput('min.freq','Minimum Frequency:',
                    min = 1, max = 50, value = 5),
        
        sliderInput('max.words','Maximum Number of Words:',
                    min = 1, max = 700, value = 250),
        
        # Horizontal line ----
        tags$hr(),
        
        radioButtons("name", "Display name of the file:",
                     c("Yes", "No"), inline = T),
        
        radioButtons("textCol","Color of the text",
                     c('White',"Black"), inline = T),
        
        
        tags$hr(),
        
        # Input: Select background color ----
        colourInput('background.color','Select Background Color','black'),
        
        
        radioButtons("palette", "Color Palette",
                     c(1,2,3,4,5,6), inline = T),
                     
        # Horizontal line ----
        tags$hr(),
        
        #Go button
        actionButton("goButton", "Go!"),
        
        # Horizontal line ----
        tags$hr(),
        #Go button
        p("This app was created by Simon S. Viloria on april of 2019."),
        p("Code is available on: github.com/simonsanvil/whatcloudApp")
      ),
      
      sidebarPanel(
          
          width = 10,
          
          h3('How to obtain your whatsapp chats as a .txt file?'),
          
          tags$ul(
            h4('On Android:'),
                tags$ol(
                    tags$li('Open the whatsapp conversation you would like to have visualized.'),
                    tags$li('Tap the options button (icon with the 3 dots) sittuated at the top right of your chat.'),
                    tags$li('Select "More".'),
                    tags$li('Select "Export Chat".'),
                    tags$li('Select "Without Media".'),
                    tags$li('Send chat to your email and download to your device/personal computer.'),
                    tags$li('Upload to this website.')
                ),
            h4('On Iphone/IOS:'),
                tags$ol(
                  tags$li('Open the WhatsApp conversation you would like to have visualized'),
                  tags$li('Tap on the contact name or group subject in the navigation bar.'),
                  tags$li('Scroll to the bottom and tap on "Export Chat".'),
                  tags$li('Select "Without Media".'),
                  tags$li('Select "Mail".'),
                  tags$li('Enter your email and download to your device/personal computer.'),
                  tags$li('Upload to this website.')
                )
          )
      )
      
    )
  )
)
