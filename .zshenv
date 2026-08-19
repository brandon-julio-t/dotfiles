# User executables must also be available to non-interactive shells.
typeset -U path PATH
path=("$HOME/.local/bin" $path)
