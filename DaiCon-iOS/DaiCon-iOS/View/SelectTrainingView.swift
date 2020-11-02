//
//  SelectTrainingView.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI

struct SelectTrainingView: View {
    @EnvironmentObject var fireViewModel: FireViewModel
    @State var Training:String = "腹筋"
    @State var trainingMenu:String = ""
    @State private var trainingCount = 1
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
            }

            Spacer()
            VStack {
                Text("Current Status")
                    .font(.headline)
                Text("Training：　" + currentTraining)
                Text("Count：　" + String(currentCount))

            }
            HStack{
                Text("Training")
                    .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
                Picker(selection: $Training, label:Text("Training：\(Training)")){
                    Text("腹筋").tag("腹筋")
                    Text("背筋").tag("背筋")
                    Text("スクワット").tag("スクワット")
                    Text("腕立て").tag("腕立て")
                    Text("縄跳び").tag("縄跳び")
                }.frame(width:250, height:250)

            }
            HStack{
                Text("Count")
                    .frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
                Button(action: {
                    if self.trainingCount > 1 {
                        self.trainingCount -= 1
                    }
                }) {
                    Image(systemName: "minus.circle")
                }
                Text(String(trainingCount))
                Button(action: {
                    self.trainingCount += 1
                }) {
                    Image(systemName: "plus.circle")
                }
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
            Button(action: {
                fireViewModel.setSetting(channel: tvCommand.name, training: self.Training, count: trainingCount)
            }) {
                Text("Done")
            }
            .frame(width:100)
            .font(.title)
        }
    }
}

struct SelectTrainingView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTrainingView(tvCommand: TvCommand(name: "1ch", setting: ["training": "腕立て","count": 10])).environmentObject(FireViewModel())
    }
}

