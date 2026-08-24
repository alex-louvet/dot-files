# Machine-local secrets (ALBERT_API_KEY, ...), kept OUT of git.
# Populated per-machine by setup/scripts/deploy-secrets.sh into
# ~/.local/share/setup-secrets/env.fish (mode 600).
if test -f "$HOME/.local/share/setup-secrets/env.fish"
    source "$HOME/.local/share/setup-secrets/env.fish"
end
