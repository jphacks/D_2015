//
//  ContentView.swift
//  Daicon_watchos WatchKit Extension
//
//  Created by 立花巧樹 on 2020/11/04.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    @EnvironmentObject var deepViewModel: DeepViewModel
    @State var resultview:Bool = false
    var body: some View {
        VStack{
        Text("DaiCon")
        .font(.largeTitle)
        .foregroundColor(.white)
        HStack{
        Text("\n")
        Picker("運動の種類", selection: $deepViewModel.muscle_state) {
            Text("腹筋").tag(deepViewModel.muscle_states[0])
            Text("背筋").tag(deepViewModel.muscle_states[1])
            Text("腕立て").tag(deepViewModel.muscle_states[2])
            Text("スクワット").tag(deepViewModel.muscle_states[3])
        }
        }
        NavigationLink(destination: ActiveView()
            .onAppear(){
                deepViewModel.record_start()
            }.onDisappear(){
                deepViewModel.record_end()
            }, isActive: $deepViewModel.page_state, label: {Text("Start")})
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(10)
        }
    }
}

struct ActiveView: View {
    @EnvironmentObject var deepViewModel: DeepViewModel
    var body: some View {
        Text(deepViewModel.muscle_states_jp[deepViewModel.muscle_state]!)
            .font(.largeTitle)
            .padding(10)
        Text("\(deepViewModel.muscle_count)回")
            .font(.system(size: 35))
            .foregroundColor(.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
