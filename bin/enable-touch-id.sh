#!/usr/bin/env bash

set -e

[[ "$(uname -s)" == "Darwin" ]] && mac_os=true || mac_os=false

if ! $mac_os; then
  echo "This script is only for macOS"
  exit 1
fi

case `grep -F "pam_tid" /etc/pam.d/sudo >/dev/null; echo $?` in
  0)
    echo "TouchID unlock already in place"
    exit 0
    ;;
  1)
    sudo sed -i '' '1a\
auth       sufficient     pam_tid.so
    ' /etc/pam.d/sudo

    echo "TouchID unlock enabled"
    ;;
  *)
    echo "Error trying to read /etc/pam.d/sudo"
    ;;
esac
