function fish_prompt --description 'Write out the prompt'
		set -l ansi_reset "\e[m"
		set -l ansi_bold "\e[1m"
		set -l ansi_fore0 "\e[30m"
		set -l ansi_fore1 "\e[31m"
		set -l ansi_fore2 "\e[32m"
		set -l ansi_fore3 "\e[33m"
		set -l ansi_fore4 "\e[34m"
		set -l ansi_fore5 "\e[35m"
		set -l ansi_fore6 "\e[36m"
		set -l ansi_fore7 "\e[37m"

		set -l cwd (pwd | sed -e "s!^$HOME!~!g")

		if [ (id -u) = 0 ]
				set -l suffix '#'
		else
				set -l suffix '$'
		end

		set -l f_lbracket (echo -s $ansi_bold "[" $ansi_reset)
		set -l f_rbracket (echo -s $ansi_bold "]" $ansi_reset)
		set -l f_separator (echo -s $ansi_bold "@" $ansi_reset)
		set -l f_user (echo -s $ansi_bold $ansi_fore2 $USER $ansi_reset)
		set -l f_host (echo -s $ansi_bold $ansi_fore4 $hostname $ansi_reset)
		set -l f_cwd (echo -s $ansi_bold $ansi_fore5 $cwd $ansi_reset)
		set -l f_suffix (echo -s $ansi_bold $ansi_fore3 "\$ " $ansi_reset)

		echo -e -n -s $ansi_reset $f_lbracket $f_user $f_separator $f_host " " $f_cwd $f_rbracket $f_suffix

end
