#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
# I am using a gadget called colourpicker from the CRAN website that enables one to pick colors
# This was developed by Dean Attali in 2016 and may be downloaded at https://github.com/daattali/colourpicker
# or at https://cran.r-project.org/web/packages/colourpicker/index.html
library(colourpicker)

# Define UI for application that generates a collection of colors that would go together well
# based on the analogous split complementary system
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Exciting Color Combination Generator"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      # adding the new div tag to the sidebar            
      tags$div(class="header", checked=NA,
               tags$p("Pick a color by changing the RGB value or using the color picker..."),
      colourInput("col", "Select color", "purple"),
      tags$div(class="header", checked=NA,
               tags$p("...then we will generate some other colors that make an interesting combination. The color swatches are generated according to the "),
      tags$a(href="http://www.paintdrawpaint.com/2010/10/color-analogous-split-complementary.html", "analogous split complementary color scheme."))
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("plot")
    )
  )
))
