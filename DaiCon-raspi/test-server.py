import subprocess
import os
import json
import irmcli
import firebase_admin

from flask import Flask, request, abort, Markup
from firebase_admin import credentials
from firebase_admin import firestore

#cred = credentials.Certificate(os.path.join("secret_key","daicon-credentials.json"))
#firebase_admin.initialize_app(cred)
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
    if request.method == "POST":
        
        print(request)
        
        if os.path.exists(request.form["query"]+".json"):
            json_file = open(request.form["query"]+".json","r")
            json_load = json.load(json_file)
            json_file.close()
            
            data = json_load["data"]
            
            irmcli.playIR(data)
            #subprocess.run(["python3","irmcli.py","-p","-f",request.form["query"]+".json"])
            
            return """
                <h1>You sent {} signal.</h1>
                <form action="/controller">
                    <label>Controll target: </label>
                    <input type="text" name="query">
                    <button type="submit" formmethod="post">Send signal</button>
                </form>
                <button><a href="/">Return to main page</a></button>
                <p>{}</p>
                """.format(request.form["query"],data)
        else:
            return """
                    <h1>Failed...</h1>
                    <h2>You can retry to sent signal</h2>
                    <form action="/controller">
                        <label>Controll target: </label>
                        <input type="text" name="query">
                        <button type="submit" formmethod="post">Send signal</button>
                    </form>
                    <form action="/">
                        <button>Return to main page</button>
                    </form>
                    """
    else:
        return "Get request"
    
    

@app.route("/register",methods=["GET","POST"])
def register():
    
    if request.method == "POST":
        
        #result = subprocess.run(["python3","irmcli.py","-c","-f",request.form["query"]+".json"])
        try:
            data = irmcli.captureIR(request.form["query"]+".json")
            if data == None or data == []:
                print(x)
        #if result.returncode == 0 and os.path.exists(request.form["query"]+".json") == True:
            print("success")
            return """
                <h1>Success({}.json)</h1>
                <form action="/">
                    <button>Return to main page</button>
                </form>
                <p>{}</p>
                """.format(request.form["query"],data)
        
        #else:
        except:
             print("failed")
             return """
                <h1>Failed({}.json)</h1>
                <p>you can retry to register signal</p>
                <form action="/register">
                    <label>Regist target: </label>
                    <input type="text" name="query">
                    <button type="submit" formmethod="post">Regist signal</button>
                </form>
                <form action="/">
                    <button>Return to main page</button>
                </form>
                """.format(request.form["query"])

    else:
        return """
            <p>None</p>
            <form action="/">
                        <button>Return</button>
            </form>
            """


if __name__ == "__main__":
    app.run(debug=True)
