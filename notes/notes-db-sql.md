

# MySQL

mysql -u root -p
pw is "pw"


mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'PW';

https://dev.mysql.com/doc/mysql-getting-started/en/
create database pets;
show databases;
use pets
CREATE TABLE cats
(
  id              INT unsigned NOT NULL AUTO_INCREMENT, # Unique ID for the record
  name            VARCHAR(150) NOT NULL,                # Name of the cat
  owner           VARCHAR(150) NOT NULL,                # Owner of the cat
  birth           DATE NOT NULL,                        # Birthday of the cat
  PRIMARY KEY     (id)                                  # Make the id the primary key
);
show tables;
describe cats;
INSERT INTO cats ( name, owner, birth) VALUES
  ( 'Sandy', 'Lennon', '2015-01-03' ),
  ( 'Cookie', 'Casey', '2013-11-13' ),
  ( 'Charlie', 'River', '2016-05-21' );
select * from cats;
select name from cats where owner = 'Casey';

## information_schema examples
select * from information_schema.tables;
show databases

select column_name, data_type from information_schema.columns
where table_name='cats' and table_schema='pets'


## Connection
mysql://root:PW@127.0.0.1:3306/pets
mysql://root:PW@127.0.0.1:3306/air_routes

use DBUIFindBuffer to set the g:db variable for a buffer (needed to issue queries)

## Completion
https://github.com/kristijanhusak/vim-dadbod-completion

## UI
https://github.com/kristijanhusak/vim-dadbod-ui/blob/master/README.md

help

## Functions
echo db_ui#query({query})
echo db_ui#query( 'select * from cats' )

select * from information_schema.`TABLES`;

select * from cats
show tables
use pets
use air_routes
where name='Cookie'
select name, owner from cats;




