##########################################################################
# to install on a new system copy this file to home and run it:
# bash -c "$(curl https://raw.githubusercontent.com/smashingcookie/dotfiles/main/.install_dotfiles.sh)"

# inspired by: https://www.atlassian.com/git/tutorials/dotfiles
##########################################################################


##########################################################################
# install some pyenv requirements as recommended per documentation:
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
# TODO => clean again, no longer needed.

# required for non-interactive apt-get:
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

sudo apt-get update
# use tzdata rather than timedatectl - timedatectl is lacking in some docker images
sudo TZ=Europe/Berlin apt-get install -y --no-install-recommends tzdata
sudo apt-get update && sudo apt-get install -y --no-install-recommends \

# required for non-interactive apt-get:
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

sudo apt-get update
# use tzdata rather than timedatectl - timedatectl is lacking in some docker images
sudo TZ=Europe/Berlin apt-get install -y --no-install-recommends tzdata
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

# git-delta, for ubuntu24.04 plus possible via apt too
# see also https://dandavison.github.io/delta/introduction.html
wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb"
sudo dpkg -i git-delta_0.18.2_amd64.deb
rm git-delta_0.18.2_amd64.deb

# git config
git config --global user.name "smashingcookie"
git config --global credential.helper "cache --timeout=3600"
git config --global pull.rebase true
git config --global push.rescurseSubmodules check
# git config for delta
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default
git config --global delta.hyperlinks true
git config --global delta.hyperlinks-file-link-format "vscode://file/{path}:{line}"

##########################################################################
# setup tmux plugins
git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install oh-my-zsh
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

sudo chsh -s $(which zsh)

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

export MYZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
# powerlevel10k theme
mkdir -p ~/.local/share/fonts # install fonts for powerlevel10k
cd ./local/share/fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
cd -
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${MYZSH_CUSTOM}/themes/powerlevel10k

# Install k plugin
git clone --depth=1 https://github.com/supercrabtree/k $MYZSH_CUSTOM/plugins/k
# Install bat plugin
git clone --depth=1 https://github.com/fdellwing/zsh-bat.git $MYZSH_CUSTOM/plugins/zsh-bat
# install zsh-autosuggestions plugin
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${MYZSH_CUSTOM}/plugins/zsh-autosuggestions
# install fzf-zsh-plugin
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${MYZSH_CUSTOM}/plugins/fzf-zsh-plugin

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
# - uv
# - vscode
# - ccache
# - conan
# - cmake
# - ssh setup
# - gpg agent setup
