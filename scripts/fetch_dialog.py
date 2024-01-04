############################################################################
# 从https://helenadailyenglish.com/  查询单词  并解析Html后生成Json结果
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

BOOK_NAME = "100 Basic Dialogues"
URL_FIRST = "basic-english-conversation-100-daily-topics/"


def fetchHtml():
 
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36"}
    url = URL_ROOT + URL_FIRST
    resp = requests.get(url=url, headers=headers)

    bookInfoObj = {
        'type': 2, #dialogue book
        'name': BOOK_NAME,
        'group_id': '6594b972e7d97998723b7134',
        'desc': '',
        'sub_title' : '',
        'avatar' : 'https://helenadailyenglish.com/wp-content/uploads/2018/05/Basic-English-Conversation-100-Daily-Topics-01.jpg?ezimgfmt=ng%3Awebp%2Fngcb1%2Frs%3Adevice%2Frscb1-1',
        'chapters' : []
    }

    urlCacheSet = set()
    if resp.status_code == 200 :
        htmlBody = resp.content
        soup = BeautifulSoup(htmlBody, 'html.parser')
        tags = soup.find_all(href=re.compile("daily-topics-"))

        for tag in tags :
            nextUrl = tag['href']
            urlCacheSet.add(nextUrl)

        urlCacheList = list(urlCacheSet)
        urlCacheList.sort()


        # urlCacheList = ['https://helenadailyenglish.com/basic-english-conversation-100-daily-topics-2.html']

        for url in urlCacheList :
            resp = requests.get(url=url, headers=headers)
            soup = BeautifulSoup(resp.content, 'html5lib')
            tag_root_div = soup.find(id='ftwp-postcontent')
            print("BEGIN  parse : " + url)

            tag_heads = tag_root_div.find_all("h3", class_='ftwp-heading')
     
            for tag_head in tag_heads:
                rawTitle = tag_head.get_text()
                chapterName = ""
                if rawTitle.find(":") > -1:
                    chapterName = rawTitle.split(':')[1]
                if rawTitle.find("-") > -1:
                    chapterName = rawTitle.split('-')[1]

                chapterInfoObj = {
                    'name' : chapterName.strip(),
                    'contents' : []
                }
                
                tag_ul = tag_head.find_next("ul")
                tag_lis = tag_ul.children
                index = 0
                for tag_li in tag_lis:
                    tag_children = list(tag_li.children)
                    textContent = ""
                    if len(tag_children) <= 1 :
                        textContent = tag_li.get_text().strip()
                    else :
                        textContent = tag_children[0].get_text().strip()
                    
                    if len(textContent) == 0 :
                        continue
                    textContentObj = {
                        'idx' : index,
                        'type': 0,
                        'content' : textContent
                    }
                    index += 1
                    chapterInfoObj['contents'].append(textContentObj)


                tag_audio = tag_head.find_next("source")
                audio_src = tag_audio['src']
                if audio_src is not None :
                    audioContent = {
                        'type' : 1,
                        'content' : audio_src
                    }
                    chapterInfoObj['contents'].append(audioContent)

                bookInfoObj['chapters'].append(chapterInfoObj)

            print("END    parse : " + url)    
            time.sleep( 5 )

    else :
        print('Error to Http')

    return bookInfoObj            
  

def outputJsonFile(result_json):
    dir = 'E:/FlutterWorld/projects/my_eng_program/scripts/books'
    file_name = 'basic_100_dialogues.json'
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
