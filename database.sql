CREATE DATABASE vocaloid;

USE vocaloid;

CREATE TABLE artist (id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,name VARCHAR(32),birthday DATE);

INSERT INTO artist (id, name, birthday) VALUES (1, '初音ミク', '2007-08-31');

INSERT INTO artist (id, name, birthday) VALUES (2, '鏡音リン', '2007-12-27');

INSERT INTO artist (id, name, birthday) VALUES (3, '鏡音レン', '2007-12-27');

INSERT INTO artist (id, name, birthday) VALUES (4, '巡音ルカ', '2009-01-30');

INSERT INTO artist (id, name, birthday) VALUES (5, '重音テト', '2008-04-01');

