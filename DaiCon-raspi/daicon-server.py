import subprocess
import os
import json
import irmcli
import firebase_admin
import datetime
import program

from flask import Flask, request, abort, Markup
from firebase_admin import credentials
from firebase_admin import firestore

trainingList = ["縄跳び", "背筋", "腹筋", "腕立て", "スクワット"]
cred = credentials.Certificate(os.path.join("secret_key","daicon-credentials.json"))
firebase_admin.initialize_app(cred)
app = Flask(__name__)

@app.route("/")
def home():
    html = """
    <form action="/controller">
        <label>Controll target: </label>
        <input type="text" name="query">
        <button type="submit" formmethod="post">Send signal</button>
    </form>
    <form action="/register">
        <label>Regist target: </label>
        <input type="text" name="query">
        <button type="submit" formmethod="post">Regist signal</button>
    </form>
    """
    
    return Markup(html)
    

@app.route("/controller",methods=["GET","POST"])
def controller():
    
    #if request.method == "GET":
    #    return request.args.get("query","")
    print("Request Type:",request.method)
    
    db = firestore.client()
    signal_ref = db.collection('TV_signal')
    docs = db.collection("TV").get()
    doc_json = {}
    for doc in docs:
        doc_json[str(doc.id)] = doc.to_dict()
        #print(doc.id, doc.to_dict())
    
    print(request)
    if request.method == "POST":
        #if os.path.exists(request.form["query"]+".json"):
        #json_file = open(request.form["query"]+".json","r")
        #json_load = json.load(json_file)
        #json_file.close()
        
        try:
        
            training = request.form["training"]
            count = request.form["count"]
            #training = '腹筋'
            #count = 1
            print("training:{},count:{}".format(training,count))
            
            
            for k in doc_json.keys():
                if doc_json[k]["training"] == training:
                    if doc_json[k]["count"] == int(count):
                        hit_key = k
                        signal_ref = db.collection('TV_signal').document(k)
                        target_str = signal_ref.get().to_dict()["signal"]
                        signal_data = [int(signal) for signal in target_str.split(" ")]
                        #print(signal_data)
            
            print("sent")
            irmcli.playIR(signal_data)
            #subprocess.run(["python3","irmcli.py","-p","-f",request.form["query"]+".json"])

            date = datetime.datetime.now()
            year = str(date.year)
            month = "{:02d}".format(date.month)
            day = "{:02d}".format(date.day)
            
            date2str = year+month+day
            print(date2str)
            log_ref = db.collection('log').get()
            log_json = {}
            
            if date2str in log_ref.keys():
                for doc in log_ref:
                    log_json[str(doc.id)] = doc.to_dict()
                    
                log_json[date2str][training] += int(count)
                print(log_json[date2str])
                
                target_ref = db.collection('log').document(date2str)
                target_ref.set(log_json[date2str])
            
            else:
                initial_log = {
                            trainingList[0]: 0,
                            trainingList[1]: 0,
                            trainingList[2]: 0,
                            trainingList[3]: 0,
                            trainingList[4]: 0,
                            'date': int(date2str)
                        }
                initial_log[training] += count
                
                target_ref = db.collection('log').document(date2str)
                target_ref.set(initial_log)
            
            
            result = {"result":"Success"}
            result = json.dumps(result,indent=2)
            
            return result
            #return """
            #    <h1>You sent {} signal.</h1>
            #    <form action="/controller">
            #        <label>Controll target: </label>
            #        <input type="text" name="query">
            #        <button type="submit" formmethod="post">Send signal</button>
            #    </form>
            #    <button><a href="/">Return to main page</a></button>
            #    <p>{}</p>
            #    """.format(hit_key,signal_data)
        
        except:
            result = {"result":"Fail"}
            result = json.dumps(result,indent=2)
            return result
            #return """
            #        <h1>Failed...</h1>
            #        <h2>You can retry to sent signal</h2>
            #        <form action="/controller">
            #            <label>Controll target: </label>
            #            <input type="text" name="query">
            #            <button type="submit" formmethod="post">Send signal</button>
            #        </form>
            #        <form action="/">
            #            <button>Return to main page</button>
            #        </form>
            #        """
    else:
        return "Get request"
    
    

@app.route("/register",methods=["GET","POST"])
def register():
    
    db = firestore.client()
    
    if request.method == "POST":
        
        detail = request.form["detail"]
        #detail = "DUMMY"
        #training = request.form["training"]
        #count = request.form["count"]
        
        #result = subprocess.run(["python3","irmcli.py","-c","-f",request.form["query"]+".json"])
        try:
            data = irmcli.captureIR(detail+".json")
            if data == None or data == []:
                result = {"result":"Fail"}
                result = json.dumps(result, indent=2)
                return result
        #if result.returncode == 0 and os.path.exists(request.form["query"]+".json") == True:
            
            set_json = {
                "signal": " ".join(map(str,data))
                }
            print(set_json)
            
            target_ref = db.collection('TV_signal').document(detail)           
            target_ref.set(set_json)
            
            print("success")
            
            result = {"result":"Success"}
            result = json.dumps(result, indent=2)
            
            return result
            
            #return """
            #    <h1>Success({}.json)</h1>
            #    <form action="/">
            #        <button>Return to main page</button>
            #    </form>
            #    <p>{}</p>
            #    """.format(request.form["query"],data)
        
        #else:
        except:
             print("failed")
             
             result = {"result":"Fail"}
             result = json.dumps(result, indent=2)
             return result
             #return """
             #   <h1>Failed({}.json)</h1>
             #   <p>you can retry to register signal</p>
             #   <form action="/register">
             #       <label>Regist target: </label>
             #       <input type="text" name="query">
             #       <button type="submit" formmethod="post">Regist signal</button>
             #   </form>
             #   <form action="/">
             #       <button>Return to main page</button>
             #   </form>
             #   """.format(request.form["query"])

    else:
        result = {"result":"Fail"}
        result = json.dumps(result, indent=2)
        return result
            #"""
            #<p>None</p>
            #<form action="/">
            #            <button>Return</button>
            #</form>
            #"""


@app.route("/program",methods=["GET","POST"])
def program_func():
    if request.method == "POST":
        return program.get_program(request.form["tv1"])
        

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")

