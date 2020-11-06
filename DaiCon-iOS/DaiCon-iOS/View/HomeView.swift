//
//  HomeView.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI
import Alamofire

struct HomeView: View {
    @EnvironmentObject var fireViewModel: FireViewModel
    var body: some View {
        TabView {
            LogView()
                .tabItem{
                    VStack {
                        Image(systemName: "heart.fill")
                        Text("Life Log")
                    }
                }
            SettingView()
                .tabItem{
                    VStack {
                        Image(systemName: "gear")
                        Text("Setting")
                    }
                }
            FavoriteView()
                .tabItem{
                    VStack {
                        Image(systemName: "tv")
                        Text("Favorite")
                    }
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct FavoriteView: View {
    @EnvironmentObject var fireViewModel: FireViewModel
    @State private var name1 = ""
    @State private var name2 = ""
    @State private var name3 = ""
    @State var programList = [Program]()
    
    func delete() {
        programList.removeAll()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("好きなジャンル1", text: $name1)
                    .font(.body)
                    .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
                    .padding(5)  // 余白を追加
                TextField("好きなジャンル2", text: $name2)
                    .font(.body)
                    .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
                    .padding(5)  // 余白を追加
                TextField("好きなジャンル3", text: $name3)
                    .font(.body)
                    .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
                    .padding(5)  // 余白を追加
                Button(action: {
                    delete()
                    fireViewModel.setFavorite(name1:name1, name2:name2, name3:name3)

                    let url = "http://172.20.10.14:5000/program"
                    let parameters:[String:String] = ["tv1": name1, "tv2": name2, "tv3": name3]

                    AF.request(url, method: .post, parameters: parameters).responseJSON {response in
                        let decoder = JSONDecoder()
                        let product = try! decoder.decode(responseTV.self, from: response.data!)

                        let programCount = product.time.count
                        print(programList)

                        for i in 0..<programCount {
                            self.programList.append(Program(proTime:product.time[i], proStation: product.station[i], proTitle:product.title[i], proDetail:product.detail[i]))
                        }

                    }
                }) {
                    Text("Send")
                        .fontWeight(.medium)
                        .frame(minWidth: UIScreen.main.bounds.size.width, minHeight: 40)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .padding(2)
                        .font(.body)
                }
                List {
                    ForEach(self.programList){ program in
                        VStack{
                            Text(program.proTitle)
                                .padding(10)
                                .font(.headline)
                                .background(Color.green)
                                .foregroundColor(Color.white)
                                .frame(alignment: .center)
                            Text(program.proStation)
                                .font(.callout)
                                .padding(5)
                            Text(program.proTime)
                                .font(.callout)
                                .padding(5)
                            Text(program.proDetail)
                                .font(.footnote)
                                .padding(5)
                                .padding(.bottom, 20)
                        }
                    }
                }
                .frame(width:UIScreen.main.bounds.size.width, alignment: .center)
                Spacer()
            }
            .navigationTitle("Favorite")
            .font(.title)
        }
        
    }
}


struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}

struct responseTV:Codable {
    let time: [String]
    let station: [String]
    let title: [String]
    let detail: [String]
}


