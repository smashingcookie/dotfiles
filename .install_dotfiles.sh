git clone --bare https://github.com/smashingcookie/dotfiles.git $HOME/.dotfiles
function config {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no


#install some pyenv requirements as recommended per documentation:
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
sudo apt-get update && install \
  make \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  llvm \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev

# Install pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

# Intall k plugin
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
git clone https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k

# possible todos:
# - install direnv on host (apt-get install direnv)
# - any requirements for other used plugins?
# - ccache
# - conan
# - cmake
# - vscode
# - htop
# - ssh setup
# - gpg agent setup
# - artifactory keys, e.g. dvc, conan, lfs?
# - enable tmux plugin, setup tmux conf (below)

#############################################################################################
# # Install powerline fonts (to use with tmux-config)
# # ---
# cd /tmp
# git clone https://github.com/powerline/fonts.git --depth=1
# cd fonts
# ./install.sh
# # clean-up a bit
# cd ..
# rm -rf fonts

# # Install tmux-config
# # ---
# cd ~/.tmux-config
# # Patch tmux config for compatibility with tmux 3
# # see https://github.com/samoshkin/tmux-config/pull/31 for details
# curl -L https://patch-diff.githubusercontent.com/raw/samoshkin/tmux-config/pull/31.patch > /tmp/tmuxFix.patch
# git apply /tmp/tmuxFix.patch
# rm /tmp/tmuxFix.patch
# ./install.sh