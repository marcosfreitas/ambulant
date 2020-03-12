#!/usr/bin/env bash

author="Yuri Koster, Marcos Freitas"
version="3.10.0"
manual_version="1.0.3"

# @todo Review and Add security rules
# @todo Review function to install SSL with let's encrypt
# @todo separe functions as files of configurations into folders

# @changelog
# 3.10.0 - Added flag to stop interactive mode when somenthing happens. Interactive mode disabled affect the function PressKeyToContinue, ignoring the flag "continue".

# global variables
#DIR="${BASH_SOURCE%/*}"
DIR="${BASH_SOURCE[0]}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

development=false
interactive_mode=true
usage_instructions="Usage: ./configurations.sh -i {node|nginx|php|all} {-d} {-I {true|false}} { -p {7.3|7.2|5.6|all} }"
OKN_HOSTS_PHP_VERSION="${OKN_HOSTS_PHP_VERSION:-7.2}"

# including functions.sh file
source "$DIR/functions.sh"

# Add necessary repos
function AddRepositories() {
  {
    AptUpdate 'upgrade'

    Separator "Ativando repositórios extras para o Ubuntu 16.04 64 Bits"

    apt-get install -y software-properties-common apt-transport-https gnupg2

    Separator "ativando os repositórios Universe e Multiverse" ${LIGHT_GREEN}

    add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ bionic universe multiverse" &&
      echo -ne "\n" | add-apt-repository ppa:ondrej/php &&
      echo -ne "\n" | add-apt-repository ppa:ondrej/nginx &&
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C &&
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C

    AptUpdate 'upgrade'

    apt-get -y auto-remove

  } || {

    Count $1 'AddRepositories'

  }
}

# Add and Enable virtual host files
# For each site hosted in this server, you should create a individual file for its virtual host
# - into the folder "/etc/nginx/sites-available", then enable the site creating a simbolic link into "/etc/nginx/site-enabled"
function AddVirtualHostFiles() {
  {

    Separator "Ajustando arquivo do VirtualHost do projeto:"

    cp $DIR/nginx/vhost/vhost-app.conf /etc/nginx/sites-available/app
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bkp
    cp $DIR/nginx/vhost/nginx.conf /etc/nginx/nginx.conf

    cp -r $DIR/nginx/vhost/snippets /etc/nginx
    cp -r $DIR/nginx/vhost/php /etc/nginx/

    ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/

    # file doesn't exist
    #rm /etc/nginx/sites-enabled/default;

  } || {
    Count $1 'AddVirtualHostFiles'
  }
}

# Configuring virtual host folders
# protect folders giving access only to the process of nginx
function AdjustVirtualHostFolders() {
  {
    Separator "Ajustando diretórios do VirtualHost do projeto:"

    # site
    mkdir -p /var/www/html &&
      chmod 755 /var/www &&
      chmod 2755 /var/www/html &&
      chown -R www-data:www-data /var/www

    # app
    mkdir -p /var/www/app &&
      chmod 755 /var/www &&
      chmod 2755 /var/www/app &&
      chown -R www-data:www-data /var/www

  } || {
    Count $1 'AdjustVirtualHostFolders'
  }
}

# Install some software dependencies packages
# @version 1.0.1
function InstallSoftwareDependencies() {
  {
    Separator "Instalando dependências de software comuns durante o desenvolvimento"

    apt-get -y install composer

    export COMPOSER_HOME="$HOME/.config/composer"

  } || {
    Count $1 'InstallSoftwareDependencies'
  }
}

Separator "For Ubuntu 16.04 64-Bit | Version $version based on 'Manual de Infraestrutura' $manual_version | Author: $author" ${CYAN}
Separator "As configurações de SSL não estão inclusas neste processo" ${YELLOW}

