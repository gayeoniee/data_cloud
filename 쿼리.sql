CREATE DATABASE cp_data;

USE cp_data;

CREATE TABLE news_master (
    seq_no BIGINT(20) NOT NULL AUTO_INCREMENT,
    news_title TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    news_desc TEXT NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    news_category TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    news_author TEXT NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    publisher TINYTEXT NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    news_pub_date CHAR(30) NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    news_url TINYTEXT NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    news_update CHAR(19) NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (seq_no) USING BTREE,
    INDEX news_url (news_url(255)) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=213
;

CREATE TABLE news_scrap_ready (
    seq_no BIGINT(20) NOT NULL AUTO_INCREMENT,
    source_type CHAR(1) NOT NULL DEFAULT '0'  COLLATE 'utf8mb4_general_ci',
    source_url TINYTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '0:처리전, 1:수집처리대기, 2:수집중, 5:실패, 6: 패키지취소, 7: 저품질취소, 8: 중복취소, 9:수집완료' COLLATE 'utf8mb4_general_ci',
    create_dt CHAR(19) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    update_dt CHAR(19) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (seq_no) USING BTREE,
    INDEX source_type_status (source_type, status) USING BTREE,
    INDEX source_url (source_url(255)) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=56
;

SELECT * FROM news_scrap_ready;
SELECT * FROM news_master;



CREATE TABLE gn_scrap_ready (
    seq_no BIGINT(20) NOT NULL AUTO_INCREMENT,
    source_type CHAR(1) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    source_url TINYTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
    comment_cnt CHAR(3) NOT NULL DEFAgn_scrap_readyULT '0' COLLATE 'utf8mb4_general_ci',
    status CHAR(1) NOT NULL DEFAULT '0' COMMENT '0:처리전, 1:수집처리대기, 2:수집중, 5:실패, 6: 패키지취소, 7: 저품질취소, 8: 중복취소, 9:수집완료' COLLATE 'utf8mb4_general_ci',
    create_dt CHAR(19) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    update_dt CHAR(19) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (seq_no) USING BTREE,
    INDEX source_type_status (source_type, status) USING BTREE,
    INDEX source_url (source_url(255)) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

CREATE TABLE gn_master (
    seq_no BIGINT(20) NOT NULL AUTO_INCREMENT,
    news_title TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    news_desc TEXT NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    news_url TINYTEXT NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    news_comments TEXT NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    news_pub_date CHAR(30) NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    news_update CHAR(19) NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    full_contents TEXT NULL DEFAULT NULL  COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (seq_no) USING BTREE,
    INDEX news_url (news_url(255)) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=11
;

DROP TABLE gn_scrap_ready;





CREATE TABLE tb_subway (
    t_type VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    t_num VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    t_date VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    t_count VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    d_count BIGINT(20) NULL DEFAULT NULL
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;


UPDATE tb_subway 
SET d_count = convert(t_count, INTEGER);


-- 지하철 1호선 2018년도 전체 이용자수
SELECT SUM(d_count) 
FROM tb_subway
WHERE t_date LIKE '2018%'
AND t_num = '1호선';


-- 2018년도 지하철 각 호선별 가장 이용자가 많은 월
SELECT t_num, t_date, d_count
FROM(
	SELECT t_num, t_date, d_count
	, RANK() OVER (PARTITION BY t_num ORDER BY d_count DESC) AS t_rank
	FROM tb_subway
	WHERE t_date LIKE '2018%'
) temp_ranked
WHERE t_rank = 1;


-- 2018 지하철 각 호선별 가장 이용자가 적은 월
SELECT t_num, t_date, d_count
FROM(
	SELECT t_num, t_date, d_count
	, RANK() OVER (PARTITION BY t_num ORDER BY d_count) AS t_rank
	FROM tb_subway
	WHERE t_date LIKE '2018%'
) temp_ranked
WHERE t_rank = 1;

