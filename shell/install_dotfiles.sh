#!/bin/zsh

function dotfiles_install() { 
  _print_info "\nRunning dotfiles install phase..."
  
  ln -sF "$DOTFILES_PATH/.zshrc" "$HOME"
  
  (cd $DOTFILES_PATH && git submodule update --init --recursive) 
  (cd "$DOTFILES_DEPENDECIES_PATH/xcode_theme" && "./install.sh") 
}

function brew_install() {
  _print_info "\nRunning brew install phase..."
  
  if ! _is_installed "brew"; then
    /bin/bash -c "$( curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh )"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/maximkrouk/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  
  # GUI apps
  _maybe_brew_cask_install "firefox" # primary browser 
  _maybe_brew_cask_install "raycast" # best relacement of spotlight and smol tools
  _maybe_brew_cask_install "iina" # best video player
  _maybe_brew_cask_install "telegram" # best messanger
  _maybe_brew_cask_install "airbuddy" # better airpods experience 
  _maybe_brew_cask_install "iterm2" # best terminal 
  _maybe_brew_cask_install "fork" # amazing git client
  _maybe_brew_cask_install "sublime-text" # amazing text editor
  _maybe_brew_cask_install "visual-studio-code" # best merge tool
  _maybe_brew_cask_install "paw" # api tool (http client and more)
  _maybe_brew_cask_install "transmission" # torrent client 
  _maybe_brew_cask_install "discord"
  _maybe_brew_cask_install "slack"
  _maybe_brew_cask_install "dash" # search docks like a king
  _maybe_brew_cask_install "spotify" # music
  _maybe_brew_cask_install "netnewswire" # Nice open-source RSS client for macOS/iOS

  # cli 
  _maybe_brew_install "robotsandpencils/made/xcodes" # xcode versions manager
  _maybe_brew_install "mas" # download apps from app store 
  _maybe_brew_install "ripgrep" # better grep
  _maybe_brew_install "fd" # better find
  _maybe_brew_install "tealdeer" # better tldr
  _maybe_brew_install "jq" # json processor
  _maybe_brew_install "shellcheck" # tool for static analysis of shellscript
  _maybe_brew_install "bat" # beautiful printing directly to terminal
  _maybe_brew_install "exa" # modern ls replacement
  _maybe_brew_install "httpie" # fancy curl
  _maybe_brew_install "gh" # working with github from cli
  _maybe_brew_install "coreutils" # some linux utils that now available by default on macOS
  _maybe_brew_install "gnupg" # gpg
  _maybe_brew_install "fzf" && $(brew --prefix)/opt/fzf/install # fuzzy search 
  _maybe_brew_install "lazygit" # better work with git from cli
  _maybe_brew_install "tree" # print tree of directories structure
  _maybe_brew_install "git-delta" # syntax-highlighting pager for git, diff, and grep output

  # App Store 
  # _mas_install "1569600264" # Pandan. Time Tracking app
}

function tools_install() {
  _print_info "\nRunning tools install phase..."

  # rust
  curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh

  # xcode
  xcodes install --latest
}

function configs_install() {
  _print_info "\nRunning configs install phase..."
  
  # git
  (cd "$DOTFILES_CONFIG_PATH/git" && touch ".github_token" && echo -e "[user]\n\ttoken = " > .github_token)
  _print_warning "GitHub Token setup needed"
  ln -sF "$DOTFILES_CONFIG_PATH/git/.gitconfig" "$HOME/.gitconfig" 
  ln -sF "$DOTFILES_CONFIG_PATH/git/.github_token" "$HOME/.github_token"
  ln -sF "$DOTFILES_CONFIG_PATH/git/.gitignore" "$HOME/.gitignore"

  # color picker
  cp "$DOTFILES_CONFIG_PATH/color_picker/Color Picker.app" "/Applications"

  # lazygit
  _lazygit_config
}

function additional_setup() { 
  _print_info "\nRunning additional setup phase..."
  
  _print_warning "'SF Mono' install needed" 
  _print_warning "'raycast config' import needed"

  # TODO: Write script to automaticly upload ssh key
  # https://github.com/TheArqsz/auto-ssh-key
  # Generate ssh key
  (
    cd ~/.ssh \
      && ssh-keygen -t ecdsa -C "id.maximkrouk@gmail.com" \
      && cat id_ecdsa.pub | pbcopy \
      && _print_warning "Go to https://github.com/settings/keys and register SSH key from pasteboard"
  )
}

export DOTFILES_PATH="$( cd "$(dirname "$0")/"../ && pwd )"
source "$DOTFILES_PATH/shell/exports.sh"
source "$DOTFILES_PATH/shell/functions.sh"

xcode-select --install 2>/dev/null || _print_warning "Xcode CLI tools already installed"
dotfiles_install
brew_install
tools_install
configs_install
additional_setup

source "$HOME/.zshrc"

sudo /bin/zsh "$DOTFILES_PATH/shell/setup_sudo_touch_id.sh"
/bin/zsh "$DOTFILES_CONFIG_PATH/macos/defaults.sh"
