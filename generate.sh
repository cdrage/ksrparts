#!/bin/bash

# Replace function
sed-replace() {
  find $3 -type f -name "*.*" -not -path "*/.git/*" -not -path "*/vendor/*" -print0 | xargs -0 sed -i "s|$1|$2|g"
}

INDEX_TITLE="Race Track Sculptures"
GALLERY_TITLE="Gallery"
KEYCHAINS_TITLE="Keychains"

#########
# INDEX #
#########
rm index.html
cat templates/header.html.template \
  templates/index.html.template \
  templates/footer.html.template \
  >> index.html
sed-replace %TITLE% "$INDEX_TITLE" index.html

#############
# KEYCHAINS #
#############
cat templates/header.html.template \
  templates/keychains.html.template \
  templates/footer.html.template \
  >> keychains.html
sed-replace %TITLE% "$KEYCHAINS_TITLE" keychains.html


######################
# GALLERY GENERATION #
######################
rm gallery.html

# Insert header
cat templates/header.html.template >> gallery.html

# Generate template
cat templates/gallery1.html.template >> gallery.html
i=1
for f in assets/images/tracks/*.png; do
  name=$(echo $f | cut -f 1 -d '.')
  base="$(basename -- "$name")"
  echo $name
  nospace=$( printf "%s\n" "$f" | sed 's/ /%20/g' )

  cat >> gallery.html << EOL
              <div class="col-md-2">
                <div class="table-left">
                  <img class="bike-fluid" src="$nospace">
                  <div class="track">$base</div>
                </div>
              </div>
EOL
  i=$((i+1))
  if (( $i == 7 )); then
    i=1
    echo '</div><div class="row trackrow text-center">' >> gallery.html
  fi
done
cat templates/gallery2.html.template >> gallery.html

# Insert footer
cat templates/footer.html.template >> gallery.html

perl -p -i -e "s/\r//g" gallery.html

# VARIABLE REPLACEMENTS
sed-replace %TITLE% "$GALLERY_TITLE" gallery.html
