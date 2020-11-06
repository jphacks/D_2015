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
    var channel_name: [String] = ["VolumeDown", "VolumeUp", "Power", "1ch", "2ch", "3ch", "4ch", "5ch", "6ch","7ch", "8ch", "9ch","10ch", "11ch", "12ch"]
    
    init() {
        dataStore.collection("TV").order(by: "count").addSnapshotListener { snapshot, err in
            if let snapshot = snapshot {
                self.settingList = snapshot.documents.map { message -> TvCommand  in
                    let data = message.data()
                    
                    return TvCommand(name: message.documentID, setting: data)
                }
            }
            var tmp:TvCommand
            for num in 0..<self.settingList.count {
                for k in num..<self.settingList.count{
                    if self.settingList[k].name == self.channel_name[num]{
                        tmp = self.settingList[k]
                        self.settingList[k] = self.settingList[num]
                        self.settingList[num] = tmp
                    }
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
    
    func setSetting(channel:String, training:String, count:Int) {
        dataStore.collection("TV").document(channel).setData([
            "training": training,
            "count": count]) { err in return}
    }
    func setFavorite(name1:String, name2:String, name3:String) {
        dataStore.collection("Like").document("genre").setData(["tv1": name1, "tv2": name2, "tv3": name3]){err in return}
    }
}

//struct FireViewModel_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
