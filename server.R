#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
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

shinyServer(function(input, output) {
   
  #output$distPlot <- renderPlot({
  output$plot <- renderPlot({
      
      # We need to split out the RGB color into its red, green, and blue components. 
      allColor <- input$col
      rcolorHex <- substr(allColor, 2, 3)
      gcolorHex <- substr(allColor, 4, 5)
      bcolorHex <- substr(allColor, 6, 7)
      
      # The RGB colors are in hexadecimal, so we will need to convert the values from hex into decimal.
      rcolor <- strtoi(rcolorHex, 16)
      gcolor <- strtoi(gcolorHex, 16)
      bcolor <- strtoi(bcolorHex, 16)
      
      # Let's set a seed for how the other colors are generated
      set.seed(rcolor)
      
      # Let's normalize the values to 255, which is the maximum value for each color component
      rcolorNorm <- rcolor/255
      gcolorNorm <- gcolor/255 
      bcolorNorm <- bcolor/255
      
      # Now that we have our normalized decimal RGB values, we need to convert our color to the HSL scale
      # where H stands for Hue, S for Saturation, and L for Lightness. We need to have our values in
      # this scale so that we can calculate the range of analogous colors and the split complementary
      # colors that will go well with the selected color.
      
      # I am adapting the RGB to HSL conversion code from what I found written in PHP at serennu.com,
      # http://serennu.com/colour/rgbtohsl.php
      
      # which.min returns the index of the minimum value, not the actual minimum value
      rgb_vector <- c(rcolorNorm, gcolorNorm, bcolorNorm)
      var_min <- which.min(rgb_vector)
      value_min <- rgb_vector[var_min]
      var_max <- which.max(rgb_vector)
      value_max <- rgb_vector[var_max]
      # delta_max is the total range between max and min values
      delta_max <- value_max - value_min
      
      # And it looks like l, for lightness, is the midpoint between the max and the min values
      lightness <- (value_max + value_min) / 2
      
      # If there is no difference between the max and the min, then no hue or saturation
      # because equal amounts of red, green, and blue is just grayscale
      if (delta_max == 0)
      {
        hue <- 0
        saturation <- 0
      }
      else
      {
        if (lightness < 0.5)
        {
          saturation <- delta_max / (value_max + value_min)
        }
        else
        {
          saturation <- delta_max / (2 - value_max - value_min)
        };
        
        # I am adapting the RGB to HSL conversion code from what I found written in PHP at serennu.com,
        # http://serennu.com/colour/rgbtohsl.php.
        
        delta_r <- (((value_max - rcolorNorm) / 6) + (delta_max / 2)) / delta_max
        delta_g <- (((value_max - gcolorNorm) / 6) + (delta_max / 2)) / delta_max
        delta_b <- (((value_max - bcolorNorm) / 6) + (delta_max / 2)) / delta_max
        
        if (rcolorNorm == value_max)
        {
          hue <- delta_b - delta_g
        }
        else if (gcolorNorm == value_max)
        {
          hue <- (1 / 3) + delta_r - delta_b
        }
        else if (bcolorNorm  == value_max)
        {
          hue <- (2 / 3) + delta_g - delta_r
        }
        
        # The hue gets mapped to a square that goes from 0 to 1 in both dimensions, so if the
        # adjusted value falls outside of this box, map it back into the box.
        if (hue < 0)
        {
          hue <- hue + 1
        }
        
        if (hue > 1)
        {
          hue <- hue - 1
        }
      }
      
      # Now everything has been converted from RGB to HSL scale. Each of the HSL values (hue, saturation,
      # and lightness) is normalized to 1, so the values range between 0 and 1.
      # The analogous colors are those that span about 1/6 of the way around the color wheel on
      # on either side - so add 0.16667 and subtract 0.16667 (or randomly generate a number in that
      # range)
      
      # The split-complementary colors are on either side of the exact complement. We don't want
      # the exact complement, but rather an offset from the complementary color by about 1/12 of the 
      # way around, or 0.083333. Also, it is good to have the complementary color desaturated a bit.
      # Let's generate a number between 0 and 1 to decide on which side of the complement we land on.
      multiplier <- 1
      if (runif(1) > 0.5)
      {
        multiplier <- -1
      }
      
      # The split complement is not the exact complement, but rather it's off from the complement
      # by 0.08333, which means 0.5 - 0.08333 = 0.41667
      hueSplitComplement <- hue + 0.41667 * multiplier
      if (hueSplitComplement > 1)
      {
        hueSplitComplement <- hueSplitComplement - 1
      }
      
      # The analogous colors span 1/3 of the way around the circle of hues, meaning that it goes
      # 1/6 of the way on either side of the selected hue. Hence, we pick some colors from inside
      # this range. One color to the positive side of our selected hue...
      hueAnalogousRight <- hue + 0.16667 * runif(1) 
      if (hueAnalogousRight > 1)
      {
        hueAnalogousRight <- hueAnalogousRight - 1
      }
      
      #...and one color on the other side of our selected hue.
      hueAnalogousLeft <- hue - 0.16667 * runif(1) 
      if (hueAnalogousLeft < 0)
      {
        hueAnalogousLeft <- hueAnalogousLeft + 1
      }
      
      # Now we calculate the randomized saturation and lightness in addition to our hue by calling
      # colorCalcs(). We use rcolor, gcolor, and bcolor as seeds for setting the seeds for the random number 
      # generators in the function.
      colorsOut <- colorCalcs(saturation, lightness, hueSplitComplement, rcolor, gcolor)
      # Finally, we need to convert back into hexadecimal
      rgbSplitComplement <- rgb(round(colorsOut[1]), round(colorsOut[2]), round(colorsOut[3]), maxColorValue=255)
    
      colorsOut <- colorCalcs(saturation, lightness, hueAnalogousRight, gcolor, bcolor)
      # Finally, we need to convert back into hexadecimal
      rgbAnalogousRight <- rgb(round(colorsOut[1]), round(colorsOut[2]), round(colorsOut[3]), maxColorValue=255)
      
      colorsOut <- colorCalcs(saturation, lightness, hueAnalogousLeft, bcolor, rcolor)
      # Finally, we need to convert back into hexadecimal
      rgbAnalogousLeft <- rgb(round(colorsOut[1]), round(colorsOut[2]), round(colorsOut[3]), maxColorValue=255)
      
      # Now that we have our generated colors in RGB, we plot them in blocks of color next to our
      # original color swatch. We use the polygon() function to plot these shapes.
      yy<-c(0,0,1,1)
      xx<-c(0,1,1,0)
      xxAll<-c(0,4,4,0)
      plot(xxAll, yy, axes=FALSE, ann=FALSE, type='n')
      polygon(xx, yy, col=input$col, border=input$col)
      
      xx2<-c(0,1,1,0) + 1
      polygon(xx2, yy, col=rgbSplitComplement, border=rgbSplitComplement)
      
      xx2<-c(0,1,1,0) + 2
      polygon(xx2, yy, col=rgbAnalogousRight, border=rgbAnalogousRight)
      
      xx2<-c(0,1,1,0) + 3
      polygon(xx2, yy, col=rgbAnalogousLeft, border=rgbAnalogousLeft)
      
      # We also write a list of the RGB colors that we actually generated here.
      mtext(paste("Color: ", input$col, " Split complement: ", rgbSplitComplement, " Analogous color 1: ", rgbAnalogousRight, " Analogous color 2: ", rgbAnalogousLeft),side=1,line=1)
  })
  
})

