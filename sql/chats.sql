CREATE DATABASE IF NOT EXISTS `chats`;

USE `chats`;

CREATE TABLE IF NOT EXISTS `roles`(
  `role_id` int NOT NULL,
  `role` varchar(10) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `chats` (
  `chat_id` int NOT NULL AUTO_INCREMENT,
  `content` text NOT NULL,
  `role_id` int NOT NULL,
  `user_id` int NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`chat_id`),
  CONSTRAINT `fk_roles_chats` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `roles` (`role_id`, `role`)
VALUES
  (1, 'system'),
  (2, 'assistant'),
  (3, 'user');

