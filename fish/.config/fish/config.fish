if status is-interactive
		alias ls='exa --color=auto'
		alias la='exa --color=auto -ah'
		alias lh='exa --color=auto -lh'
		alias ll='exa --color=auto -lah'
		alias emc='emacsclient -c -a emacs'
		alias emr='pkill emacs && emacs --daemon'

		set -x EDITOR emacsclient -c -a emacs

		fish_vi_key_bindings

		wal -R -q
		sleep 0.2
		clear
		pfetch
		# Commands to run in interactive sessions can go here
end
