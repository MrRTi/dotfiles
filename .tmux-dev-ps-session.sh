if ! tmux has-session -t ps; then
	tmux -f ~/.usr_config/.tmux.conf new -s ps -d
	tmux rename-window -t ps:1 server
	tmux new-window -t ps:2
	tmux rename-window -t ps:2 dcrb
	tmux new-window -t ps:3
	tmux rename-window -t ps:3 git
fi
tmux attach -t ps
