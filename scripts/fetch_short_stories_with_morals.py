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

URL_ROOT = 'https://helenadailyenglish.com/'

BOOK_NAME = "Short Stories With Morals"


def fetchHtml():
 
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36"}
    urlCacheList = [
        'https://shortstorylines.com/very-short-stories-with-morals/',
        'https://shortstorylines.com/10-lines-short-stories-with-moral-in-english/',
        'https://shortstorylines.com/kindergarten-short-stories-in-pdf-with-pictures/'
    ]

    bookInfoObj = {
        'type': 1, #story book
        'name': BOOK_NAME,
        'group_id': '6590d5b7bf8a3ab2facf374c',
        'desc': 'Very short stories for kids',
        'sub_title' : '',
        'avatar' : 'https://shortstorylines.com/wp-content/uploads/2020/01/Very-short-stories-with-moral-768x325.jpg',
        'chapters' : []
    }

    for url in urlCacheList:
        resp = requests.get(url=url, headers=headers)
        print("BEGIN  parse : " + url)
        if resp.status_code == 200 :
            soup = BeautifulSoup(resp.content, 'html5lib')
            tag_root_div = soup.find("div", class_='entry-content')

            inner_fun = False
            index = 0
            for tag_child in tag_root_div.children :
                if tag_child.name == 'h3':
                   
                    if tag_child.get_text().find(".") == -1 and url == "https://shortstorylines.com/10-lines-short-stories-with-moral-in-english/":
                        continue                    

                    chapterInfoObj = {
                        'name' : '',
                        'contents' : []
                    }
                    inner_fun = True
                    if url == "https://shortstorylines.com/very-short-stories-with-morals/" or url == "https://shortstorylines.com/10-lines-short-stories-with-moral-in-english/":
                        _name = tag_child.get_text().split(".")[1].strip()
                        chapterInfoObj['name'] = _name
                    else :
                        chapterInfoObj['name'] = tag_child.get_text().strip()
                    continue

                if inner_fun and tag_child.name == 'blockquote' :
                    inner_fun = False    
                    bookInfoObj['chapters'].append(chapterInfoObj)

                if inner_fun :
                    if tag_child.name == 'p' or tag_child.name == 'figure':
                        tag_ts = tag_child.contents[0]
                        # print("tag_ts ", tag_ts)
                        if tag_ts.name == 'img' :
                            chapterInfoObj['contents'].append({
                                'idx' : index,
                                'type': 3,
                                'content' : tag_ts['src']
                            })
                            index += 1

                        if tag_ts.name == 'span' :
                            chapterInfoObj['contents'].append({
                                'idx' : index,
                                'type': 0,
                                'content' : tag_ts.get_text()
                            })
                            index += 1

                        if url == 'https://shortstorylines.com/kindergarten-short-stories-in-pdf-with-pictures/' and isinstance(tag_ts, str) :
                            chapterInfoObj['contents'].append({
                                'idx' : index,
                                'type': 0,
                                'content' : tag_ts
                            })
                            index += 1

        print("END    parse : " + url)
        time.sleep(2)

    return bookInfoObj


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
