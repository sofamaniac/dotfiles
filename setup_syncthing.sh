#!/usr/bin/env sh

set -euo pipefail

Help()
{
  echo
  echo "Setup syncthing, tailscale must be active for it to work"
  echo
  echo "Usage:"
  echo "  $(basename $0) [options] <target>"
  echo
  echo "Parameters:"
  echo "  <target>: hostname of target to connect to."
  echo
  echo "Options:"
  echo "  -n, --name <display-name> name used locally in syncthing interface for <target>"
  echo "  -h, --help                show this help message"
  echo "  -l, --list                list all available folders' id on <target-name>"
}

CheckTailscale() {
  # check if tailscale is up
  echo "Checking tailscale connection"
  # grep returns 0 when it found a result, 1 when it did not and 2 if there was an error
  STATUS="$(tailscale ping $TARGET | { grep pong || test $?=1; })"
  if [[ -z "${STATUS// /}" ]]; then
    echo "Not connected to tailscale" >&2
    exit 1
  fi
  echo "Connected to tailscale"
}

GetTargetID() {
  # get ID
  echo "Getting $TARGET's ID"
  ID="$(ssh $TARGET syncthing --device-id)"
  if [[ -z "${ID// /}" ]]; then
    echo "Could not get $TARGET's ID" >&2
    exit 1
  fi
}

ListAll() {
    FOLDERS=$(ssh $TARGET syncthing cli config folders list)
    for folder in $FOLDERS; do
      echo $folder
    done
}

# Setup the connection to the provided folder's ID
ConnectOne() {
  local id=
  id="$1"
  local path=
  local label=
  
  path=$(ssh cli config folders $1 path get)
  label=$(ssh cli config folders $1 label get)

  echo "Settig up $label"

  syncthing cli config folders add --id="$id" --path="$path" --label="$label"
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
    syncthing cli config devices add --device-id=$ID --name=$TARGET
    ssh $TARGET syncthing cli config devices add --device-id=$(syncthing --device-id) --name=$(hostname)
    echo "Setting up folders"
    local folders=
    folders=$(ssh $TARGET syncthing cli config folders list)
    for folder in $folders; do
      ConnectOne $folder
    done
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
IS_LIST=false
while true; do
  case "$1" in
    -h|--help)
      Help
      exit 0;;
    -n|--name)
      TARGET_NAME=$2
      shift 2;;
    -l | --list)
      IS_LIST=true
      shift;;
    --)
      shift
      break;;
    *)
      echo "Programming error" >&2
      exit 3;;
  esac
done

if [[ "$#" -ne 1 ]]; then
  echo "$0: expecting exactly one argument, see --help for usage" >&2
  exit 1
fi

TARGET=$1

if [[ -z $TARGET_NAME ]]; then
  TARGET_NAME=$TARGET
fi

if $IS_LIST; then
  ListAll
  exit 0
fi

CheckTailscale
GetTargetID
Connect

echo "Check at http://127.0.0.1:8384/# that everything is ok"
