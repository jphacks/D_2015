//
//  SelectTrainingView.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI

struct SelectTrainingView: View {
    @EnvironmentObject var fireViewModel: FireViewModel
    @State var Training = 1
    @State private var trainingCount = "0"
    @State var Signal:Bool = false
    var tvCommand: TvCommand
    
    
    var body: some View {
        let currentTraining = tvCommand.setting["training"] as! String
        let currentCount = tvCommand.setting["count"] as! Int
        VStack {
            Spacer()
            HStack {
                Text(tvCommand.name)
                    .font(.largeTitle)
                    .bold()
                Button(action: {
                    fireViewModel.preSet(channel: tvCommand.name, training: currentTraining, count: currentCount)
                }) {
                    Text("Done")
                }.frame(width:100)
            }

            Spacer()
//                Text("Training")
//                    .frame(width: 300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
            VStack {
                Text("Current Status")
                    .font(.headline)
                Text("Training：　" + currentTraining)
                Text("Training：　" + String(currentCount))

            }
            HStack{
                Text("Training")
                    .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
                Picker(selection: $Training, label:Text("Training：\(Training)")){
                    Text("腹筋").tag(1)
                    Text("背筋").tag(2)
                    Text("スクワット").tag(3)
                    Text("腕立て").tag(4)
                    Text("縄跳び").tag(5)
                }.frame(width:250, height:250)
            }
            HStack{
                Text("Count")
                    .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
                TextField("回数を入力してください",text: $trainingCount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .frame(width:250)
            }
            VStack{
                if !Signal {
                    HStack {
                        Text("Signal")
                            .frame(width: 100, height: 40, alignment: .leading)
                        Text("Not registerd")
                            .foregroundColor(.red)
                            .frame(width:250, height: 40)
                    }

                    HStack {
                        Text(" ")
                            .frame(width: 100, height: 10, alignment: .leading)

                        Button(action: {
                            Signal.toggle()
                        }) {
                            Text("apply")
                                .fontWeight(.medium)
                                .frame(width: 50, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .padding(2)
                                .background(Color.green)
                                .cornerRadius(8)
                        }.frame(width:100)
                    }
                    
                }
                else {
                    HStack {
                        Text("Signal")
                            .frame(width: 100, height: 40, alignment: .leading)
                        Text("Registerd")
                            .foregroundColor(.blue)
                            .frame(width:250, height: 40)
                    }

                    HStack {
                        Text(" ")
                            .frame(width: 100, height: 22, alignment: .leading)
                    }
                }
                

            }.frame(height:250)
        }
    }
}

//struct SelectTrainingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectTrainingView(tvCommand: )
//    }
//}

