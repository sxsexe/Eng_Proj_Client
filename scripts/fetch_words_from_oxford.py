############################################################################
# 从https://dictionary.cambridge.org/  查询单词  并解析Html后生成Json结果
############################################################################

import logging
import os
import json
import time
import lxml
import random
from bs4 import BeautifulSoup
import requests

URL_ROOT = 'https://dictionary.cambridge.org/'
URL_WORD_QUERY = 'dictionary/english-chinese-simplified/'
URL_MEDIA = 'media/english-chinese-simplified/us_pron/m/mak/make_/make.mp3'


def getKetWords():
    fileHandler = open("E:\FlutterWorld\projects\my_eng_program\scripts\words\ket_words.txt",  "r", encoding='utf-8')
    i = 1
    words = []
    while  True:
        line  = fileHandler.readline()
        if not line:
            break
        word = line.strip().split('(')[0].strip()
        # print( i, " : (", word, ")")
        i = i + 1
        words.append(word)
    
    return {'name' : 'ket_words_json.json', 'words' : words}

def getRJB7UpWords():
    fileHandler = open("E:\FlutterWorld\projects\my_eng_program\scripts\words\初中人教版七年级上.txt",  "r", encoding='utf-8')
    i = 1
    words = []
    while  True:
        line  = fileHandler.readline()
        if not line:
            break
        word = line.strip().split('(')[0].strip()
        # print( i, " : (", word, ")")
        i = i + 1
        words.append(word)
    
    return {'name' : '初中人教版七年级上.json', 'words' : words}

def fetchDefineFromOxford(words):
    # words = getKetWords()
    # words = ['bad', 'borrow', 'barbecue', 'bus stop', 'bus station', 'chocolate']
    # words = ['ill', 'in', 'its', 'kg', 'km', 'pence', 'pop', 'sing', 'sun', 'well']
    # words = ['big']
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36"}

    total = len(words)
    success = 0
    failed = 0
    empty = 0

    words_list = []
    failed_list = []
    empty_list = []

    print('================================ being total = ', total)
    for word in words:
        
        url = URL_ROOT + URL_WORD_QUERY + word
        resp = requests.get(url=url, headers=headers)
        # print("qurey resp.code ", resp.status_code, " url = ", url)
        # print("qurey resp.body ", resp.content)
        if(resp.status_code == 200) :
            htmlBody = resp.content
            try:
                wordObj = parseHtml(word, htmlBody)
                if len(wordObj['genders']) > 0 :
                    words_list.append(wordObj)
                    success += 1
                    print("SUCCESS ---------------> [", word, "]")
                else:
                    empty += 1
                    empty_list.append(word)
                    print("EMPTY IGNORE ---------------> [", word, "]")
                
            except Exception as e:
                failed += 1
                failed_list.append(word)
                print("ERROR ---------------------------------> [", word, '] exception =', repr(e))
                logging.exception(e)
        else :
            failed += 1
            failed_list.append(word)
            print("FetchHTML Error, word is [", word, "] resp_code = ", resp.status_code)

        time_break = random.randint(1,2)
        time.sleep( time_break )

    print('================================ end, success = ', success, " failed = ", failed, " empty = ", empty)
    if failed > 0 :
        print('failed : ', failed_list)
    if empty > 0 :
        print('empty : ', empty_list)

    return words_list


def getGender(tag_head) :
    _gender_name = None
    tag_gender = tag_head.select_one(".posgram")
    
    if tag_gender :
        _gender_name = tag_gender.get_text()
    else :
        _gender_p1 = tag_head.select_one(".dpos")
        _gender_p2 = tag_head.select_one(".dgram")
        if _gender_p1:
            _gender_name = _gender_p1.get_text()
            if _gender_p2:
                _gender_name += _gender_p2.get_text()
    return _gender_name

