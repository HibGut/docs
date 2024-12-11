#!/bin/bash

# Set to the dashpay/docs branch containing the version to update
DOC_VERSION=master

# Checkout correct branch and pull changes
git fetch
git checkout $DOC_VERSION
git pull upstream $DOC_VERSION

# Temporarily replace docs/core/dips/README.md to avoid warnings
echo "# Dash Improvement Proposals (DIPs)" > docs/core/dips/README.md

# Make files needed by sphinx-intl
rm -r _build
make gettext 2>&1 | tee /tmp/makelog_$$.log
if [ $PIPESTATUS -ne 0 ]; then echo "make failed, bailing out...";exit 1 ;fi
grep ": WARNING: " /tmp/makelog_$$.log
if [ $? -eq 0 ]; then echo "make issued a WARNING, bailing out...";exit 2;fi

# Remove gettext files and directories for docs/core
rm -r _build/gettext/docs/core

# Restore the original docs/core/dips/README.md from git
git checkout -- docs/core/dips/README.md

# Update files for all languages
sphinx-intl update -p _build/gettext -l de -l pt -l ko -l el -l ar -l ru -l zh_CN -l fr -l es -l ja -l vi -l zh_TW -l it -l tl
sphinx-intl update -l en
sphinx-intl update-txconfig-resources --pot-dir locale/pot  --transifex-organization-name dash --transifex-project-name dash-docs

# Push to Transifex
tx push --source --force
