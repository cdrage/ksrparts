#!/bin/bash

# Replace function
sed-replace() {
  find $3 -type f -name "*.*" -not -path "*/.git/*" -not -path "*/vendor/*" -print0 | xargs -0 sed -i "s|$1|$2|g"
}

INDEX_TITLE="Motorcycle Parts and Art"
LAPTIMERS_TITLE="GPS Lap Timers"
TRACKMAPS_TITLE="Race track Sculptures"
LEVERGUARDS_TITLE="Brake and Clutch Lever Guards"
TRACKMAPS_ORDER_LINK="https://forms.gle/Zmidy3HAFgYoa4Vd9"
LAPTIMERS_ORDER_LINK="https://forms.gle/EfyEvYZq5Va6bMiQ8"
LEVERGUARDS_ORDER_LINK="https://forms.gle/EfyEvYZq5Va6bMiQ8"

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
sed-replace %TITLE% "$LAPTIMERS_TITLE" laptimers.html
sed-replace %LAPTIMERS_ORDER_LINK% "$LAPTIMERS_ORDER_LINK" laptimers.html

################
# LEVER GUARDS #
################
rm leverguards.html
cat templates/header.html.template \
  templates/leverguards.html.template \
  templates/footer.html.template \
  >> leverguards.html
sed-replace %TITLE% "$LEVERGUARDS_TITLE" leverguards.html
sed-replace %LEVERGUARDS_ORDER_LINK% "$LEVERGUARDS_ORDER_LINK" leverguards.html

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
sed-replace %TITLE% "$TRACKMAPS_TITLE" laptimers.html
