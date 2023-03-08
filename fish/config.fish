export PATH="$HOME/.cargo/bin:$PATH"
set -gx GOPATH "$HOME/go"
set -gx PATH "$GOPATH/bin:$PATH"
set -gx XDG_DATA_HOME "$HOME/.config"
set -gx MANPAGER 'nvim +Man!'
fish_vi_key_bindings
