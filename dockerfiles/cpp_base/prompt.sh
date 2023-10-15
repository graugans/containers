export FMT_RESET="\e[0m"
export FG_BLACK="\e[30m"
export FG_GREEN="\e[32m"
export FG_MAGENTA="\e[35m"
export FG_RED="\e[31m"
export FG_WHITE="\e[97m"
export BG_BLUE="\e[44m"
export BG_GREEN="\e[42m"
export BG_MAGENTA="\e[45m"

export PS1="\n\[${BG_GREEN}\] \[${FG_RED}\]>> \[${FG_BLACK}\]\u \[${FG_GREEN}${BG_BLUE}\]\[${FG_BLACK}\]\w \[${FMT_RESET}${FG_BLUE}\]\[${BG_MAGENTA}\]\[${FG_WHITE}\]\
\$( git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/' )\[${FMT_RESET}${FG_MAGENTA}\]\n\[${FG_GREEN}\]\
╰\[${FG_CYAN}\]\$ \[${FMT_RESET}\]" >> /home/dev/.bashrc
 