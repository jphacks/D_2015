import os
import firebase_admin
import json
import irmcli
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate(os.path.join("secret_key","daicon-credentials.json"))
firebase_admin.initialize_app(cred)

db = firestore.client()
docs = db.collection("TV").get()
print(docs)
doc_ref = db.collection('TV_signal').document('Power')
print(doc_ref.get().to_dict())
str_data = doc_ref.get().to_dict()["signal"]
signal_data = [int(signal) for signal in str_data.split(" ")]
print(signal_data)

#irmcli.playIR(signal_data)