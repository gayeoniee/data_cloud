import mariadb
import sys
import os
import json

try:
    conn_tar = mariadb.connect(
        user="lguplus7",
        password="lg7p@ssw0rd~!",
        host="localhost",
        port=3310,
        database="cp_data"
    )
except mariadb.Error as e:
    print(f"Error connecting to MariaDB Platform: {e}")
    sys.exit(1)

tar_cur = conn_tar.cursor()

json_path = 'c:/data/ts_data'
# ts_data 바로 아래 폴더(TS_CP01 ~ 06)만 순회
for folder_name in os.listdir(json_path):
    folder_path = os.path.join(json_path, folder_name)

    if os.path.isdir(folder_path) and folder_name.startswith("TS_CP"):  # 폴더명 필터
        for file_name in os.listdir(folder_path):
            if file_name.endswith('.json'):
                file_path = os.path.join(folder_path, file_name)
                print(f'json_file_name = {file_path}')

                with open(file_path, encoding='UTF8') as json_file:
                    json_reader = json_file.read()
                    json_dic = json.loads(json_reader)

                document_id = json_dic['info'][0]['document_id']
                print( f"document_id = {document_id}")
                contents_title = json_dic['annotation'][0]['contents_title']
                print( f"contents_title = {contents_title}")
                sentence_id = json_dic['annotation'][0]['contents'][0]['sentence_id']
                print( f"sentence_id = {sentence_id}")
                sentence_title = json_dic['annotation'][0]['contents'][0]['sentence_title']
                print( f"sentence_title = {sentence_title}")
                sentence_text = json_dic['annotation'][0]['contents'][0]['sentence_text']
                print( f"sentence_text = {sentence_text}")

                tar_cur.execute(
                    "insert into tb_cp(document_id, contents_title, sentence_id, sentence_title, sentence_text, json_data, create_dt ) values (?,?,?,?,?,?,now())",
                    (document_id, contents_title, sentence_id, sentence_title, sentence_text, json.dumps(json_dic ) ))
                conn_tar.commit()
                print('insert into cp_data done')
