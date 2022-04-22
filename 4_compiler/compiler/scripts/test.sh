#!/usr/bin/env bash

cabal test --test-log=/dev/stdin --verbose=0 "${@}"
