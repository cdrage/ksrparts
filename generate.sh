#!/bin/bash

# Replace function
sed-replace() {
  find $3 -type f -name "*.*" -not -path "*/.git/*" -not -path "*/vendor/*" -print0 | xargs -0 sed -i "s|$1|$2|g"
}

INDEX_TITLE="Race Track Sculptures"
GALLERY_TITLE="Gallery"
KEYCHAINS_TITLE="Keychains"
TRACKMAPS_ORDER_LINK="https://forms.gle/Zmidy3HAFgYoa4Vd9"
LAPTIMERS_ORDER_LINK="https://forms.gle/EfyEvYZq5Va6bMiQ8"

#########
# INDEX #
#########
rm index.html
cat templates/header.html.template \
  templates/index.html.template \
  templates/footer.html.template \
  >> index.html
sed-replace %TITLE% "$INDEX_TITLE" index.html
sed-replace %TRACKMAPS_ORDER_LINK% "$TRACKMAPS_ORDER_LINK" index.html
sed-replace %LAPTIMERS_ORDER_LINK% "$LAPTIMERS_ORDER_LINK" index.html

#############
# LAPTIMERS #
#############
rm laptimers.html
cat templates/header.html.template \
  templates/laptimers.html.template \
  templates/footer.html.template \
  >> laptimers.html
sed-replace %TITLE% "$INDEX_TITLE" laptimers.html
sed-replace %LAPTIMERS_ORDER_LINK% "$LAPTIMERS_ORDER_LINK" laptimers.html

######################
# TRACKMAPS GENERATION #
######################
rm trackmaps.html

# Insert header
cat templates/header.html.template >> trackmaps.html

# Generate template
cat templates/trackmaps1.html.template >> trackmaps.html
i=1
for f in assets/images/tracks/*.png; do
  name=$(echo $f | cut -f 1 -d '.')
  base="$(basename -- "$name")"
  echo $name
  nospace=$( printf "%s\n" "$f" | sed 's/ /%20/g' )

  cat >> trackmaps.html << EOL
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
    echo '</div><div class="row trackrow text-center">' >> trackmaps.html
  fi
done
cat templates/trackmaps2.html.template >> trackmaps.html

# Insert footer
cat templates/footer.html.template >> trackmaps.html

perl -p -i -e "s/\r//g" trackmaps.html

# VARIABLE REPLACEMENTS
sed-replace %TRACKMAPS_ORDER_LINK% "$TRACKMAPS_ORDER_LINK" trackmaps.html
