# Enable tab completion
source ~/.git-config/git-completion.bash

# Change command prompt # This file is necessary for the git related stuff, like commit ids to show up in your prompt
source ~/.git-config/git-prompt.sh

# colors!

green="\[\033[38;05;38m\]"
blue="\[\033[0;34m\]"
purple="\[\033[0;35m\]"
reset="\[\033[0m\]"

#this line will show up an asterisk in your prompt if you change something in git repo
export GIT_PS1_SHOWDIRTYSTATE=1 

# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory

# $purple\u >>> it will show you username in purple
# $green\$(__git_ps1) >>> commit you have checked out and other git related stuff in green 
# $blue \W $ >>> the directory you're currently in followed by a dollar sign
# $reset >>> anything after this will be in a default color

export PS1="$purple\u$green\$(__git_ps1)$blue \W $ $reset" #this line sets the prompt


#will add an alias to open any file using sublime editor, you can type > sublime file_name
alias sublime="C:/Program\ Files/Sublime\ Text\ 3/sublime_text.exe"

date
echo 'Hello!! All your activities are monitored, enjoy ;)'
