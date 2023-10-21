#!/bin/bash
# Source https://serverfault.com/a/831184
# License: CC BY-SA 4.0

for bcfile in ~/.bash_completion.d/* ; do
  # shellcheck source=/dev/null
  . "${bcfile}"
done