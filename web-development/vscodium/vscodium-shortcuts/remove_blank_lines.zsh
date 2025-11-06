#!/bin/zsh

echo "🧹 Eliminando líneas vacías vía regex..."
codium --reuse-window --command workbench.action.findInFiles \
  --args --query "^\s*$\n" --replace "" --isRegex true

