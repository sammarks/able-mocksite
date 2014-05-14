FROM ubuntu:14.04

# Install Dependencies
RUN apt-get update -y
RUN apt-get install -y git curl nginx php5 php5-fpm php5-mysql php5-mcrypt drush

# Install Composer
RUN /usr/bin/curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer

# Install Able Core CLI
RUN /usr/bin/git clone https://github.com/sammarks/able /usr/local/able
WORKDIR /usr/local/able
RUN /usr/bin/composer install
RUN ln -s /usr/local/able/able /usr/bin/able
RUN chmod a+x /usr/bin/able

# Install Application
RUN mkdir -p /opt/repo
ADD . /opt/repo

# Tell Able Core to install the website.
RUN /usr/bin/able site:install /opt/repo

EXPOSE 80

# Install Supervisor
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout

RUN /usr/local/bin/supervisord -n
