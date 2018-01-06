CREATE TABLE `groups` (
  `groupname` varchar(30) NOT NULL,
  `gid` int(11) NOT NULL,
  `members` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `users` (
  `userid` varchar(30) NOT NULL,
  `passwd` varchar(80) NOT NULL,
  `uid` int(11) DEFAULT NULL,
  `gid` int(11) DEFAULT NULL,
  `homedir` varchar(255) DEFAULT NULL,
  `shell` varchar(255) DEFAULT NULL,
  UNIQUE KEY `userid` (`userid`),
    KEY `users_userid_idx` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
