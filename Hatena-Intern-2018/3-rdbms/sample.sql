CREATE TABLE IF NOT EXISTS daimyo (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(32) NOT NULL,
  `birthday` DATE NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (name)
);

CREATE TABLE IF NOT EXISTS servant (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `daimyo_id` BIGINT UNSIGNED NOT NULL,
  `name` VARCHAR(32) NOT NULL,
  `birthday` DATE NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (name)
);

-- 注: 生年月日不詳のものは1月1日生まれとしている

INSERT INTO daimyo (id, name, birthday) VALUES
    (1, '織田信長', '1534-06-23'),
    (2, '徳川家康', '1543-01-31'),
    (3, '武田信玄', '1521-12-01'),
    (4, '上杉謙信', '1530-02-18');

INSERT INTO servant (id, daimyo_id, name, birthday) VALUES
    (1,  1, '木下藤吉郎', '1534-06-23'),
    (2,  2, '井伊直政',   '1561-03-04'),
    (3,  1, '前田利家',   '1539-01-15'),
    (4,  1, '丹羽長秀',   '1535-10-16'),
    (5,  2, '本多忠勝',   '1548-03-17'),
    (6,  2, '榊原康政',   '1548-01-01'),
    (7,  2, '酒井忠次',   '1527-01-01'),
    (8,  1, '柴田勝家',   '1522-01-01'),
    (9,  1, '滝川一益',   '1525-01-01'),
    (10, 2, '石川数正',   '1533-01-01'),
    (11, 3, '真田昌幸',   '1547-01-01'),
    (12, 4, '直江景綱',   '1509-01-01');