def parseHtml(word, htmlBody):

    soup = BeautifulSoup(htmlBody, 'html.parser')
    wordObj = {
        'id' : '',
        'name' : word, 
        'image_url' : '',
        'genders': {}
    }

    #先查找词性和audio  verb  noun   adj adv......
    tag_heads = soup.find_all('div', class_='pos-header dpos-h')

    for tag_head in tag_heads:

        _gender_name = getGender(tag_head)
        if _gender_name :
            #alters 形容词的比较级 最高级  动词的过去式 过去分词
            _gender_detail = {'defines' : [], 'phrases' : [], 'alters': []}
            wordObj['genders'].setdefault(_gender_name, {})

            #prounce
            try :
                tag_uk_proun_parent = tag_head.find("span", class_="uk dpron-i")
                if tag_uk_proun_parent:
                    tag_uk_proun = tag_uk_proun_parent.find("span", class_="pron dpron")
                    _gender_detail['UK_proun'] = tag_uk_proun.get_text()
            except:
                _gender_detail['UK_proun'] = ''
            try:
                tag_us_proun_parent = tag_head.find("span", class_="us dpron-i")
                if tag_us_proun_parent:
                    tag_us_proun = tag_us_proun_parent.find("span", class_="pron dpron")
                    _gender_detail['US_proun'] = tag_us_proun.get_text()
            except : 
                _gender_detail['US_proun'] = ''

            #alters bad-> worse worst
            tag_alters = tag_head.find_all("b", class_="inf dinf")
            if len(tag_alters) > 0:
                for tag_b in tag_alters:
                    _gender_detail['alters'].append(tag_b.get_text())

            tag_audios = tag_head.select("source")
            if tag_audios :
                UK_audio = None
                US_audio = None
                for tag_audio in tag_audios :
                    str_region = tag_audio.find_parent('span').previous_sibling.get_text()
                    if not US_audio and str_region.lower() == 'us' :
                        US_audio = URL_ROOT + tag_audio['src']
                    if not UK_audio and str_region.lower() == 'uk' :
                        UK_audio = URL_ROOT + tag_audio['src']
                _gender_detail['UK_audio'] = UK_audio
                _gender_detail['US_audio'] = US_audio

            wordObj['genders'][_gender_name] = _gender_detail
        
    # 1 : 通过<div class="pr entry-body__el">找到sub_parts
    # 2 : 以close为例 <div class="di-title">close</close>  该子tag中找到名字
    # 3 : <div class="posgram dpos-g hdib lmr-5" title="A word that describes an action, condition or experience.">verb</span> 在该子tag中找到gender
    # 4 ：<div class="def-block ddef_block "> 中找到英文释义  这里可能返回多个结果,  phrase parent：<div class="phrase-body dphrase_b">, normal parent :  <div class="sense-body dsense_b">
    # 5 : <span class="trans dtrans dtrans-se  break-cj"> 中找到中文释义 
    # 6 ： <div class="examp dexamp"> 找到中文例句和英文例句  
    # 7 ： <div class="pr phrase-block dphrase-block ">   查找phrase List
    # 8 : <span class="phrase-title dphrase-title">   phrase text
    # 9 : <div class="def ddef_d db"> phrase的英文释义
    # 10：<span class="trans dtrans dtrans-se  break-cj" lang="zh-Hans">    phrase的中文释义       
    # 11：<div class="examp dexamp"> phrase的中文例句和英文例句
        
    tag_sub_parts = soup.find_all('div', 'pr entry-body__el')
    for tag_root in tag_sub_parts:
       
        tag_names = tag_root.select('.di-title')
        str_name = tag_names[0].get_text()
        tag_gender = tag_root.select_one('.posgram')
        if tag_gender == None :
            continue
        str_gender = tag_gender.get_text()
        wordObj['genders'][str_gender]['text'] = str_name
     
        tag_defines = tag_root.select('.def-block, .ddef_block')
        for tag_one_define in tag_defines :
            
            tag_parent = tag_one_define.find_parent("div")
            attrs_klass = tag_parent['class']

            oneDefineObj = {"text" : "", "trans_ch" : "", "trans_en" : "", "examples" : [], "alters": []}

            # bad -> worse worst
            tag_infs = tag_one_define.select('.inf, .dinf')
            if tag_infs :
                for tag_inf in tag_infs :
                    str_inf = tag_inf.get_text()
                    if str_inf not in wordObj['genders'][str_gender]['alters']:
                        oneDefineObj['alters'].append(str_inf)

            tag_examples = tag_one_define.select('.examp, .dexamp')
            if tag_examples :
                for tag_example in tag_examples :
                    tag_ch = tag_example.select('.trans')
                    tag_en = tag_example.select('.eg')

                    if tag_ch and tag_en :
                        example_obj = { "ch" : "", "en" : ""}
                        example_obj['ch'] = tag_ch[0].get_text()
                        example_obj['en'] = tag_en[0].get_text()
                        oneDefineObj['examples'].append(example_obj)


            #中英文 词意
            if attrs_klass[0] == 'sense-body' or attrs_klass[0] == 'runon-body' :
                oneDefineObj['text'] = str_name
                oneDefineObj['trans_en'] = tag_one_define.select('.def, .ddef_d, .db')[0].get_text()
                oneDefineObj['trans_ch'] = tag_one_define.select('.trans, .dtrans, .dtrans-se, .break-cj')[0].get_text()
                # print(str_ch, ' - ', str_en)
                wordObj['genders'][str_gender]['defines'].append(oneDefineObj)    
        
            #中英文 短语
            if attrs_klass[0] == 'phrase-body' :
                tag_previous_sibling = tag_parent.previous_sibling
                oneDefineObj['text'] = tag_previous_sibling.select('.phrase-title, .dphrase-title')[0].get_text()
                oneDefineObj['trans_en'] = tag_one_define.select('.def, .ddef_d, .db')[0].get_text()
                oneDefineObj['trans_ch'] = tag_one_define.select('.trans, .dtrans, .dtrans-se, .break-cj')[0].get_text()
                wordObj['genders'][str_gender]['phrases'].append(oneDefineObj)    


    #针对<div class="pr runon drunon"> 单独处理   
    tag_runons = soup.find_all('div', 'pr runon drunon')
    if tag_runons :
        for tag_root in tag_runons:
            tag_names = tag_root.select('.runon-title')
            str_name = tag_names[0].get_text()
            str_gender = getGender(tag_root)
            wordObj['genders'][str_gender]['text'] = str_name

            tag_defines = tag_root.select('.def-block, .ddef_block')
            for tag_one_define in tag_defines :
                tag_parent = tag_one_define.find_parent("div")
                attrs_klass = tag_parent['class']

    
                oneDefineObj = {"text" : "", "trans_ch" : "", "trans_en" : "", "examples" : [], "alters" : []}
                 # bad -> worse worst
                tag_infs = tag_one_define.select('.inf, .dinf')
                if tag_infs :
                    for tag_inf in tag_infs :
                        str_inf = tag_inf.get_text()
                        if str_inf not in wordObj['genders'][str_gender]['alters']:
                            oneDefineObj['alters'].append(str_inf)

                tag_examples = tag_one_define.select('.examp, .dexamp')
                if tag_examples :
                    for tag_example in tag_examples :
                        tag_ch = tag_example.select('.trans')
                        tag_en = tag_example.select('.eg')

                        if tag_ch and tag_en :
                            example_obj = { "ch" : "", "en" : ""}
                            example_obj['ch'] = tag_ch[0].get_text()
                            example_obj['en'] = tag_en[0].get_text()
                            oneDefineObj['examples'].append(example_obj)


                #中英文 词意
                if attrs_klass[0] == 'runon-body' :
                    oneDefineObj['text'] = str_name
                    oneDefineObj['trans_en'] = tag_one_define.select('.def, .ddef_d, .db')[0].get_text()
                    oneDefineObj['trans_ch'] = tag_one_define.select('.trans, .dtrans, .dtrans-se, .break-cj')[0].get_text()
                    # print(str_ch, ' - ', str_en)
                    wordObj['genders'][str_gender]['defines'].append(oneDefineObj)    
            
                #中英文 短语
                if attrs_klass[0] == 'phrase-body' :
                    tag_previous_sibling = tag_parent.previous_sibling
                    oneDefineObj['text'] = tag_previous_sibling.select('.phrase-title, .dphrase-title')[0].get_text()
                    oneDefineObj['trans_en'] = tag_one_define.select('.def, .ddef_d, .db')[0].get_text()
                    oneDefineObj['trans_ch'] = tag_one_define.select('.trans, .dtrans, .dtrans-se, .break-cj')[0].get_text()
                    wordObj['genders'][str_gender]['phrases'].append(oneDefineObj)    
              

    return wordObj

#对Set转换为List后才能Json化
def set_to_list(obj):
    if isinstance(obj, set):
        return list(obj)
    raise TypeError(f"Object of type {type(obj)} is not JSON serializable")


def outputJsonFile(out_file_name, words_json):
    dir = 'E:/FlutterWorld/projects/my_eng_program/scripts/books'
    full_path = dir + os.sep + out_file_name

    if os.path.exists(full_path) :
        os.remove(full_path)
    json_str = json.dumps(words_json, ensure_ascii=False, default=set_to_list) #确保中文
    open(full_path, 'w', encoding="utf-8").write(json_str) 
    return


def doIt():
    try : 
        #KET Words
        # words_map = getKetWords()

        #RJB 7 UP
        words_map = getRJB7UpWords()

        # words_map = {'name' : "tst.json", "words" : ['go to work']}


        words_list = fetchDefineFromOxford(words_map['words'])
        if len(words_list) > 0 :
            _file_name = words_map['name']
            outputJsonFile(_file_name,  words_list)
            print("Success to write file : ", _file_name)
        else:
            print("words_list is empty, no need to  write json file")
        
    except Exception as e:
        print('Failed to output json file ', e)    


if __name__ == '__main__':
    doIt()    
