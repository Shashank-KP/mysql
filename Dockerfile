FROM mysql:5.7

COPY ./liferayPortal_uat.sql /home/liferayPortal_uat.sql

RUN /bin/bash -c "/etc/init.d/mysql start" && \
  sleep 60
  
RUN \
  /etc/init.d/mysql -u root -e "SET GLOBAL max_allowed_packet=1073741824" && \
  /etc/init.d/mysql -u root -e "CREATE DATABASE liferayPortal" && \
  /etc/init.d/mysql -u root -e "CREATE DATABASE gallery3" && \
  /etc/init.d/mysql -u root -e "CREATE USER 'portalUser' IDENTIFIED WITH mysql_native_password BY 'root@lad#36'" && \
  /etc/init.d/mysql -u root -e "GRANT ALL PRIVILEGES ON liferayPortal.* TO 'portalUser'@'%' WITH GRANT OPTION" && \
  /etc/init.d/mysql -u root -e "CREATE USER 'gallery3admin' IDENTIFIED WITH mysql_native_password BY 'root@lad#36'" && \
  /etc/init.d/mysql -u root -e "GRANT ALL PRIVILEGES ON gallery3.* TO 'gallery3admin'@'%' WITH GRANT OPTION" && \
  /etc/init.d/mysql -u root -e FLUSH PRIVILEGES && \
  /etc/init.d/mysql -u root liferayPortal /home/liferayPortal_uat.sql

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
