#!/bin/bash
SESSION="harmony-swarm"

tmux new-session -d -s $SESSION -n "agents"

# Lead pane (top-left)
tmux send-keys -t $SESSION "claude --resume lead" Enter

# Builder pane (top-right)
tmux split-window -h -t $SESSION
tmux send-keys -t $SESSION "claude --resume builder" Enter

# Reviewer pane (bottom-left)
tmux split-window -v -t $SESSION:0.0
tmux send-keys -t $SESSION "claude --resume reviewer" Enter

# Verifier pane (bottom-right)
tmux split-window -v -t $SESSION:0.1
tmux send-keys -t $SESSION "claude --resume verifier" Enter

# Logs tab
tmux new-window -t $SESSION -n "logs"
tmux send-keys -t $SESSION "tail -f .harmony/continuity/log.md" Enter

tmux select-window -t $SESSION:0
tmux select-pane -t 0
tmux attach -t $SESSION
