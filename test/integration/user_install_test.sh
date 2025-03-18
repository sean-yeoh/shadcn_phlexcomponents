#! /usr/bin/env bash
# reproduce the documented user journey for installing and running tailwindcss-rails
# this is run in the CI pipeline, non-zero exit code indicates a failure

set -o pipefail
set -eux

# set up dependencies
rm -f Gemfile.lock
bundle remove rails || true
bundle add rails --skip-install ${RAILSOPTS:-}
bundle install --prefer-local

# do our work a directory with spaces in the name (#176, #184)
rm -rf "My Workspace"
mkdir "My Workspace"
pushd "My Workspace"

echo $(pwd)
# create a rails app
bundle exec rails -v
bundle exec rails new test-install --skip-bundle
pushd test-install

# make sure to use the same version of rails (e.g., install from git source if necessary)
bundle remove rails --skip-install
bundle add rails --skip-install ${RAILSOPTS:-}

# bundle add shadcn_phlexcomponents
echo 'gem "shadcn_phlexcomponents", path: "../../"' >> Gemfile
# bundle add tailwindcss-ruby --skip-install ${TAILWINDCSSOPTS:-}
bundle install --prefer-local
bundle binstubs --all

# install shadcn_phlexcomponents
rake shadcn_phlexcomponents:install

# TEST: presence of the generated file
grep -q "Show" app/assets/tailwind/shadcn_phlexcomponents/tailwindcss-animate.css
grep -q "Show" app/javascript/controllers/shadcn_phlexcomponents/theme_switcher_controller.js
grep -q "Show" vendor/shadcn_phlexcomponents/components/base_component.rb

echo "OK"
