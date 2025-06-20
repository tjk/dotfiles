#!/bin/bash

session1="go-string"
tmux new-session -d -s $session1
tmux send-keys -t $session1:1 'cd go-string && vi .' C-m
tmux new-window -t $session1:2
tmux send-keys -t $session1:1 'cd go-string && make dev' C-m
tmux new-window -t $session1:3
tmux send-keys -t $session1:3 'cd go-string' C-m

session2="pipedreamin"
tmux new-session -d -s $session2
tmux send-keys -t $session2:1 'cd pipedreamin && vi .' C-m
tmux new-window -t $session2:2
tmux send-keys -t $session2:1 'cd pipedreamin' C-m

session3="services"
tmux new-session -d -s $session3
tmux send-keys -t $session3:1 'cd pipedreamin && redis-server' C-m
tmux new-window -t $session3:2
tmux send-keys -t $session3:2 'cd pipedreamin && mysqld' C-m

tmux attach-session -t $session1:1
