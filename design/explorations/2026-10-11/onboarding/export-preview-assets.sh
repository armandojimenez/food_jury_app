#!/bin/sh
# Small, transparent preview exports. Production originals remain untouched.
set -eu
root=$(CDPATH= cd -- "$(dirname -- "$0")/../../../.." && pwd)
dest="$root/design/explorations/2026-10-11/onboarding/assets"
for pose in stern pointing thinking celebrating waving excited idle; do
  cwebp -quiet -q 82 -resize 440 0 "$root/assets/images/judge_bite_v2/$pose.png" -o "$dest/$pose.webp"
done
for food in pizza tacos salad burger; do
  cwebp -quiet -q 82 -resize 300 0 "$root/assets/images/food_illustrations/$food.png" -o "$dest/$food.webp"
done
cwebp -quiet -q 86 -resize 640 0 "$dest/judge-at-counter.png" -o "$dest/counter.webp"
cwebp -quiet -q 84 -resize 500 0 "$dest/judge-inspecting-evidence.png" -o "$dest/detective.webp"
cwebp -quiet -q 88 -resize 500 0 "$root/assets/images/brand/foodjury-wordmark.png" -o "$dest/wordmark.webp"
