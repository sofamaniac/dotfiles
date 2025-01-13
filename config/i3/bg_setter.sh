file=$(find ~/wallpapers -type f | shuf -n 1)

feh --bg-fill $file --bg-fill $file
