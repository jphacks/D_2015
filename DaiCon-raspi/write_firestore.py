import os
import firebase_admin
import json
import datetime
from firebase_admin import credentials
from firebase_admin import firestore


cred = credentials.Certificate(os.path.join("secret_key","daicon-credentials.json"))
firebase_admin.initialize_app(cred)

db = firestore.client()
docs = db.collection("TV").get()
#print(type(docs))

json_file = open("volume_up.json")
json_load = json.load(json_file)
json_file.close()

data = json_load["data"]

data2str = " ".join(map(str,data))
trainingList = ["縄跳び", "背筋", "腹筋", "腕立て", "スクワット"]


signal_ref = db.collection('TV_signal')
doc_ref = db.collection('TV').get()
doc_json = {}
for doc in doc_ref:
    doc_json[str(doc.id)] = doc.to_dict()
    #print(doc.id, doc.to_dict())

training = "腕立て"
count = 20

#print(doc_json.keys())
#print(doc_json['1ch']['training'])
"""
for k in doc_json.keys():
    if doc_json[k]["training"] == training:
        if doc_json[k]["count"] == count:
            print(type(count))
            signal_ref = db.collection('TV_signal').document(k)
            target_str = signal_ref.get().to_dict()["signal"]
            signal_data = [int(signal) for signal in target_str.split(" ")]
            print(signal_data)
            
"""

"""doc_ref.set({
    'signal': data2str
    })"""


"""date = datetime.datetime.now()
year = str(date.year)
month = "{:02d}".format(date.month)
day = "{:02d}".format(date.day)

date2str = year+month+day


doc_ref = db.collection('log').document(date2str)"""

"""
doc_ref.set({
    trainingList[0]: 31,
    trainingList[1]: 10,
    trainingList[2]: 44,
    trainingList[3]: 35,
    trainingList[4]: 11,
    'date': int(date2str)
    })
"""


docs = db.collection("log").get()
for doc in docs:
    print(doc.id, doc.to_dict())

    #if doc.to_dict()["training"] == "スクワット":
    #    print(doc.id)
    #    print(doc.to_dict()["count"])