# I adapted the color adjustment code from what I found written in PHP at serennu.com,
# http://serennu.com/colour/rgbtohsl.php. However, at that website, it only showed how to find the
# complementary color. It also kept the saturation at the same level as the input color. Here, I
# am randomizing the saturation and lightness somewhat so that we don't get a lot of black or white
# swatches returned.
colorCalcs <- function(saturation, lightness, vhue, randomizeS, randomizeL)
{
  # Let's have the option of randomizing the saturation and lightness of the generated colors,
  # just to give more variety to our output
    set.seed(randomizeS)
    saturation <- runif(1)
    # Let's not allow the saturation to get too low or too high
    if (saturation < 0.5)
    {
      saturation <- 0.5
    }
    
    set.seed(randomizeL)
    lightness <- runif(1)
    
    if (lightness < 0.3)
    {
      lightness <- 0.3
    }
    else if (lightness > 0.85)
    {
      lightness <-0.85
    }
  
  if (saturation == 0)
  {
    r <- lightness * 255
    g <- lightness * 255
    b <- lightness * 255
  }
  else
  {
    if (lightness < 0.5)
    {
      var2 <- lightness * (1 + saturation)
    }
    else
    {
      var2 <- (lightness + saturation) - (saturation * lightness)
    }
    
    var1 <- 2 * lightness - var2;
    r <- 255 * hue_2_rgb(var1,var2,vhue + (1 / 3))
    g <- 255 * hue_2_rgb(var1,var2,vhue)
    b <- 255 * hue_2_rgb(var1,var2,vhue - (1 / 3))
  }

  c(r, g, b)
}

# I adapted the hue to RGB conversion code from what I found written in PHP at serennu.com,
# http://serennu.com/colour/rgbtohsl.php.

# Function to convert hue to RGB, called from above
hue_2_rgb <- function(v1, v2, vhue)
{
  if (vhue < 0)
  {
    vhue <- vhue + 1
  }
  
  if (vhue > 1)
  {
    vhue <- vhue - 1
  }
  
  if ((6 * vhue) < 1)
  {
    v1 + (v2 - v1) * 6 * vhue
  }
  else if ((2 * vhue) < 1)
  {
    v2
  }
  else if ((3 * vhue) < 2)
  {
    v1 + (v2 - v1) * ((2 / 3 - vhue) * 6)
  }
  else
  {
    v1
  }
}