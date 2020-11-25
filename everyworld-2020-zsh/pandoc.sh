#!/bin/bash

# removed background image

pandoc -t revealjs bash_talk.md -f markdown+pipe_tables --slide-level=3 -s -o index.html \
    -V theme=white \
    -V parallaxBackgroundSize="1920px 1080px" \
    -V parrallaxBackgroundHorizontal="0" \
    -V parrallaxBackgroundVertical="0"
