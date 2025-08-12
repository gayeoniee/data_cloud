import os
import csv
import mariadb

# DB 연결
conn = mariadb.connect(
    user="lguplus7",
    password="lg7p@ssw0rd~!",
    host="localhost",
    port=3310,
    database="cp_data"
)
cur = conn.cursor()

# CSV 폴더 경로
folder = r'c:\data\smb_data'

# INSERT 쿼리 (col1~col39)
cols = ",".join([f"col{i}" for i in range(1, 40)])
placeholders = ",".join(["?"] * 39)
sql = f"INSERT INTO tb_smb_ods ({cols}) VALUES ({placeholders})"

# 폴더 안 모든 CSV 처리
for file in os.listdir(folder):
    if file.lower().endswith(".csv"):
        path = os.path.join(folder, file)
        with open(path, "r", encoding="utf-8-sig") as f:
            reader = csv.reader(f)
            next(reader)
            for row in reader:
                row = (row + [""] * 39)[:39]
                cur.execute(sql, row)
        conn.commit()
        print(f"{file} 적재 완료")

cur.close()
conn.close()
