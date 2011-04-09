#Basic setup#

    > ssh root@173.255.238.90

    # add a user named deploy
    $ adduser deploy

    # privide sudo access to this user
    $ visudo

    # Go to the end of file and add the following line .
    $ deploy ALL=(ALL) ALL

Henceforth always login as rails.
If you need sudo access then just do <tt>sudo -i</tt>

#ssh setup#

    > ssh deploy@173.255.238.90

    # make sure that you are logged in as deploy
    $ whoami #=> deploy

    # generate ssh keys for the box
    $ ssh-keygen -t rsa

    # create authorized_keys file
    $ cd .ssh
    $ touch authorized_keys

    # send macbook public key to server
    > ssh deploy@173.255.238.90  'cat >> .ssh/authorized_keys' < ~/.ssh/id_rsa.pub

    # change owner
    $ chown -R deploy:deploy /home/deploy/.ssh

    # change permission
    $ chmod 700 /home/deploy/.ssh
    $ chmod 600 /home/deploy/.ssh/authorized_keys

    # add public key to github
    $ cat id_rsa.pub #=> add the output as a key in your github account

#build the machine#

    $ sudo dpkg-reconfigure tzdata
    $ sudo apt-get -y update
    $ sudo apt-get -y upgrade

    # followling line should be a single command
    $ sudo apt-get -y install apache2 apache2-prefork-dev autoconf bison build-essential curl git-core imagemagick libapr1-dev libaprutil1-dev libcurl4-openssl-dev libid3-3.8.3-dev libmysqlclient16 libmysqlclient16-dev libreadline6 libreadline6-dev libsqlite3-0 libsqlite3-dev libssl-dev libxml2-dev libxslt-dev libyaml-dev mysql-client mysql-common mysql-server openssl sqlite3 zlib1g zlib1g-dev

    # download ree
    $ wget http://rubyforge.org/frs/download.php/71096/ruby-enterprise-1.8.7-2010.02.tar.gz

    # untar and unzip
    $ tar zxvf ruby-enterprise-1.8.7-2010.02.tar.gz

    # finally install it
    $ sudo ./ruby-enterprise-1.8.7-2010.02/installer

    # make ruby irb gem rake and rails available everywhere
    $ sudo ln -s /opt/ruby-enterprise-1.8.7-2010.02/bin/ruby /usr/local/bin/ruby
    $ sudo ln -s /opt/ruby-enterprise-1.8.7-2010.02/bin/irb /usr/local/bin/irb
    $ sudo ln -s /opt/ruby-enterprise-1.8.7-2010.02/bin/gem /usr/local/bin/gem
    $ sudo ln -s /opt/ruby-enterprise-1.8.7-2010.02/bin/rake /usr/local/bin/rake
    $ sudo ln -s /opt/ruby-enterprise-1.8.7-2010.02/bin/rails /usr/local/bin/rails

    # ensure no-ri no-rdoc
    $ echo "gem: --no-ri --no-rdoc" >> ~/.gemrc

    # install and make bundle available everywhere
    $ sudo gem install bundler
    $ sudo ln -s /opt/ruby-enterprise-1.8.7-2010.02/bin/bundle /usr/local/bin/bundle

    # install and make whenever
    $ sudo gem install whenever
    $ sudo ln -s /opt/ruby-enterprise-1.8.7-2010.02/bin/whenever /usr/local/bin/whenever


Note that above installation will only work with <tt>mysql</tt> and not with <tt>mysql2</tt> .

If you need to edit mysql configuration then do <tt>sudo vi /etc/mysql/my.cnf</tt> .

To restart mysql do <tt>sudo /etc/init.d/mysql restart</tt> .

    $ mysql -u root -p
    $ show engines;

The result of above command should list <tt>InnoDB</tt> and it should say <tt>YES</tt> for support.

#make app capistrano aware#

    # add following two gems to Gemfile for development enviroment
    gem 'capistrano'
    gem 'capistrano-ext'

    > capify .
    > mkdir deploy
    > cd deploy
    > touch production.rb
    > touch staging.rb
    > # copy relevant files from existing project
    > cap production deploy:setup
    > cap production deploy
    > cap production deploy:migrate

Fill in rest of data by copying from other project.

#install apache#

    # install apache
    $ sudo aptitude install apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 ssl-cert

    # find if mod_rewrite is enabled or not. If the result of the below command does not list rewrite then
    # mod_rewrite is not enabled
    $ ls /etc/apache2/mods-enabled/re*

    # find if mod_rewrite is available. If the output of the below command lists rewrite then it means
    # mod_rewrite is available
    # ls /etc/apache2/mods-available/rew*

    # enable mod_rewrite
    $ cd /etc/apache2
    $ sudo a2enmod rewrite

    # enable expires
    $ cd /etc/apache2
    $ sudo a2enmod expires

    # restart apache
    $ sudo apache2ctl graceful

    # error log resides at
    $ /var/log/apache2/error.log

    # reload after making configuration changes
    $ sudo /etc/init.d/apache2 reload

    # make configuration changes
    $ sudo vi /etc/apache2/apache2.conf

    # example virtual host configuration
    <VirtualHost *:80>
          ServerName hamarabox.com
          ServerAlias www.hamarabox.com
          DocumentRoot /home/deploy/apps/hamarabox_production/current/public
          <Directory /home/deploy/apps/hamarabox_production/current/public>
             AllowOverride all
             Options -MultiViews
          </Directory>
            # enable gzip compression
            AddOutputFilterByType DEFLATE text/html text/plain text/css text/javascript application/x-javascript text/xml

            # cache asset files for 1 month
            ExpiresActive On
            ExpiresByType image/gif "access plus 1 month"
            ExpiresByType image/png "access plus 1 month"
            ExpiresByType image/jpeg "access plus 1 month"
            ExpiresByType text/css "access plus 1 month"
            ExpiresByType text/javascript "access plus 1 month"
            ExpiresByType application/x-javascript "access plus 1 month"

            # no www
            RewriteEngine On
            RewriteCond %{HTTP_HOST} ^www\.(.+)$ [NC]
            RewriteRule ^(.*)$ http://%1$1 [R=301,L]
       </VirtualHost>


#secure ssh#

    $ sudo vi /etc/ssh/sshd_config

    # Find line "Port 22" and change that to 30000.
    # You can pick any number you want

    # It is a common security practice to not to allow root to ssh into the box.
    # Find the PermitRootLogin line and change it from yes to no to stop root from sshing into the box.

    # reload the changes
    $ sudo /etc/init.d/ssh reload

#install RMagick#

    $ sudo apt-get install imagemagick
    $ sudo apt-get install libmagick9-dev
    $ sudo gem install rmagick

    $ irb
    irb(main):001:0> require 'rubygems'
    => true
    irb(main):002:0> require 'RMagick'
    => true

