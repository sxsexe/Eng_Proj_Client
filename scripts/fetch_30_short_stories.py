############################################################################
# 从https://dictionary.cambridge.org/  解析story
############################################################################


from datetime import datetime
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

BOOK_NAME = "30 Short Stories"
URL_FIRST = "101-short-stories-for-learning-english-beginner-to-advanced-level-text-audio-and-video/"


def _createNewBookObj(group_id, name, type) :
    bookInfoObj = {
        'type': type, #story book
        'name': name,
        'group_id': group_id,
        'desc': 'Beginner Level',
        'sub_title' : '',
        'cover' : '',
        'chapters' : [],
        'contents' : [],
        'create_time' : datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

    return bookInfoObj


def fetchHtml():
 
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36"}
    url = URL_ROOT + URL_FIRST
    resp = requests.get(url=url, headers=headers)

    books = []

    urlCacheSet = set()
    if resp.status_code == 200 :
        htmlBody = resp.content
        soup = BeautifulSoup(htmlBody, 'html.parser')
        tagRoot = soup.find("ol")
        tags_a = tagRoot.find_all("a")
        for tag in tags_a :
            nextUrl = tag['href']
            urlCacheSet.add(nextUrl)

        urlCacheList = list(urlCacheSet)
        urlCacheList.sort()
        # urlCacheList = ['https://helenadailyenglish.com/basic-english-conversation-100-daily-topics-2.html']

        for url in urlCacheList :
            resp = requests.get(url=url, headers=headers)
            print("BEGIN  parse : " + url)
            if resp.status_code == 200 :
                soup = BeautifulSoup(resp.content, 'html5lib')
                tag_root_div = soup.find(id='ftwp-postcontent')

                tag_head = tag_root_div.find("h3", class_='ftwp-heading')
                title = tag_head.get_text().split(":")[1].strip()

                _bookObj = _createNewBookObj('6590d5b7bf8a3ab2facf374c', title, 1)

                tag_audio = tag_root_div.find("source")
                _index = 0
                if tag_audio != None:
                    _bookObj['contents'].append({
                        'idx' : _index,
                        'type': 1,
                        'content' : tag_audio['src']
                    })
                    _index += 1

                tag_text_next = tag_root_div.find("span", id="ezoic-pub-ad-placeholder-901")
                tag_text = tag_text_next.previous_sibling
                _bookObj['contents'].append({
                        'idx' : _index,
                        'type': 0,
                        'content' : tag_text.get_text()
                    })

                books.append(_bookObj)
            else:
                print('Error open ' + url)
            print("END    parse : " + url)
            time.sleep( 2 )

    else :
        print('Error to Http')

    return books            
  

def outputJsonFile(result_json):
    dir = 'E:/FlutterWorld/projects/my_eng_program/scripts/books'
    file_name = '30_short_stories.json'
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
