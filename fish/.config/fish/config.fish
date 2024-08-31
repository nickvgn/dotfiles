# if status is-interactive
# end

set -g theme_powerline_fonts yes
set -g theme_nerd_fonts yes

# PATHS
set -gx PATH "$HOME/.cargo/bin" $PATH;
set -gx PATH "/opt/homebrew/bin" $PATH;
# android
set --export ANDROID_HOME $HOME/Library/Android/sdk
set --export JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
set -gx PATH $ANDROID_HOME/emulator $PATH;
set -gx PATH $ANDROID_HOME/tools $PATH;
set -gx PATH $ANDROID_HOME/tools/bin $PATH;
set -gx PATH $ANDROID_HOME/platform-tools $PATH;
# llvm
set -gx PATH "/opt/homebrew/Cellar/llvm/17.0.6_1/bin" $PATH;
# go
set -gx PATH $HOME/go/bin $PATH;
# psql
set -gx PATH /opt/homebrew/opt/postgresql@16/bin $PATH
# protoc
set -x PROTOC /opt/homebrew/bin/protoc

# ALIAS
# exa
alias ls="exa -a --icons"
alias ll="exa -la --icons"
# cd
alias ..="cd ../"
alias ...="cd ../../"
# nvim
alias vi="arch -arm64 nvim"
# git
alias glog="git log --all --pretty='format:%d %Cgreen%h%Creset %an - %s' --graph"
# gnu
alias xargs="gxargs"
alias find="gfind"

# https://github.com/MordechaiHadad/bob
 set PATH "$HOME/.local/share/bob/nvim-bin" $PATH;

# https://crates.io/crates/starship
starship init fish | source

# https://github.com/jdx/rtx
~/.cargo/bin/mise activate fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH


set --export BAT_THEME "gruvbox-dark"

source ~/.asdf/asdf.fish

# Set up fzf key bindings
fzf --fish | source

zoxide init fish | source

# launch interactive shell in ~/dev dir
#if status is-interactive
#    cd ~/dev
#end