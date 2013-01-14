m.zsh
=====

a simple mount function for zsh

source this script within your .zshrc to enable

pmount is a dependency


m [-h, --help]

  -h, --help,	print usage

	stdin,	[1..n] mount/unmount
			r	reload list
			a	abort

This prints a list of numbered mountable volumes and mounts a chosen device via pmount.
To mount oder unmount a volume enter its number. Any other input will lead to no operation.
