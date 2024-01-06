############################################################################
# 从https://shortstorylines.com/very-short-stories-with-morals/  解析story
############################################################################


import logging
import os
import json
import re
import time
import lxml
import random
from bs4 import BeautifulSoup
import requests
from datetime import datetime

URL_ROOT = 'https://helenadailyenglish.com/'

BOOK_NAME = "Short Stories With Morals"

def _createNewBookObj(group_id, name, type) :
    bookInfoObj = {
        'type': type, #story book
        'name': name,
        'group_id': group_id,
        'desc': '',
        'sub_title' : '',
        'cover' : '',
        'chapters' : [],
        'contents' : [],
        'create_time' : datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    return bookInfoObj


def fetchHtml():
 
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36"}
    urlCacheList = [
        'https://shortstorylines.com/very-short-stories-with-morals/',
        'https://shortstorylines.com/10-lines-short-stories-with-moral-in-english/',
        'https://shortstorylines.com/kindergarten-short-stories-in-pdf-with-pictures/'
    ]

    _books = []

    for url in urlCacheList:
        resp = requests.get(url=url, headers=headers)
        print("BEGIN  parse : " + url)
        if resp.status_code == 200 :
            soup = BeautifulSoup(resp.content, 'html5lib')
            tag_root_div = soup.find("div", class_='entry-content')

            inner_fun = False
            cover_set = False
            index = 0
            for tag_child in tag_root_div.children :
                if tag_child.name == 'h3':
                   
                    if tag_child.get_text().find(".") == -1 and url == "https://shortstorylines.com/10-lines-short-stories-with-moral-in-english/":
                        continue                    

                    inner_fun = True
                    index = 0
                    if url == "https://shortstorylines.com/very-short-stories-with-morals/" or url == "https://shortstorylines.com/10-lines-short-stories-with-moral-in-english/":
                        _name = tag_child.get_text().split(".")[1].strip()
                    else :
                        _name = tag_child.get_text().strip()
                    _bookObj = _createNewBookObj('6590d5b7bf8a3ab2facf374c', _name, 1)
                    continue

                if inner_fun and tag_child.name == 'blockquote' :
                    inner_fun = False    
                    cover_set = False
                    _books.append(_bookObj)

                if inner_fun :
                    if tag_child.name == 'p' or tag_child.name == 'figure':
                        tag_ts = tag_child.contents[0]
                        # print("tag_ts ", tag_ts)
                        if tag_ts.name == 'img' :
                            _bookObj['contents'].append({
                                'idx' : index,
                                'type': 3,
                                'content' : tag_ts['src']
                            })
                            index += 1
                            if cover_set == False:
                                _bookObj['cover'] = tag_ts['src']

                        if tag_ts.name == 'span' :
                            _bookObj['contents'].append({
                                'idx' : index,
                                'type': 0,
                                'content' : tag_ts.get_text()
                            })
                            index += 1

                        if url == 'https://shortstorylines.com/kindergarten-short-stories-in-pdf-with-pictures/' and isinstance(tag_ts, str) :
                            _bookObj['contents'].append({
                                'idx' : index,
                                'type': 0,
                                'content' : tag_ts
                            })
                            index += 1

        print("END    parse : " + url)
        time.sleep(2)

    return _books


def outputJsonFile(result_json):
    dir = 'E:/FlutterWorld/projects/my_eng_program/scripts/books'
    file_name = 'short_stories_with_morals.json'
    full_path = dir + os.sep + file_name

    if os.path.exists(full_path) :
        os.remove(full_path)
    json_str = json.dumps(result_json, ensure_ascii=False)
    open(full_path, 'w', encoding="utf-8").write(json_str) 
    print(full_path + "   SUCCESS WRITE")
    return


def doIt():
    json = fetchHtml()
    outputJsonFile(json)
    return


if __name__ == '__main__':
    doIt()    
