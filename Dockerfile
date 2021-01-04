#
# MySQL Dockerfile
#
# https://github.com/dockerfile/mysql
#

# Pull base image.
FROM centos:7


ENV MYSQL_USER=mysql \
    MYSQL_VERSION=5.7.26 \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql
    
    
# Install MySQL.
#RUN \
#  apt-get update && \
#  DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && \
#  rm -rf /var/lib/apt/lists/* && \
#  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
#  sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
#  echo "mysqld_safe &" > /tmp/config && \
#  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
#  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
#  bash /tmp/config && \
#  rm -f /tmp/config

RUN apt-get update \
 && apt-get install -y curl apt-utils wget unzip\
 && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server=${MYSQL_VERSION}* \
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*

COPY ./liferayPortal_uat.sql /home/liferayPortal_uat.sql

RUN SET GLOBAL max_allowed_packet=1073741824

RUN \
  mysql -u root -e "CREATE DATABASE liferayPortal" && \
  mysql -u root -e "CREATE DATABASE gallery3" && \
  mysql -u root -e "CREATE USER 'portalUser' IDENTIFIED WITH mysql_native_password BY 'root@lad#36'" && \
  mysql -u root -e "GRANT ALL PRIVILEGES ON liferayPortal.* TO 'portalUser'@'%' WITH GRANT OPTION" && \
  mysql -u root -e "CREATE USER 'gallery3admin' IDENTIFIED WITH mysql_native_password BY 'root@lad#36'" && \
  mysql -u root -e "GRANT ALL PRIVILEGES ON gallery3.* TO 'gallery3admin'@'%' WITH GRANT OPTION" && \
  mysql -u root -e FLUSH PRIVILEGES && \
  mysql -u root liferayPortal /home/liferayPortal_uat.sql

#RUN /bin/bash -c "/usr/bin/mysqld_safe --skip-grant-tables &" && \
#  sleep 5 && \
#  mysql -u root -e "CREATE DATABASE mydb" && \
#  mysql -u root mydb < /tmp/dump.sql


# Define mountable directories.
VOLUME ["/etc/mysql", "/var/lib/mysql"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["mysqld_safe"]

# Expose ports.
EXPOSE 3306
