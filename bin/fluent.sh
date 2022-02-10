#!/bin/bash

cd "$(dirname "$(spicetify -c)")/Themes/Fluent"
spicetify config extensions fluent.js
spicetify config current_theme Fluent color_scheme dark
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
spicetify apply
