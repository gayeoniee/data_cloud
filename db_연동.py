import sys
import mariadb

# --- DB 연결 ---
try:
    conn_src = mariadb.connect(
        user="lguplus7",  # 여러분 DB 계정
        password="lg7p@ssw0rd~!",
        host="192.168.14.38",  # IP 변경
        port=3310,             # MariaDB 포트
        database="cp_data"
    )
except mariadb.Error as e:
    print(f"[ERROR] 원본 DB 연결 실패: {e}")
    sys.exit(1)

src_cur = conn_src.cursor()

# --- 내 DB 연결 (타겟) ---
try:
    conn_tar = mariadb.connect(
        user="lguplus7",
        password="lg7p@ssw0rd~!",
        host="localhost",
        port=3310,
        database="cp_data"
    )
except mariadb.Error as e:
    print(f"[ERROR] 타겟 DB 연결 실패: {e}")
    sys.exit(1)

tar_cur = conn_tar.cursor()

try:
    src_cur.execute("""
        SELECT STN_ID, LON, LAT, STN_SP, HT, HT_WD, LAU_ID, STN_AD,
           STN_KO, STN_EN, FCT_ID, LAW_ID, BASIN,
           addr1, addr2, addr3, org_addr, create_dt
        FROM tb_weather_tcn                
    """)
    rows = src_cur.fetchall()

    tar_cur.executemany("""
        INSERT INTO tb_weather_tcn
        (STN_ID, LON, LAT, STN_SP, HT, HT_WD, LAU_ID, STN_AD,
        STN_KO, STN_EN, FCT_ID, LAW_ID, BASIN,
        addr1, addr2, addr3, org_addr, create_dt)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, rows)

    conn_tar.commit()
    print(f"완료: {len(rows)}건 적재")

except Exception as e:
    print(f"[ERROR] {e}")
finally:
    conn_src.close()
    conn_tar.close()