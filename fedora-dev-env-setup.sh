#! /bin/bash

###### BEFORE

set -e

CURR_PWD=$(pwd)

touch "${HOME}/.profile"
touch "${HOME}/.zprofile"

###### VERSIONS

# https://go.dev/dl/
GO_VERSION="go1.22.6"

# https://www.lua.org/download.html
LUA_VERSION="lua-5.4.7"

# https://luarocks.org/
LUAROCKS_VERSION="luarocks-3.11.1"

###### HELPER FUNCTIONS

add_to_path() {
	grep -q "export PATH=$1:\${PATH}" "${HOME}/.profile" || echo "export PATH=$1:\${PATH}" >> "${HOME}/.profile"
	grep -q "export PATH=$1:\${PATH}" "${HOME}/.zprofile" || echo "export PATH=$1:\${PATH}" >> "${HOME}/.zprofile"
}

reload_profile() {
	source "${HOME}/.profile"
}

go_home() {
	cd "${HOME}"
}

###### SETUP PACKAGES

sudo dnf update -y
sudo dnf upgrade -y

sudo dnf groupinstall -y "Development Tools" "Development Libraries"

packages=(
	bat
	btop
	fd-find
	fzf
	git
	jq
	libyaml
	kubernetes-client
	neovim
	ripgrep
	stow
	tldr
	tree
	tmux
	wget
	zsh
)

sudo dnf install -y "${packages[@]}"

if [ ! "$SHELL" = "/usr/bin/zsh" ]
then
	chsh -s "$(which zsh)" "${USER}"
fi

###### SET UP LOCAL BIN FOLDER

LOCAL_FOLDER="${HOME}/.local"
mkdir -p "${LOCAL_FOLDER}"

LOCAL_BIN="${LOCAL_FOLDER}/bin"
mkdir -p "${LOCAL_BIN}"

add_to_path "${LOCAL_BIN}"
reload_profile

###### Set up folder for sources

SOURCE_FOLDER="${HOME}/build-sources"
mkdir -p "${SOURCE_FOLDER}"


###### INSTALL LUA

if ! command -v lua &> /dev/null
then
	LUA_ARCHIVE_NAME="${LUA_VERSION}.tar.gz"
	LUA_ARCHIVE_PATH="${SOURCE_FOLDER}/${LUA_ARCHIVE_NAME}"
	if [ ! -f "${LUA_ARCHIVE_PATH}" ]
	then
		echo "Downloading lua tarball..."
		curl -L -R --output "${LUA_ARCHIVE_PATH}" "https://www.lua.org/ftp/${LUA_ARCHIVE_NAME}"
	fi

	tar zxf "${LUA_ARCHIVE_PATH}"
	cd "${LUA_VERSION}"
	echo "Installing lua..."
	sudo make all install

	echo "Clean up..."
	rm "${LUA_ARCHIVE_PATH}"

	go_home
else
	echo "Lua already installed. Skipping"
fi

sudo dnf install -y compat-lua-devel

###### INSTALL LUAROCKS

if ! command -v luarocks &> /dev/null
then
	LUAROCKS_ARCHIVE_NAME="${LUAROCKS_VERSION}.tar.gz"
	LUAROCKS_ARCHIVE_PATH="${SOURCE_FOLDER}/${LUAROCKS_ARCHIVE_NAME}"
	if [ ! -f "${LUAROCKS_ARCHIVE_PATH}" ]
	then
		echo "Downloading luarocks tarball..."
		curl -L -R --output "${LUAROCKS_ARCHIVE_PATH}" "https://luarocks.org/releases/${LUAROCKS_ARCHIVE_NAME}"
	fi

	tar zxpf "${LUAROCKS_ARCHIVE_PATH}"
	cd "${LUAROCKS_VERSION}"
	./configure && make && sudo make install

	echo "Clean up..."
	rm "${LUAROCKS_ARCHIVE_PATH}"

	go_home
