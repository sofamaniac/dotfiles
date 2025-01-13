#!/usr/bin/env sh

set -euo pipefail

Help()
{
  # Display help message
  echo "Setup syncthing, tailscale must be active for it to work"
  echo
  echo "Usage: ./setup_syncthing.sh [options] <target-name>"
  echo "<target-name>: hostname of target to connect to."
  echo "Options:"
  echo "-n, --name <display-name> name used in syncthing interface for target"
  echo "-h, --help                show this help message"
}

CheckTailscale() {
  # check if tailscale is up
  echo "Checking tailscale connection"
  STATUS="$(tailscale status | grep $TARGET | grep active)"
  if [[ -z "${STATUS// /}" ]]; then
    echo "Not connected to tailscale"
    exit 1
  fi
}

GetTargetID() {
  # get ID
  echo "Getting $TARGET's ID"
  ID="$(ssh $TARGET syncthing --device-id)"
  if [[ -z "${ID// /}" ]]; then
    echo "Could not get $TARGET's ID"
    exit 1
  fi
}

Connect() {
  # check if already connected to target
  CON="$(syncthing cli show connections)"
  FILTER='.connections|keys|map(select( . == "'$ID'"))|length'
  RES="$(echo $CON | jq "$FILTER")"

  if [ "$RES" = "1" ]; then 
    echo "Already connected to $TARGET"
    exit 0
  else 
    echo "Connecting to $TARGET"
    # Adding devices on both sides
    syncthing cli config devices add --device-id=$ID --name=$TARGET --auto-accept-folders
    ssh $TARGET syncthing cli config devices add --device-id=$(syncthing --device-id) --name=$(hostname)
    echo "Setting up folders"
    # Adding shared folders
    syncthing cli config folders add --id=x9yls-aaswg --path=~/Nextcloud
    syncthing cli config folders add --id=1v6b3-54wrm --path=~/Musics
  fi
}

# adapted from https://stackoverflow.com/a/29754866
# name requires 1 argument
LONGOPTS=help,name:
SHORTOPTS=h,n:

# append '--' to end of argument list
PARSED="$(getopt --options=$SHORTOPTS --longoptions=$LONGOPTS --name="$0" -- "$@")"
eval set -- "$PARSED"

TARGET=
TARGET_NAME=
while true; do
  case "$1" in
    -h|--help)
      Help
      exit 0;;
    -n|--name)
      TARGET_NAME=$2
      shift 2;;
    --)
      shift
      break;;
    *)
      echo "Programming error"
      exit 3;;
  esac
done

if [[ "$#" -ne 1 ]]; then
  echo "$0: expecting one argument, see --help for usage"
  exit 1
fi

if [[ -z $TARGET_NAME ]]; then
  TARGET_NAME=$TARGET
fi

CheckTailscale
GetTargetID
Connect

