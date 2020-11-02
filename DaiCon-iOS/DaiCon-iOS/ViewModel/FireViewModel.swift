//
//  FireViewModel.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import Foundation
import Firebase
import SwiftUICharts

class FireViewModel: ObservableObject {
    @Published var loginFlag: Bool = false
    @Published var settingList: [TvCommand]!
    @Published var logList: [String: [(String, Int)]]!
    let dataStore = Firestore.firestore()
    
    init() {
        dataStore.collection("TV").order(by: "count").addSnapshotListener { snapshot, err in
            if let snapshot = snapshot {
                self.settingList = snapshot.documents.map { message -> TvCommand  in
                    let data = message.data()
                    return TvCommand(name: message.documentID, setting: data)
                }
            }
            print(self.settingList!)
        }
        dataStore.collection("log").order(by: "date", descending: true).limit(to: 5).addSnapshotListener { [self] snapshot, err in
            if let snapshot = snapshot {
                self.logList = ["腹筋": [], "腕立て": [], "スクワット": [], "背筋": [], "縄跳び": []]
                let _ = snapshot.documents.map { message in
                    let data = message.data()
                    //print(message.documentID)
                    print(data)
                    for training in trainingList {
                        self.logList[training.name]!.insert((message.documentID, data[training.name] as! Int), at: 0)
                    }
                }
            }
            print(type(of: self.logList["腹筋"]!))
        }
    }
    
    func setSetting() {
        dataStore.collection("TV").document("1ch").setData([
            "training": "腕立て",
            "count": 10]) { err in return}
    }
}