# working with the arguments received
while getopts 'i:dp:I:' opt; do
  case "${opt}" in
  d)
    development=true
    ;;
  p)
    OKN_HOSTS_PHP_VERSION=${OPTARG}
    ;;
  I)
    interactive_mode=${OPTARG}
    ;;
  i)
    install=${OPTARG}
    ;;
  :)
    echo "Invalid option: ${OPTARG} requires an argument" 1>&2
    ;;
  \?)
    echo "Invalid call"
    echo $usage_instructions
    exit 0
    ;;
  *)
    echo $usage_instructions
    ;;
  esac
done
shift $((OPTIND - 1))

if [ -z "$install" ]; then
  Separator "Argumento de instalação necessário. ${usage_instructions}" ${RED}
  exit
fi

AptUpdate
AddExtraPackages 1

# Advises

if [ $development == false ]; then
  Separator "Modo de produção escolhido" ${YELLOW}
else
  Separator "Modo de desenvolvimento escolhido" ${YELLOW}
fi

if [ $interactive_mode == false ]; then
  Separator "Modo interativo desativado, algumas operações podem ser puladas..." ${YELLOW}
fi

if [[ $install == "nginx" || $install == "all" || $install == "node"  ]]; then
  source "$DIR/ubuntu/nginx/install.sh"
  source "$DIR/ubuntu/nginx/git.sh"
fi
if [[ $install == "node" ]]; then
  source "$DIR/ubuntu/node/install.sh"
fi
if [[ $install == "php" || $install == "all" ]]; then
  if [[ $OKN_HOSTS_PHP_VERSION == "7.3" || $OKN_HOSTS_PHP_VERSION == "all" ]]; then
    source "$DIR/ubuntu/php/7.3.sh"
  fi
  if [[ $OKN_HOSTS_PHP_VERSION == "7.2" || $OKN_HOSTS_PHP_VERSION == "all" ]]; then
    source "$DIR/ubuntu/php/7.2.sh"
  fi
  if [[ $OKN_HOSTS_PHP_VERSION == "5.6" || $OKN_HOSTS_PHP_VERSION == "all" ]]; then
    source "$DIR/ubuntu/php/5.6.sh"
  fi
fi

if [[ $install == "node" ]]; then
  InstallNodeJS 1
fi


if [[ $install == "nginx" || $install == "all"  || $install == "node" ]]; then
  if [ $development == false ]; then
    InstallUFW 1
  fi

  # Calling all methods passing 1 as a initial value to counter;
  InstallNginx 1

  AddVirtualHostFiles 1
  InitializeGit 1
  # @bug Compiled Module not working
  # CompileNginxModules 1;
  AdjustVirtualHostFolders 1
  ProtectProjectDirectories 1
fi
if [[ $install == "node" || $install == "all" ]]; then
  ConfigureNodeJSNginxProxy 1
  IntallRequiredNPMpackages 1
fi
if [[ $install == "php" || $install == "all" ]]; then
  AddRepositories 1
  if [[ $OKN_HOSTS_PHP_VERSION == "7.3" ]]; then
    InstallPHP 1
  fi
  if [[ $OKN_HOSTS_PHP_VERSION == "7.2" ]]; then
    InstallPHP7_2 1
    ChangePHPConf_7_2 1
  fi
  if [[ $OKN_HOSTS_PHP_VERSION == "5.6" ]]; then
    InstallPHP5_6 1
    ChangePHPConf_5_6 1
  fi
  if [[ $OKN_HOSTS_PHP_VERSION == "all" ]]; then
    InstallPHP 1
    InstallPHP7_2 1
    InstallPHP5_6 1
  fi

  InstallSoftwareDependencies 1

  #if [ $development == false ]; then
    # @bug Compiled Module not working
    #InstallModSecurity 1
    #InstallOWASPCRS 1
  #fi
fi

if [ $development == false ]; then
  Security 1
  Fail2Ban 1
fi

if [[ "${install}" != "php" && "${install}" != "nginx" && "${install}" != "all" && "${install}" != "node" ]]; then
  echo "Invalid option for install: ${install}" 1>&2
else
  Separator "Processo de configuração concluído aparentemente com sucesso ;)." ${CYAN}
fi
