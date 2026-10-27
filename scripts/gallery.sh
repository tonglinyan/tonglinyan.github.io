#!/bin/zsh
# Prepare photos in images/gallery/ for the web:
#   - prefix the file name with the capture date (YYYY-MM-DD_)
#   - bake EXIF rotation into the pixels
#   - resize to 2000px on the long side (JPEG quality 75)
#   - strip GPS location data
#   - write a 720px thumbnail to images/gallery/thumbs/
# Safe to re-run: photos already processed are skipped.
#
# Usage: zsh scripts/gallery.sh   (needs exiftool: brew install exiftool)

set -e
cd "$(dirname "$0")/../images/gallery"
mkdir -p thumbs

FULL=2000
THUMB=720
QUALITY=75
THUMB_QUALITY=65

# Date prefix for new photos (files not starting with a year)
for f in *.(jpg|JPG|jpeg|JPEG)(N); do
  [[ $f == 20??-??-??_* ]] && continue
  d=$(exiftool -s3 -d %Y-%m-%d -DateTimeOriginal -CreateDate "$f" | head -1)
  [[ -z $d ]] && d=$(date -r "$f" +%Y-%m-%d)
  mv -n "$f" "${d}_${f:r}.jpg"
done

for f in *.jpg(N); do
  w=$(sips -g pixelWidth "$f" | awk '/pixelWidth/{print $2}')
  h=$(sips -g pixelHeight "$f" | awk '/pixelHeight/{print $2}')
  o=$(exiftool -s3 -n -Orientation "$f")
  if (( w > FULL || h > FULL )) || [[ -n $o && $o != 1 ]]; then
    case $o in
      3) rot=180 ;;
      6) rot=90 ;;
      8) rot=270 ;;
      *) rot=0 ;;
    esac
    sips -r $rot -Z $FULL -s formatOptions $QUALITY "$f" --out "$f.tmp.jpg" >/dev/null
    exiftool -q -overwrite_original -n -Orientation=1 -gps:all= "$f.tmp.jpg"
    mv "$f.tmp.jpg" "$f"
    echo "resized $f"
  fi
  if [[ ! -f thumbs/$f ]]; then
    sips -Z $THUMB -s formatOptions $THUMB_QUALITY "$f" --out "thumbs/$f" >/dev/null
    echo "thumb   $f"
  fi
done

# Remove thumbnails whose photo was deleted
for t in thumbs/*.jpg(N); do
  [[ -f ${t:t} ]] || { rm "$t"; echo "removed thumbs/${t:t}"; }
done
