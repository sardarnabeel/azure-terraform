#!/bin/bash
sudo apt update -y
sudo apt install  mysql-server -y
sudo systemctl start mysql.service
sudo apt-get install unzip
sudo mysql -h localhost -u root <<EOF
create database wordpress;
CREATE USER 'wordpressuser'@'%' IDENTIFIED BY 'wordpresspassword';
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, INDEX, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'wordpressuser'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'wordpressuser'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql 