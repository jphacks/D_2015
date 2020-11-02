//
//  FireViewModel.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import Foundation
import Firebase

class FireViewModel: ObservableObject {
    @Published var loginFlag: Bool = false
    @Published var settingList: [TvCommand] = []
    let dataStore = Firestore.firestore()
    
    init() {
        dataStore.collection("TV").order(by: "count").addSnapshotListener { snapshot, err in
            if let snapshot = snapshot {
                self.settingList = snapshot.documents.map { message -> TvCommand  in
                    let data = message.data()
                    return TvCommand(name: message.documentID, setting: data)
                }
            }
            print(self.settingList)
        }
    }
    
    func setSetting() {
        dataStore.collection("TV").document("1ch").setData([
            "training": "腕立て",
            "count": 10]) { err in return}
    }
}
