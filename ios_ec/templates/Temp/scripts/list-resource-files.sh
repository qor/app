#!/usr/bin/env bash
find . -type f \(                \
      -name "*.png"              \
   -o -name "*.xib"              \
   -o -name "*.storyboard"       \
   -o -name "*.json"             \
\)
