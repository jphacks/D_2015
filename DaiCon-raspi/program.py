import requests
from bs4 import BeautifulSoup
import datetime
import json

def get_program(queries):
    #パラメータ設定
    query = queries
    count = 0
    json_list = {"time":[], "station":[], "title":[], "detail":[]}

    #pageが何ページにもわたる場合があるため、初期値を用意する
    page = 1
    list1 = []  #放送日時用リスト
    list2 = []  #放送局用リスト
    list3 = []  #番組タイトル用リスト
    list4 = []  #番組の詳細

    #1pege目の内容を取得
    url = "https://tv.yahoo.co.jp/search/?q="+query+"&t=1%202%203&a=23&oa=1&s="+str(page) #地上波、BS、CS　地域設定：東京
    soup = BeautifulSoup(requests.get(url).text, "html.parser")

    dates = soup.find_all("div",class_="leftarea")
    for date in dates:
        d = date.text
        d = ''.join(d.splitlines())
        list1.append(d)

    for s in soup("span",class_="floatl"):
        s.decompose()
    tvs = soup.find_all("span",class_="pr35")
    for tv in tvs:
        list2.append(tv.text)

    titles = soup.find_all("div",class_="rightarea")
    for title in titles:
        t = title.a.text
        list3.append(t)

    details = soup.find_all("div",class_="rightarea")
    for detail in details:
        d = detail.find_all("p",class_="yjMS pb5p")
        d = d[1].text
        list4.append(d)


    #list1～list4から放送日時＋放送局＋番組タイトル＋詳細をまとめたlist_newの作成
    list_new = [x +"___"+ y for (x , y) in zip(list1,list2)]
    list_new = [x +"___"+ y for (x , y) in zip(list_new,list3)]
    list_new = [x +"___"+ y for (x , y) in zip(list_new,list4)]

    #抽出した番組の日付と現在の日付を比較し一致するものを表示
    for x  in range(len(list_new)):
        year = "2020"
        tv_str = list_new[x][:18]
        wrk = tv_str.split("/")
        month = wrk[0]
        wrk = wrk[1].split("（")
        day = wrk[0]
        wrk = wrk[1].split("）")
        weekday = wrk[0]  #予備情報　曜日

        wrk = year + month + day
        wrk = datetime.datetime.strptime(wrk, '%Y%m%d') 
        tv_day = datetime.date(wrk.year, wrk.month, wrk.day)
        today = datetime.date.today()

        if tv_day == today:
            list_program = list_new[x].split("___")
#             json_list["{}".format(count)] = {"time": list_program[0], "station": list_program[1], "title": list_program[2], "detail": list_program[3]}
            json_list["time"].append(list_program[0])
            json_list["station"].append(list_program[1])
            json_list["title"].append(list_program[2])
            json_list["detail"].append(list_program[3])

    return json.dumps(json_list, ensure_ascii=False)

