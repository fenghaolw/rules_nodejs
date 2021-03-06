#!/usr/bin/env bash

set -u -e -o pipefail

# Publishes our npm packages
# To dry-run:
#   ./scripts/publish_release.sh pack
# To verify:
#   for p in $(ls packages); do if [[ -d packages/$p ]]; then b="@bazel/$p"; echo -ne "\n$b\n-------\n"; npm dist-tag ls $b; fi; done

readonly RULES_NODEJS_DIR=$(cd $(dirname "$0")/..; pwd)
source "${RULES_NODEJS_DIR}/scripts/packages.sh"

readonly NPM_COMMAND=${1:-publish}

# Use a new output_base so we get a clean build
# Bazel can't know if the git metadata changed
readonly TMP=$(mktemp -d -t bazel-release.XXXXXXX)

echo_and_run() { echo "+ $@" ; "$@" ; }

${RULES_NODEJS_DIR}/scripts/build_packages_all.sh

for pkg in ${PACKAGES[@]} ; do (
    printf "\n\nBuilding & ${NPM_COMMAND}ing package ${pkg} //:npm_package\n"
    cd packages/$pkg
    echo_and_run ../../node_modules/.bin/bazel --output_base=$TMP run  --workspace_status_command=../../scripts/current_version.sh //:npm_package.${NPM_COMMAND}
) done

# packages/create is not a nested workspace and has no deps
echo_and_run node_modules/.bin/bazel --output_base=$TMP run  --workspace_status_command=scripts/current_version.sh //packages/create:npm_package.${NPM_COMMAND}
