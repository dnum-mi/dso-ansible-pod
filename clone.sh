#!/bin/bash
set -e

if [ -z "$CLONE_DIR" ]; then
CLONE_DIR=/dso/
fi
if [ -z "$PLAYBOOK_DIR" ]; then
PLAYBOOK_DIR=$CLONE_DIR
fi

# assume you want to clone a repo if you pass GIT_REPO var
if [ ! -z "$GIT_REPO" ]; then
  [ ! -d "$CLONE_DIR" ] && mkdir -p "$CLONE_DIR"
  rm "$CLONE_DIR"/* "$CLONE_DIR"/.* -rf || true
  # assume you want to clone with auth if you pass GIT_USER var
  if [ ! -z "$GIT_USER" ]; then
    AUTH="${GIT_USER}:${GIT_TOKEN}@"
  fi
  # assume you want to clone a specific branch if you pass GIT_BRANCH var
  if [ ! -z "$GIT_BRANCH" ]; then
    BRANCH="--branch ${GIT_BRANCH}"
  fi
  TMPD=$(mktemp -d)
  git clone https://${AUTH}${GIT_REPO} ${TMPD} ${BRANCH}
  cp -r ${TMPD}/*  ${CLONE_DIR}
  cp -r ${TMPD}/.* ${CLONE_DIR}
fi

exec "$@"
