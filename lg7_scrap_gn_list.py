from playwright.sync_api import sync_playwright
from bs4 import BeautifulSoup
import time
import mariadb
import sys


# 1. MariaDB 연결
try:
    conn = mariadb.connect(
        user="lguplus7",
        password="lg7p@ssw0rd~!",
        host="localhost",
        port=3310,
        database="cp_data"
    )
except mariadb.Error as e:
    print(f"Error connecting to MariaDB Platform: {e}")
    sys.exit(1)
cur = conn.cursor()

# mariadb.connect(...) : DB 접속 (localhost, 포트 3310, DB명 cp_data)
# cur : SQL 실행을 위한 커서 객체 생성
# 목적 → 이후 크롤링한 데이터를 DB에 저장하거나 조회

# 2. 크롤링할 URL 목록 설정
scrap_url_list = []
scrap_url_list.append(['https://news.hada.io/?page=',-1])

# 3. 기타 설정값
source_type = '0'
duplicate_yn = 'Y'
duplicate_max = 30
# source_type: 데이터 구분 값 (여기서는 '0' → news.hada.io)
# duplicate_yn: 'Y'면 중복이 일정 개수 이상이면 중단
# duplicate_max: 중복 허용 개수 (30 이상이면 중단)


# 4. Playwright 브라우저 실행
with sync_playwright() as p:

    current_list_pos = 0
    current_page = 1

# browser : headless(창 안 뜸) 모드로 Firefox 실행
    browser = p.firefox.launch(headless=True)
    main_page = browser.new_page()   # main_page : 새 페이지(탭) 객체


    # 5. 무한 크롤링 루프
    while True:
        try:
            time.sleep(5)  # 5초 대기 후, 현재 URL + 현재 페이지 번호로 이동
            main_page.goto(f'{scrap_url_list[current_list_pos][0]}{current_page}')
        
        # 6. 페이지 로딩 실패 처리
        except TimeoutError as te:
            print(f"Error browser: {te}")
            browser.close()
            browser = p.firefox.launch(headless=True)
            main_page = browser.new_page()
            time.sleep(60)
            main_page.goto(f'{scrap_url_list[current_list_pos][0]}{current_page}')

        time.sleep(5)

        print( '[debug] list page : ', main_page.url) # 목록 URL 출력

        # 7. HTML 파싱
        content = main_page.content()
        soup = BeautifulSoup(content, "html.parser")
        temp_soup = soup.select_one('article > div')

        news_list = temp_soup.find_all('div', {'class': 'topic_row'})
        # 'article > div' 내부에서 div.topic_row 요소들을 모두 찾음
        # 하나의 topic_row = 뉴스/글 하나
        
        # 8. 뉴스가 없을 경우
        if news_list.__len__() == 0:
            print('[debug] no news found...')
            continue # 사실상 retry --> chromium 말고 firefox가 잘됨

        # 9. 뉴스 목록 순회
        duplicate_cnt=0
        for news in news_list:

            source_url = f'https://news.hada.io/{news.select('div.topicdesc > a')[0].get('href')}'
            print( 'source_url : ', source_url)

            # 10. 댓글 수 추출
            comment_cnt = news.select_one('div.topicinfo > a.u')
            if comment_cnt.text.strip().startswith('댓글 '):
                comment_cnt = comment_cnt.text.replace('댓글 ','').replace('개', '')
            else:
                comment_cnt = '0'

            # 11. DB 중복 검사
            cur.execute('select comment_cnt from gn_scrap_ready where source_type = ? and source_url = ? and status = "0"', (source_type, source_url))
            res = cur.fetchall()
            
            # 12. 중복 처리 로직
            if res.__len__() > 0:
                if res[0] == comment_cnt:
                    print('[debug] DB에 source_url 존재 --> Skip')
                    duplicate_cnt = duplicate_cnt + 1
                    # 한 목록에서 중복 20개 이상인 경우 수집 중단
                    if duplicate_yn == 'Y' and duplicate_cnt >= duplicate_max:
                        print('[debug] duplicate_cnt >= 30 --> break')
                        current_page = scrap_url_list[current_list_pos][1]
                        break # 중복 20개 이상이면 for를 벗어나 다음 섹션으로 이동
                    continue

            # 13. 신규 데이터 저장
            insert_sql = "insert into gn_scrap_ready(source_type, source_url, comment_cnt, create_dt) values (?,?,?, now())"
            cur.execute( insert_sql, (source_type, source_url, comment_cnt ) )
            conn.commit()

        # 14. 페이지 이동 로직
        if current_page == scrap_url_list[current_list_pos][1]:
            if current_list_pos == (len(scrap_url_list)-1):
                current_list_pos = 0
            else:
                current_list_pos = current_list_pos + 1
            current_page = 1
            print('[debug] next section : ', current_list_pos )
        else:
            # 다음 페이지로 이동
            current_page = current_page + 1
            print('[debug] next page : ', current_page )
            time.sleep(5)

    # 브라우저 종료
    browser.close()
