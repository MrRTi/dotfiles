# sbx template: Docker's Claude Code sandbox image plus these dotfiles, applied
# with chezmoi profile "box". Build and load with `just sbx-template`, then:
#   sbx run --pull never -t sbx-dotfiles:latest claude <dir>
FROM docker/sandbox-templates:claude-code

USER root
# Only what mise can't provide: fish, gpg, and a compiler plus C headers for
# native gems (pg, mysql2, psych, openssl).
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		fish gnupg build-essential \
		libpq-dev libmysqlclient-dev libyaml-dev libssl-dev libreadline-dev zlib1g-dev libffi-dev \
	&& rm -rf /var/lib/apt/lists/*

USER agent
# Shims, not `mise activate`: agents run non-interactive bash, which reads no rc file.
ENV PATH=/home/agent/.local/share/mise/shims:/home/agent/.local/bin:$PATH
RUN curl -fsSL https://mise.run | sh \
	&& sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b /home/agent/.local/bin

# DOTFILES_REV is the remote HEAD (`just sbx-template` passes it), so a push
# invalidates this layer and everything after it.
ARG DOTFILES_REV
RUN mkdir -p ~/.config/chezmoi \
	&& printf '[data]\n  profile = "box"\n' > ~/.config/chezmoi/chezmoi.toml \
	&& echo "dotfiles at ${DOTFILES_REV:-unknown}" \
	&& chezmoi init --apply MrRTi

# Plugins at lazy-lock.json's commits, and the treesitter parsers.
RUN nvim --headless "+Lazy! restore" +qa \
	&& nvim --headless "+TSInstallParsers!" +qa
