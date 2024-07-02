FROM php:8.3.8-apache-bookworm 
    #https://github.com/docker-library/docs/tree/master/php
LABEL maintainer="tux-box@github"
LABEL version=1.0
LABEL description="This is a container to run DayZ private hive tools, you must use an existing/external DB!"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install curl unzip -y
#RUN git config --global core.symlinks false

RUN docker-php-ext-install mysqli 
    #https://github.com/mlocati/docker-php-extension-installer
    #download the PHT
ADD https://github.com/n8m4re/PrivateHiveTools.git /tmp/PHT
    #download the maps
RUN curl https://downloads.n8m4re.com/arma2_dayz/maps.zip -o /tmp/PHT/maps.zip
    #unzip the maps
RUN unzip /tmp/PHT/maps.zip -d /tmp/PHT/PrivateHiveTools/    
    #make our website directory.
RUN mv /tmp/PHT/PrivateHiveTools /pht
    #setup apache
COPY pht.conf /etc/apache2/sites-available/pht.conf
RUN a2ensite pht.conf

EXPOSE 80
EXPOSE 443

#Do we do dedicated containers and link them or all in one app services?
    #setup mariadb https://github.com/MariaDB/mariadb-docker/blob/11135d071fd1fe355b1f7fa99b9d3b4a59bb5225/11.5/Dockerfile
# RUN groupadd -r mysql && useradd -r -g mysql mysql --home-dir /var/lib/mysql
    #setup phpmyadmin https://docs.phpmyadmin.net/en/latest/setup.html
    # https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-with-apache-on-a-centos-7-server

# Have something run, apache2 php with pht
CMD [“apache2ctl”, “-D”, “FOREGROUND”]