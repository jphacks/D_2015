//
//  HomeView.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI

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
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
