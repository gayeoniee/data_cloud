CREATE TABLE tb_weather_aws1 (
    seq_no BIGINT(20) NOT NULL AUTO_INCREMENT,
    yyyymmddhhmi CHAR(12) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    stn CHAR(4) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    wd1 VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    ws1 VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    wds VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    wss VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    wd10 VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    ws10 VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    ta VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    re VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    rn_15m VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    rn_60m VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    rn_12h VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    rn_day VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    hm VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    pa VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    ps VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    td VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    org_data MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
    update_dt CHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (seq_no) USING BTREE,
    INDEX yyyymmddhhmi_stn (yyyymmddhhmi, stn) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;


CREATE TABLE tb_weather_tcn (
    seq_no INT(11) NOT NULL AUTO_INCREMENT,
    STN_ID CHAR(4) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    LON VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    LAT VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    STN_SP VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    HT VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    HT_WD VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    LAU_ID VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    STN_AD VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    STN_KO VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    STN_EN VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    FCT_ID VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    LAW_ID VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    BASIN VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    addr1 VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    addr2 VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    addr3 VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    org_addr MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_general_ci',
    create_dt CHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (seq_no) USING BTREE,
    INDEX STN_ID (STN_ID) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;


CREATE TABLE fact_weather_aws1 (
    seq_no BIGINT(20) NOT NULL AUTO_INCREMENT,
    yyyymmddhhmi CHAR(12) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    stn CHAR(4) NOT NULL DEFAULT '0' COLLATE 'utf8mb4_general_ci',
    wd1 DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    ws1 DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    wds DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    wss DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    wd10 DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    ws10 DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    ta DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    re DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    rn_15m DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    rn_60m DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    rn_12h DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    rn_day DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    hm DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    pa DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    ps DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    td DECIMAL(6,1) NOT NULL DEFAULT '0.0',
    update_dt CHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (seq_no) USING BTREE,
    INDEX yyyymmddhhmi_stn (yyyymmddhhmi, stn) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;

INSERT INTO fact_weather_aws1(yyyymmddhhmi, stn, wd1, ws1, wds, wss, wd10, ws10, ta, re, rn_15m, rn_60m, rn_12h, rn_day, hm, pa, ps, td, UPDATE_dt )
SELECT yyyymmddhhmi, stn
, convert(wd1, DECIMAL(6,2))
, convert(ws1, DECIMAL(6,2))
, convert(wds, DECIMAL(6,2))
, convert(wss, DECIMAL(6,2))
, convert(wd10, DECIMAL(6,2))
, convert(ws10, DECIMAL(6,2))
, convert(ta, DECIMAL(6,2))
, if ( convert(re, DECIMAL(6,2)) < 0, 0.0, convert(re, DECIMAL(6,2)) )
, if ( convert(rn_15m, DECIMAL(6,2)) < 0, 0.0, convert(rn_15m, DECIMAL(6,2)) )
, if ( convert(rn_60m, DECIMAL(6,2)) < 0, 0.0, convert(rn_60m, DECIMAL(6,2)) )
, if ( convert(rn_12h, DECIMAL(6,2)) < 0, 0.0, convert(rn_12h, DECIMAL(6,2)) )
, if ( convert(rn_day, DECIMAL(6,2)) < 0, 0.0, convert(rn_day, DECIMAL(6,2)) )
, convert(hm, DECIMAL(6,2))
, convert(pa, DECIMAL(6,2))
, convert(ps, DECIMAL(6,2))
, convert(td, DECIMAL(6,2))
, NOW()
FROM tb_weather_aws1;

-- MART 생성 : 지역별 시간단위 실적 생성
-- mart_weather_aws_hour

CREATE TABLE mart_weather_aws_hour (
    yyyymmddhh CHAR(10) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    stn_id CHAR(4) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    stn_ko VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    ta_min DECIMAL(6,2) NULL DEFAULT NULL,
    ta_max DECIMAL(6,2) NULL DEFAULT NULL
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;


INSERT INTO mart_weather_aws_hour
(yyyymmddhh, stn_id, stn_ko, ta_min, ta_max)
SELECT SUBSTRING(yyyymmddhhmi, 1, 10) AS yyyymmddhh
, stn AS stn_id
, (SELECT STN_KO FROM tb_weather_tcn t WHERE t.STN_ID = stn) AS stn_ko
, MIN(ta) AS ta_min
, MAX(ta) AS ta_max
FROM fact_weather_aws1
WHERE ta > -90.0
GROUP BY yyyymmddhh, stn_id;


-- MART 생성 : 지역별 일단위 실적 생성
-- mart_weather_aws_day

CREATE TABLE mart_weather_aws_day
as SELECT SUBSTRING(yyyymmddhhmi, 1, 8) AS yyyymmdd
, stn AS stn_id
, (SELECT STN_KO FROM tb_weather_tcn t WHERE t.STN_ID = stn) AS stn_ko
, MIN(ta) AS ta_min
, MAX(ta) AS ta_max
FROM fact_weather_aws1
WHERE ta > -90.0
GROUP BY yyyymmdd, stn_id;
-- 임시방편: 한번만 해볼 때 사용(TEMP)


-- MART 생성 : 시도 단위 최저/최고기온 일단위
-- tb_weather_tcn의 depth1 이용 => 20250708 1일치 최저/최고 기온 마트 생성








-- 소상공인시장진흥공단_상가(상권)정보
-- 테이블면: tb_smb_ods
-- COL: col1, col2, col3 .... (총 39개)

CREATE TABLE `tb_smb_ods` (
	`col1` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col2` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col3` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col4` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col5` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col6` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col7` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col8` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col9` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col10` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col11` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col12` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col13` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col14` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col15` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col16` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col17` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col18` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col19` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col20` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col21` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col22` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col23` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col24` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col25` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col26` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col27` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col28` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col29` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col30` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col31` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col32` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col33` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col34` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col35` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col36` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col37` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col38` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`col39` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci'
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;


SELECT COUNT(*)
FROM tb_smb_ods;



CREATE TABLE fact_smb_master (
    seq_no INT(11) NOT NULL AUTO_INCREMENT COMMENT '고유번호 ',
    smb_id CHAR(20) NOT NULL COMMENT '상가업소번호 ' COLLATE 'utf8mb4_general_ci',
    smb_name TEXT NOT NULL COMMENT '상호명 ' COLLATE 'utf8mb4_general_ci',
    smb_subnm VARCHAR(30) NOT NULL COMMENT '지점명 ' COLLATE 'utf8mb4_general_ci',
    cate1_cd CHAR(2) NOT NULL COMMENT '상권업종대분류코드 ' COLLATE 'utf8mb4_general_ci',
    cate1_nm VARCHAR(255) NOT NULL COMMENT '상권업종대분류명 ' COLLATE 'utf8mb4_general_ci',
    cate2_cd CHAR(4) NOT NULL COMMENT '상권업종중분류코드 ' COLLATE 'utf8mb4_general_ci',
    cate2_nm VARCHAR(255) NOT NULL COMMENT '상권업종중분류명 ' COLLATE 'utf8mb4_general_ci',
    cate3_cd CHAR(6) NOT NULL COMMENT '상권업종소분류코드 ' COLLATE 'utf8mb4_general_ci',
    cate3_nm VARCHAR(255) NOT NULL COMMENT '상권업종소분류명 ' COLLATE 'utf8mb4_general_ci',
    std_cd CHAR(6) NOT NULL COMMENT '표준산업분류코드 ' COLLATE 'utf8mb4_general_ci',
    std_nm VARCHAR(255) NOT NULL COMMENT '표준산업분류명 ' COLLATE 'utf8mb4_general_ci',
    addr1 VARCHAR(255) NOT NULL COMMENT '시도명 ' COLLATE 'utf8mb4_general_ci',
    addr2 VARCHAR(255) NOT NULL COMMENT '시군구명 ' COLLATE 'utf8mb4_general_ci',
    addr3 VARCHAR(255) NOT NULL COMMENT '행정동명 ' COLLATE 'utf8mb4_general_ci',
    addr4 VARCHAR(255) NOT NULL COMMENT '법정동명 ' COLLATE 'utf8mb4_general_ci',
    addr_num1 DECIMAL(4,0) NOT NULL COMMENT '지번본번지 ',
    addr_num2 DECIMAL(4,0) NOT NULL COMMENT '지번부번지 ',
    addr_bld VARCHAR(255) NOT NULL COMMENT '건물명 ' COLLATE 'utf8mb4_general_ci',
    floor_nm VARCHAR(10) NOT NULL COMMENT '층 위치' COLLATE 'utf8mb4_general_ci',
    lon DECIMAL(16,12) NOT NULL COMMENT '경도 ',
    lat DECIMAL(16,12) NOT NULL COMMENT '위도 ',
    PRIMARY KEY (seq_no) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;


INSERT INTO fact_smb_master 
(smb_id, smb_name, smb_subnm, cate1_cd, cate1_nm, cate2_cd, cate2_nm, cate3_cd, cate3_nm, std_cd, std_nm, addr1, addr2, addr3, addr4, addr_num1, addr_num2, addr_bld, floor_nm, lon, lat)
SELECT col1, col2, col3, col4, col5, col6, col7, col8, col9, col10, col11, col13, col15, col17, col19, convert(col23, DECIMAL(4)), convert(col24, DECIMAL(4)), col26, col36, convert(col38, DECIMAL(16,12)), convert(col39, DECIMAL(16,12))
FROM tb_smb_ods
;


-- fact_smb_master를 이용하여 MART 생성
-- ADDR3 단위 가장 많은 cate3_cd OR cate3_nm 업종중 가장 많은 기준으로 랭킹 1개씩 생성
SELECT addr3, cate3_cd, cate3_nm, cnt
FROM (
    SELECT addr3, cate3_cd, cate3_nm,
           COUNT(*) AS cnt,
           RANK() OVER (PARTITION BY addr3 ORDER BY COUNT(*) DESC) AS rnk
    FROM fact_smb_master
    GROUP BY addr1, addr2, addr3, cate3_cd, cate3_nm
) t
WHERE t.rnk = 1
ORDER BY addr3;


 CREATE TABLE mart_top_cate3_by_addr3 (
 	 addr1 VARCHAR(255) NOT NULL COMMENT '시도명 ' COLLATE 'utf8mb4_general_ci',
    addr2 VARCHAR(255) NOT NULL COMMENT '시군구명 ' COLLATE 'utf8mb4_general_ci',
    addr3 VARCHAR(255) NOT NULL COMMENT '행정동명' COLLATE 'utf8mb4_general_ci',
    cate3_cd CHAR(6) NOT NULL COMMENT '상권업종소분류코드' COLLATE 'utf8mb4_general_ci',
    cate3_nm VARCHAR(255) NOT NULL COMMENT '상권업종소분류명' COLLATE 'utf8mb4_general_ci',
    cnt INT NOT NULL COMMENT '점포 수'
) COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB;


INSERT INTO mart_top_cate3_by_addr3 (addr1, addr2, addr3, cate3_cd, cate3_nm, cnt)
SELECT t.addr1, t.addr2, t.addr3, t.cate3_cd, t.cate3_nm, t.cnt
FROM (
    SELECT addr1, addr2, addr3, cate3_cd, cate3_nm,
           COUNT(*) AS cnt,
           RANK() OVER (PARTITION BY addr3 ORDER BY COUNT(*) DESC) AS rnk
    FROM fact_smb_master
    GROUP BY addr1, addr2, addr3, cate3_cd, cate3_nm
) t
WHERE t.rnk = 1;

-- =========================================================

-- addr2 기준
SELECT
addr1, addr2, cate3_nm, cnt
FROM (
    SELECT
    addr1, addr2, cate3_nm, cnt
    , RANK() OVER (PARTITION BY addr2 ORDER BY cnt DESC) AS t_rank
    FROM (
        SELECT 
        addr1, addr2, cate3_nm, COUNT(cate3_nm) AS cnt
        FROM fact_smb_master
        GROUP BY addr1, addr2, cate3_nm
        ORDER BY cnt DESC
    ) temp_rank
) temp_rank2
WHERE t_rank=1
ORDER BY cnt DESC;















