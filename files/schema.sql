CREATE USER 'app'@'%' IDENTIFIED BY 'supersecret';
GRANT ALL ON *.* TO 'app'@'%';

CREATE DATABASE acmecorp;
USE acmecorp;

CREATE TABLE images (
  id tinyint NOT NULL AUTO_INCREMENT,
  local_path varchar(255),
  created_at datetime,
  PRIMARY KEY (ID)
);

FLUSH PRIVILEGES;
