
## vim DBUI
:DBUI  needs to :DBUIFindBuffer of a .sql file
`gei` evaluates paragraphs
initially the DB is empty. you first need to create data with ->
localhost:8080/docs
try -> execute to create party, then vote and find the person, vote and party in the DB!

more maps and scripts: 
/.config/nvim/plugin/tools_db.vim#/nnoremap%20<silent>%20<leader>du

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

# mycli
mycli mysql://root:PW@127.0.0.1:3306/pets
mycli mysql://root:PW@127.0.0.1:3306/air_routes

https://www.mycli.net/commands
/Users/at/.myclirc

\dt    - list tables
\dt airports - list columns in a table
+----------------------+
| Tables_in_air_routes |
+----------------------+
| airports             |
| continents           |
| countries            |
| iroutes              |
| routes               |
+----------------------+

## air_ports
+-----------+-------------+------+-----+---------+-------+
| Field     | Type        | Null | Key | Default | Extra |
+-----------+-------------+------+-----+---------+-------+
| ID        | int         | NO   | PRI | <null>  |       |
| IATA      | char(3)     | NO   |     | <null>  |       |
| ICAO      | char(4)     | NO   |     | <null>  |       |
| CITY      | varchar(50) | YES  |     | <null>  |       |
| DESCR     | varchar(80) | YES  |     | <null>  |       |
| REGION    | varchar(6)  | YES  |     | <null>  |       |
| COUNTRY   | char(2)     | NO   | MUL | <null>  |       |
| RUNWAYS   | int         | NO   |     | <null>  |       |
| LONGEST   | int         | NO   |     | <null>  |       |
| ALTITUDE  | int         | NO   |     | <null>  |       |
| CONTINENT | char(2)     | NO   | MUL | <null>  |       |
| LAT       | double      | NO   |     | <null>  |       |
| LON       | double      | NO   |     | <null>  |       |
+-----------+-------------+------+-----+---------+-------+

## iroutes
+-------+---------+------+-----+---------+-------+
| Field | Type    | Null | Key | Default | Extra |
+-------+---------+------+-----+---------+-------+
| SRC   | char(3) | NO   | PRI | <null>  |       |
| DEST  | char(3) | NO   | PRI | <null>  |       |
| DIST  | int     | NO   |     | <null>  |       |
+-------+---------+------+-----+---------+-------+


mysql_config_editor set --login-path=local --host=localhost --user=username --password
https://dev.mysql.com/doc/refman/5.6/en/mysql-config-editor.html








