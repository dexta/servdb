DROP TABLE IF EXISTS `servtable`;
    
CREATE TABLE `servtable` (
  `key` VARCHAR(3072) NOT NULL,
  `value` VARCHAR(3072) NOT NULL,
  PRIMARY KEY (`key`)
);

DROP TABLE IF EXISTS `usertoken`;
    
CREATE TABLE `usertoken` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(64) NOT NULL,
  `tokenstring` CHAR(64) NOT NULL,
  PRIMARY KEY (`id`)
);

DROP TABLE IF EXISTS `history`;
    
CREATE TABLE `history` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `key` VARCHAR(3072) NOT NULL,
  `value` VARCHAR(3072) NOT NULL,
  PRIMARY KEY (`id`)
);
