# Please check that `readlink /usr/local/share/zsh/site-functions/prompt_pure_setup` is linking `$HOME/.dotfiles/dependencies/pure/pure.zsh`
# if not use next commands: 
# 1. `unlink /usr/local/share/zsh/site-functions/prompt_pure_setup`
# 2. `ln -s $DOTFILES_DEPENDECIES_PATH/pure/pure.zsh /usr/local/share/zsh/site-functions/prompt_pure_setup`

fpath=("$DOTFILES_DEPENDECIES_PATH/pure" $fpath)

autoload -U promptinit; promptinit

zstyle :prompt:pure:git:stash show yes

prompt pure
