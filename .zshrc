
#MONKEY_DOT=$HOME/dot-monkey
#ZSH_THEME="af-magic"
#plugins=(git)
#
#
## set zsh theme
#source $MONKEY_DOT/themes/spectrum
#
#if [ -f $MONKEY_DOT/themes/$ZSH_THEME.zsh-theme ]; then
#	source $MONKEY_DOT/themes/$ZSH_THEME.zsh-theme
#fi
#
## set zsh plugins
#for plugin ($plugins); do
#	if [ -f $MONKEY_DOT/plugins/$plugin.plugin.zsh ]; then
#		source $MONKEY_DOT/plugins/$plugin.plugin.zsh
#	fi
#done
#
## set aliases
#source $MONKEY_DOT/aliases


# vim everywhere
set -o vi
export GIT_EDITOR=vim
export EDITOR=vi
export VISUAL=vi
