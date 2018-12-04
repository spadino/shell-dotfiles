# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022

# start the ssh-agent
eval $(ssh-agent) > /dev/null 

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Add GOPATH to PATH
export PATH="${GOPATH//://bin:}$PATH"

function scoop() { powershell -ex unrestricted scoop.ps1 "$@" ;} && export -f scoop


# Check for running bash, and initialize accordingly
case "$SHELL" in
	/usr/bin/bash )
		source "$HOME/.shellrc/rc.d/prompt/git"
		source ~/.shellrc/rc.d/colors/git
		source ~/.shellrc/gitrc ;;
	/bin/bash )		
		source "$HOME/.shellrc/rc.d/prompt/ubuntu" 
		source ~/.shellrc/rc.d/colors/ubuntu-base16
		source ~/.shellrc/bashrc ;;
esac

