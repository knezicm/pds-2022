#!/bin/bash

echo "This PR is opened by ${{ github.event.pull_request.user.login }}."

DIR="/${{ github.event.pull_request.user.login }}/"
if [ -d "$DIR" ]; then
  echo "Directory ${DIR} exists. Now checking if test.vhd file exists..."
else
  echo "Error: ${DIR} not found. Aborting..."
  exit 1
fi

if test -f test.vhd; then
    echo "File test.vhd exists. Checking syntax..."
    ghdl -s test.vhd
else
    echo "File test.vhd does not exist. Aborting..."
    exit 1
fi
