//
//  SettingView.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI
import QGrid

struct SettingView: View {
    init() {
       // For navigation bar background color
        UINavigationBar.appearance().backgroundColor = .white
    }
    @EnvironmentObject var fireViewModel: FireViewModel
    @State var isPresented: Bool = false
    var body: some View {
        ZStack {
            Color.black
//                .edgesIgnoringSafeArea(.all)
            VStack{
                NavigationView {
                    ZStack {
                        Color.black
//                            .edgesIgnoringSafeArea(.all)
                        QGrid(fireViewModel.settingList, columns: 3) {tvCommand in
                            GridCell(tvCommand: tvCommand)
                                .navigationTitle("Button Setting")
                        }
                    }

                }
                HStack {
                    Button(action:{print("blue")}){
                        Text("青")
                            .foregroundColor(.white)
                    }
                        .frame(width: UIScreen.main.bounds.size.width/4-15, height: 20)
                        .background(Color.blue)
                        .padding(.leading, 30)
                        .padding(.bottom, 30)
                    Button(action:{}){
                        Text("赤")
                            .foregroundColor(.white)
                    }
                        .frame(width: UIScreen.main.bounds.size.width/4-15, height: 20)
                        .background(Color.red)
                        .padding(.bottom, 30)
                    Button(action:{}){
                        Text("緑")
                            .foregroundColor(.white)
                    }
                        .frame(width: UIScreen.main.bounds.size.width/4-15, height: 20)
                        .background(Color.green)
                        .padding(.bottom, 30)
                    Button(action:{}){
                        Text("黄")
                            .foregroundColor(.white)
                    }
                        .frame(width: UIScreen.main.bounds.size.width/4-15, height: 20)
                        .background(Color.yellow)
                        .padding(.trailing, 30)
                        .padding(.bottom, 30)
                }

            }
        }
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}


