##########################################################################
# to install on a new system copy this file to home and run it:
# bash -c "$(curl https://raw.githubusercontent.com/smashingcookie/dotfiles/main/.install_dotfiles.sh)"

# inspired by: https://www.atlassian.com/git/tutorials/dotfiles
##########################################################################


##########################################################################
# install some pyenv requirements as recommended per documentation:
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment

# required for non-interactive apt-get:
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

sudo apt-get update
sudo TZ=Etc/UTC apt-get install -y --no-install-recommends tzdata
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
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

##########################################################################
# additional dev env prerequisites
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
  ca-certificates \
  bat \
  direnv \
  ripgrep \
  git \
  tmux \
  zsh

##########################################################################
# setup tmux plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install pyenv
git clone --depth=1 https://github.com/pyenv/pyenv.git ~/.pyenv
git clone --depth=1 https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

# install oh-my-zsh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

sudo chsh -s $(which zsh)

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
# Install k plugin
git clone --depth=1 https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k
# Install bat plugin
git clone --depth=1 https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat

##########################################################################
# checkout dotfiles (setup 'config' repo)
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

# set apt-get to interactive again:
echo 'debconf debconf/frontend select Dialog' | sudo debconf-set-selections
##########################################################################
# possible todos:
# - any requirements for other used plugins?
# - ccache
# - conan
# - cmake
# - vscode
# - ssh setup
# - gpg agent setup
# - switch to powerline10k theme