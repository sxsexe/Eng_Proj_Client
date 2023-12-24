
import os
import json
import lxml
from bs4 import BeautifulSoup
import requests


def getKetWords():
    fileHandler = open("E:\FlutterWorld\projects\my_eng_program\scripts\words\ket_words.txt",  "r", encoding='utf-8')
    i = 1
    words = []
    while  True:
        line  = fileHandler.readline()
        if not line:
            break
        word = line.strip().split(' ')[0]
        # print( i, " : ", word)
        # i = i + 1
        words.append(word)

    return words

def fetchHtml():
    words = getKetWords()

    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36"}
    word = words[642] ## make    
    url = "https://dictionary.cambridge.org/dictionary/english-chinese-simplified/"+ word
    print("begin query, url =", url)
    resp = requests.get(url=url, headers=headers)
    print("qurey resp.code ", resp.status_code)
    # print("qurey resp.body ", resp.content)
    if(resp.status_code == 200) :
        htmlBody = resp.content
        parseHtml(word, htmlBody)
    else :
        print("FetchHTML Error")

    return 

def parseHtml(word, htmlBody):

    soup = BeautifulSoup(htmlBody, 'html.parser')
    wordDetailObj = {'name' : word, 'defines' : []}

    parts = soup.find_all('div', 'def-block ddef_block')
    for div in parts:
        # print(div)
        for child in enumerate(div.children):
            realTag = child[1]
            if(realTag.name == 'div') :
                attrs = realTag['class']
                oneDefinition = {'type' : '', 'trnas_en' : '', 'trnas_ch' : ''}

                if(attrs[0] == 'ddef_h') :
                    for tag in enumerate(realTag.contents):
                        if type(tag[1]).__name__ == 'Tag' and tag[1].name == 'div':
                            # print(tag[1].get_text())
                            oneDefinition['trnas_en'] = tag[1].get_text()
  
                if(attrs[0] == 'def-body' and attrs[1] == 'ddef_b') :
                    for tag in enumerate(realTag.children) :
                        if type(tag[1]).__name__ == 'Tag' and tag[1].name == 'span' :
                            oneDefinition['trnas_ch'] = tag[1].get_text()
                        # if(tag.name == 'div') :
                        #     oneDefinition.examples.append
                wordDetailObj['defines'].append(oneDefinition)

    print(wordDetailObj)             
              
            

    # chinese_trans_tags = soup.find_all('span', class_='trans dtrans dtrans-se break-cj')
    # english_trans_tags = soup.find_all('div', class_='def ddef_d db')
    # meanings = []
    # for meaning in chinese_trans_tags:
    #     chinese_text = meaning.get_text()
    #     pair= {}
    #     pair['chinese'] = chinese_text
    #     pair['english'] = ''
    #     meanings.append(pair)

    # index = 0
    # for item in english_trans_tags :
    #     english_text = item.get_text()
    #     meanings[index]['english'] = english_text
    #     index += 1
    # print(meanings)

    return

def outputJsonFile():
    return


def doIt():
    
    fetchHtml()
    outputJsonFile()


if __name__ == '__main__':
    doIt()    
