#!/usr/bin/env bash

set -o errexit

npm install -g sass
npm i -D postcss postcss-cli

bundle install
bin/rails assets:precompile
bin/rails assets:clean

bin/rails db:migrate