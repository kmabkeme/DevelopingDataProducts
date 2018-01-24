---
title       : Color Palette
subtitle    : Generate Exciting Color Combinations
author      : Kristin Abkemeier
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Familiar color combinations

National flags, standard business clothing, holiday themes, global brands and products, tacky interiors of marble and gilding...

<div style='text-align: left;'>
    <img width='180' src='World-Flag.jpg' />
    <img width='180' src='img_9758.jpg' />
    <img width='180' src='grinch-christmas-trees-artificial-tree-skirt-ideas-on-pinterestgrinch-decorations-1024x845.jpg' />
    <img width='180' src='Good-Fast-Food-Restaurant-Logos-65-For-Logos-Free-Download-with-Fast-Food-Restaurant-Logos.jpg' />
    <img width='200' src='2D9411AD00000578-3303819-image-a-1_1446653257605.jpg' />
</div>

<br /><br />
We've seen all of these color combinations a million times before.

We don't notice them any more.

---

## Analogous split-complementary colors

To select combinations of colors, we can:

- Rely on the tried-and-true formulas (but they are kind of boring), 
- Pick random colors (but they probably won't look so good),
- Use the analogous split complementary color scheme that artists use.

<div style='text-align: left; vertical-align: text-center;'>
    <table>
    <tr>
    <td>
    <img width='300' src='251f13dc4c70f84be2896c22b37ba521.png' />
    </td>
    <td>
    <img width='300' src='ColorWheel-SplitComp.jpg' />
    </td>
    <td>
    <img width='300' src='colored-glass-analogous-split-complements-color-schemes-ink-watercolor-chris-carter-artit-090912-web.jpg' />
    </td>
    </tr>
    <tr>
    <td>Analogous colors (yellow)</td>
    <td>+ Split Complementary colors (magenta and blue-violet)</td>
    <td>= Exciting and harmonious color palette</td>
    </tr>
    </table>
</div>

---

## How do we find the complement of a color in R?

Using the colourpicker widget from the colourpicker package, we select a color and get its value in hexadecimal. For example, #F21FD6 is a very bright pink, which I render in an R plot below, along with its calculated complement.
<img src="figure/fig1-1.png" title="plot of chunk fig1" alt="plot of chunk fig1" style="display: block; margin: auto;" />

- We find the complement for #F21FD6 by converting it from the RGB (for red-green-blue) color scheme used on computer monitors into an HSL (for hue-saturation-lightness) scheme, which maps the hue to the range 0 <= hue < 1. 
- Then we get the complementary hue, #1FF23B, by adding 0.5 to the value of the starting hue and converting back to RGB color. Look at the index.Rmd source file to see!

---

## The split complement and analogous colors in R

- If the complement of a hue is the hue + 0.5, then the split complement is offset from the complement by 0.08333 (1/12), so that is calculated as hue +/- 0.41667.
- Analogous colors form 1/3 of the color wheel that is adjacent to the selected color. So, to calculate those, I choose a hue from within a range of hue +/- 0.16667.
- I mix up the saturation a bit, for some variety, and limit the lightness to a fixed band so that we don't generate too many black or white swatches.
- Then I convert back to RGB colors, and plot out four color swatches: the original color, one split complement, and two analogous colors. Discover a new color combination!

<div style='vertical-align: text-top;'>
    <img width='180' src='93268945512cf7415681dd821a14db23.jpg' />
    <img width='300' src='split-complimentary-yellow-couch-purple-walls.jpg' />
    <img width='300' src='9111871_orig.jpg' />
    <img width='150' src='home-design-split-complementary-color-scheme-examples-wonderful-photo-concept-best-images-on-615x1076.jpg' />
</div>
