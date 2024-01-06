############################################################################
# 从 https://parenting.firstcry.com/articles/top-20-short-moral-stories-for-children/  解析story
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

URL_ROOT = ' https://parenting.firstcry.com/'

BOOK_NAME = "22 Short Stories"


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
    url = URL_ROOT + "articles/top-20-short-moral-stories-for-children/"
    resp = requests.get(url=url, headers=headers)

    books = []
    print("BEGIN  parse : " + url)
    if resp.status_code == 200 :

        soup = BeautifulSoup(resp.content, 'html5lib')
        tag_root_div = soup.find("div", class_='editorContent')

        innerLoop = False
        index = 0
        for tag_child in tag_root_div.children :

            if tag_child.name == 'h3':
                tag_text = tag_child.get_text()
                if tag_text.startswith('1. Prepare kids ') or tag_text.startswith('2. Help kids  ') or tag_text.startswith('3. Counter bad') :
                    continue

                index = 0
                innerLoop = True
                _name = tag_text.split('.')[1].strip()
                _bookObj = _createNewBookObj('6590d5b7bf8a3ab2facf374c', _name, 1)

            if innerLoop and tag_child.name == 'h4' :
                innerLoop = False  
                books.append(_bookObj)

            if innerLoop and tag_child.name == 'p':
                tag_img = tag_child.find('img')
                if tag_img != None:
                    _bookObj['contents'].append({
                        'idx' : index,
                        'type' : 3,
                        'content' : tag_img['src']
                    })
                    index += 1
                    _bookObj['cover'] = tag_img['src']
                
                _bookObj['contents'].append({
                        'idx' : index,
                        'type' : 0,
                        'content' : tag_child.get_text()
                    })
                index += 1
        print("END    parse : " + url)
    else :
        print("HTTP Error")

    return books

def outputJsonFile(result_json):
    dir = 'E:/FlutterWorld/projects/my_eng_program/scripts/books'
    file_name = 'short_stories_with_morals2.json'
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
