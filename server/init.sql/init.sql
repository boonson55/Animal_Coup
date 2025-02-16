-- ตั้งค่า Character Set เป็น utf8mb4_general_ci สำหรับ Database
CREATE DATABASE IF NOT EXISTS project_coup 
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

USE project_coup;

-- ตั้งค่า Timezone เป็น Asia/Bangkok
SET time_zone = '+07:00';

-- ตาราง users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    player_name VARCHAR(10) NULL,
    username VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(30) NOT NULL UNIQUE,
    permission VARCHAR(6) NOT NULL,
    usage_status BOOLEAN NOT NULL DEFAULT 0,
    last_login TIMESTAMP NULL DEFAULT NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

INSERT INTO users (player_name, username, password, email, permission) VALUES ('admin', 'admin', '$argon2id$v=19$m=65536,t=3,p=1$ov/r5q5iT+yrYj5s5JDOJA$YxTsy8aPux8MGJIni2jHWQWiNqNtuUTpZWd7YPuFx7g', 'admin@admin.com', 'admin');
INSERT INTO users (player_name, username, password, email, permission) VALUES ('admin2', 'admin2', '$argon2id$v=19$m=65536,t=3,p=1$ov/r5q5iT+yrYj5s5JDOJA$YxTsy8aPux8MGJIni2jHWQWiNqNtuUTpZWd7YPuFx7g', 'admin2@admin2.com', 'admin');
INSERT INTO users (player_name, username, password, email, permission) VALUES ('test', 'test', '$argon2id$v=19$m=65536,t=3,p=1$ZLzLRa17Zhe4AjF8LMVPJg$mPfvsqYINEKb7wIICShELJmN/0iZBtfoWTXZz4jt8Ws', 'test@test.com', 'member');
INSERT INTO users (player_name, username, password, email, permission) VALUES ('member', 'member', '$argon2id$v=19$m=65536,t=3,p=1$Sv3tV/IjmHKzzNAhU8DWzw$b6Mr9/WuhwCE6ECTFtChqdNRSFjqS3CndrNhyxb+EUw', 'member@member.com', 'member');
INSERT INTO users (player_name, username, password, email, permission) VALUES ('member2', 'member2', '$argon2id$v=19$m=65536,t=3,p=1$Sv3tV/IjmHKzzNAhU8DWzw$b6Mr9/WuhwCE6ECTFtChqdNRSFjqS3CndrNhyxb+EUw', 'member2@member2.com', 'member');

-- ตาราง user_stats
CREATE TABLE user_stats (
    user_id INT PRIMARY KEY,
    game_count INT DEFAULT 0,
    game_win INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

INSERT INTO user_stats (user_id, game_count, game_win) VALUES ('3','5','4');
INSERT INTO user_stats (user_id, game_count, game_win) VALUES ('4','4','2');
INSERT INTO user_stats (user_id, game_count, game_win) VALUES ('5','5','3');

-- ตาราง user_bans
CREATE TABLE user_bans (
    user_id INT PRIMARY KEY,
    ban_status BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

INSERT INTO user_bans (user_id) VALUES ('3');
INSERT INTO user_bans (user_id) VALUES ('4');
INSERT INTO user_bans (user_id) VALUES ('5');

-- ตาราง banned_lists
CREATE TABLE banned_lists (
    user_id INT PRIMARY KEY,
    unban_date TIMESTAMP NULL DEFAULT NULL,
    banned_reason VARCHAR(24) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- ตาราง rooms
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    player_count INT NOT NULL DEFAULT 1,
    play_status VARCHAR(14) NOT NULL,
    room_status BOOLEAN NOT NULL DEFAULT 0,
    pwd_room VARCHAR(6) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- ตาราง room_players
CREATE TABLE room_players (
    roomp_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT,
    user_id INT NULL,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- ตาราง games
CREATE TABLE games (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- ตาราง configs
CREATE TABLE configs (
    config_id INT AUTO_INCREMENT PRIMARY KEY,
    config_name VARCHAR(20) NOT NULL,
    config_value VARCHAR(20) DEFAULT NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

INSERT INTO configs (config_name, config_value) VALUES ('close_time', '30');
INSERT INTO configs (config_name, config_value) VALUES ('turn_time', '60');
INSERT INTO configs (config_name, config_value) VALUES ('ban_time', '30');