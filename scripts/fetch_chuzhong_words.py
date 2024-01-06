############################################################################
# 从 https://www.koolearn.com/dict/fenlei_4_71_1.html  获取单词列表
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

URL_ROOT = ' https://www.koolearn.com'


URL_FIRST = "/dict/fenlei_4_71_1.html"


def getChuzhongWords():
 
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36"}
    url = URL_ROOT + URL_FIRST
    resp = requests.get(url=url, headers=headers)
    words_map = []

    if resp.status_code == 200 :
        htmlBody = resp.content
        soup = BeautifulSoup(htmlBody, 'html.parser')
        tag_root = soup.find("div", class_="word-wrap")
        tag_titles = tag_root.find_all("div", class_="word-title")
        for tag_title in tag_titles :
            nextUrl = URL_ROOT + tag_title.find("a", class_="word-more")['href']
            _name = tag_title.contents[0]
            print("------------- ", _name, "---------------")
            _rsp = requests.get(url=nextUrl, headers=headers)
            print("BEGIN  parse : " + nextUrl)
            if _rsp.status_code == 200 :
                _soup = BeautifulSoup(_rsp.content, 'html5lib')
                tag_as = _soup.find_all("a", class_="word")

                _word_obj = {
                    'name' : _name,
                    'words' : []
                }

                for tag_a in tag_as :
                    _word_obj["words"].append(tag_a.get_text())
                words_map.append(_word_obj)
                    
            else:
                print('Error open ' + url)
            print("END    parse : " + nextUrl)
            time.sleep( 2 )
    else :
        print('Error to Http')

    return words_map           
  

def outputFile(file_name, str):
    dir = 'E:/FlutterWorld/projects/my_eng_program/scripts/words'
    # file_name = '30_short_stories.json'
    full_path = dir + os.sep + file_name

    if os.path.exists(full_path) :
        os.remove(full_path)
    # json_str = json.dumps(result_json, ensure_ascii=False)
    open(full_path, 'w', encoding="utf-8").write(str) 
    print(full_path + "   SUCCESS WRITE")
    return


def doIt():
    word_maps = getChuzhongWords()
    for word_map in word_maps:
        _name = word_map['name']
        _words = word_map['words']
        str = ""
        for word in _words:
            str += word + "\n"
        _file_name = _name + ".txt"
        outputFile(_file_name, str)
    # outputFile(json)
    return


if __name__ == '__main__':
    doIt()    


