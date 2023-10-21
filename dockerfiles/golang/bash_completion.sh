#!/bin/bash
# SPDX-License-Identifier: CC-BY-SA-4.0
# Origin: https://serverfault.com/a/831184

for bcfile in ~/.bash_completion.d/* ; do
  # shellcheck source=/dev/null
  . "${bcfile}"
done