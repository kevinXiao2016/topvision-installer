use mysql;
update user set Host = '1.1.1.1' where Host = '%';
update user set Host = '%' where Host = 'localhost';