else
	echo "Luarocks already installed. Skipping"
fi

###### INSTALL RUBY

sudo dnf install -y ruby ruby-devel zlib-devel rubygem-{irb,rake,rbs,rexml,typeprof,test-unit} ruby-bundled-gems

###### INSTALL RUST

if ! command -v cargo &> /dev/null
then
	echo "Instaling rust..."
	cd  "${SOURCE_FOLDER}"
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	go_home
else
	echo "Rust already installed. Skipping"
fi

###### INSTALL NODE

if ! command -v node &> /dev/null
then
	echo "Instaling node..."
	cd  "${SOURCE_FOLDER}"
	sudo dnf install -y nodejs
	go_home
else
	echo "Node already installed. Skipping"
fi

###### INSTALL YARN

if ! command -v yarn &> /dev/null
then
	echo "Instaling yarn..."
	cd  "${SOURCE_FOLDER}"
	sudo dnf install -y yarnpkg
	go_home
else
	echo "Yarn already installed. Skipping"
fi

###### INSTALL GO

if ! command -v go &> /dev/null
then
	GO_ARCHIVE_NAME="${GO_VERSION}.linux-arm64.tar.gz"
	GO_ARCHIVE_PATH="${SOURCE_FOLDER}/${GO_ARCHIVE_NAME}"
	if [ ! -f "${GO_ARCHIVE_PATH}" ]
	then
		echo "Downloading go tarball..."
		curl -L --output "${GO_ARCHIVE_PATH}" "https://go.dev/dl/${GO_ARCHIVE_NAME}"
	fi

	echo "Set up go executable..."
	rm -rf "${LOCAL_FOLDER}/go" && tar -C "${LOCAL_FOLDER}" -xzf "${GO_ARCHIVE_PATH}"

	add_to_path "${LOCAL_FOLDER}/go/bin"
	reload_profile

	echo "Clean up..."
	rm "${GO_ARCHIVE_PATH}"
else
	echo "Go already installed. Skipping"
fi

###### INSTALL K9S

if ! command -v k9s &> /dev/null
then
	K9S_FOLDER="${SOURCE_FOLDER}/k9s-source"

	if [ ! -d "${K9S_FOLDER}" ]
	then 
		echo "Downloading k9s source..."
		git clone --depth 1 https://github.com/derailed/k9s.git "${K9S_FOLDER}"
	fi

	echo "Building k9s from source..."
	make -C "${K9S_FOLDER}" build 

	echo "Set up k9s executable..."
	rm -rf "${LOCAL_BIN}/k9s" && mv "${K9S_FOLDER}/execs/k9s" "${LOCAL_BIN}/k9s"

	echo "Clean up..."
	rm -rf "${K9S_FOLDER}"
else
	echo "k9s already installed. Skipping"
fi

###### INSTALL NEOVIM DEPS

cd  "${SOURCE_FOLDER}"

gem install neovim
gem install solargraph
gem install rubocop
gem install rubocop-performance
gem install rubocop-rails
gem install rubocop-rspec

sudo luarocks install jsregexp

zsh -c "cargo install stylua"

yarn global add prettier

go_home

###### SET DOTFILES

DOT_FILES_FOLDER="${HOME}/dotfiles"

if [ ! -d "${DOT_FILES_FOLDER}" ]
then 
	echo "Downloading dotfiles..."
	git clone https://github.com/MrRTi/dotfiles.git "${DOT_FILES_FOLDER}"
	
	cd "${DOT_FILES_FOLDER}"
	git remote set-url origin git@github.com:MrRTi/dotfiles.git
fi

cd "${DOT_FILES_FOLDER}"

packages=(
	shell
	zsh
	tmux
	nvim
)

for package in "${packages[@]}"; do
	echo "Applying dotfiles for $package"
	./stow.sh "$package"
done

go_home

###### AFTER

cd "$CURR_PWD"

exec zsh

echo "------------------------------------------------"
echo "Done!"

