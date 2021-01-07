#!/bin/bash

rm gallery.html

cat gallery1.html.template >> gallery.html

i=1
for f in assets/images/tracks/*.png; do
  name=$(echo $f | cut -f 1 -d '.')
  base="$(basename -- "$name")"
  echo $name
  nospace=$( printf "%s\n" "$f" | sed 's/ /%20/g' )

  cat >> gallery.html << EOL
              <div class="col-md-2">
                <div class="table-left">
                  <div class="track">$base</div>
                  <img class="bike-fluid" src="$nospace">
                </div>
              </div>
EOL
  i=$((i+1))
  if (( $i == 7 )); then
    i=1
    echo '</div><div class="row trackrow text-center">' >> gallery.html
  fi
done

cat gallery2.html.template >> gallery.html

perl -p -i -e "s/\r//g" gallery.html
