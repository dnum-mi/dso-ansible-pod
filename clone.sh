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
  git clone https://${AUTH}${GIT_REPO} ${CLONE_DIR} ${BRANCH}
fi
if [[ "$NODE_ENV" == "production" && "$CI" != "true" ]]; then
  ansible-playbook $PLAYBOOK_DIR/import_all.yml -i $PLAYBOOK_DIR/inventory/ --connection=local
fi

exec "$@"
