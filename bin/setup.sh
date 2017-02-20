#!/bin/sh
RUBY_VERSION='2.3.1'
HOME_DIR='/home/vagrant'

# set locale, keymap, timezone
sudo localectl set-locale LANG=ja_JP.utf8
sudo localectl set-keymap jp106
sudo timedatectl set-timezone Asia/Tokyo

# install ruby
sudo yum -y update
sudo yum -y install git-all openssl-devel readline-devel sqlite gcc gcc-c++
git clone git://github.com/sstephenson/rbenv.git ${HOME_DIR}/.rbenv
git clone git://github.com/sstephenson/ruby-build.git ${HOME_DIR}/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ${HOME_DIR}/.bashrc
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ${HOME_DIR}/.bashrc
echo 'eval "$(rbenv init -)"' >> ${HOME_DIR}/.bashrc
echo 'gem: --no-ri --no-rdoc' > ${HOME_DIR}/.gemrc
source ${HOME_DIR}/.bashrc
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
gem install bundler

# install nodejs
sudo rpm -Uvh https://rpm.nodesource.com/pub_4.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm
sudo yum -y install nodejs

# install postgresql
# https://www.postgresql.org/download/linux/redhat/#yum
sudo yum -y install http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-redhat95-9.5-2.noarch.rpm
sudo yum -y install postgresql-devel postgresql95-server postgresql95-contrib
sudo /usr/pgsql-9.5/bin/postgresql95-setup initdb
sudo systemctl start postgresql-9.5.service
sudo systemctl enable postgresql-9.5.service
