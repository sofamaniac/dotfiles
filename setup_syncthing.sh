#!/usr/bin/env sh

set pipe -euo pipefail

# get ID
ID="$(ssh mordred syncthing --device-id)"
if [[ -z "${ID// /}" ]]; then
  echo "Could not get mordred's ID"
  exit 1
fi

# check if already connected to mordred
CON="$(syncthing cli show connections)"
FILTER='.connections|keys|map(select( . == "'$ID'"))|length'
RES="$(echo $CON | jq "$FILTER")"

if [ "$RES" = "1" ]; then 
  echo "connected to mordred"
  exit 0
else 
  echo "not connected to mordred"
  # Adding devices on both sides
  syncthing cli config devices add --device-id=$ID --name=mordred --auto-accept-folders
  ssh mordred syncthing cli config devices add --device-id=$(syncthing --device-id) --name=$(hostname)
  # Adding shared folders
  syncthing cli config folders add --id=x9yls-aaswg --path=~/Nextcloud
  syncthing cli config folders add --id=1v6b3-54wrm --path=~/Musics
fi

