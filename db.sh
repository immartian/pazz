#!/bin/sh
sqlite3 pass.db <<EOF
create table n (id INTEGER PRIMARY KEY,u TEXT,p TEXT,s TEXT);
insert into n (u,p,s) values ('john','awsere&DFS','Google');
insert into n (u,p,s) values ('im@quantalucia.com','bbaasd&DFS','Binance');
select * from n;
EOF
