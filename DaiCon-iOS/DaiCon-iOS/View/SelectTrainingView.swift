//
//  SelectTrainingView.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI

struct SelectTrainingView: View {
    @EnvironmentObject var fireViewModel: FireViewModel
    @State var Training:String
    @State var trainingMenu:String = ""
    @State var trainingCount:Int
    @State var Signal:Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var tvCommand: TvCommand
    
    
    var body: some View {
        let currentTraining = tvCommand.setting["training"] as! String
        let currentCount = tvCommand.setting["count"] as! Int
        VStack {
            Spacer()
            HStack {
                Text(tvCommand.name)
                    .font(.system(size: 60, weight: .bold, design: .default))
            }

            Spacer()
            VStack {
                Text("Current Status")
                    .font(.system(size: 30, weight: .medium, design: .default))
                    .underline()
                Text("Training：　" + currentTraining)
                    .font(.system(size: 30, weight: .medium, design: .default))
                Text("Count：　" + String(currentCount))
                    .font(.system(size: 30, weight: .medium, design: .default))

            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.green, lineWidth: 3)
            )
                  
            HStack{
                Text("Training")
                    .frame(width: 130, height: 50, alignment: .leading)
                    .font(.title)
                Picker(selection: $Training, label:Text("Training：\(Training)")){
                    Text("腹筋").tag("腹筋")
                        .font(.title)
                    Text("背筋").tag("背筋")
                        .font(.title)
                    Text("スクワット").tag("スクワット")
                        .font(.title)
                    Text("腕立て").tag("腕立て")
                        .font(.title)
                    Text("縄跳び").tag("縄跳び")
                        .font(.title)
                }.frame(width:250, height:200)

            }
            HStack{
                Text("Count")
                    .frame(width: 130, height: 50, alignment: .leading)
                    .font(.title)
                    .offset(x: -50)
                HStack (spacing:30){
                    Button(action: {
                        if self.trainingCount > 1 {
                            self.trainingCount -= 1
                        }
                    }) {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    Text(String(trainingCount))
                        .font(.title)
                    Button(action: {
                        self.trainingCount += 1
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    }
                    
                }

            }
            VStack{
                if !Signal {
                    HStack {
                        Text("Signal")
                            .frame(width: 110, height: 50, alignment: .leading)
                            .font(.title)
                        Text("Not registerd")
                            .foregroundColor(.red)
                            .frame(width:250, height: 40)
                            .font(.title)
                    }

                    HStack {
                        Text(" ")
                            .frame(width: 100, height: 10, alignment: .leading)

                        Button(action: {
                            Signal.toggle()
                        }) {
                            Text("apply")
                                .fontWeight(.medium)
                                .frame(width: 80, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .padding(2)
                                .background(Color.green)
                                .cornerRadius(8)
                                .font(.title)
                        }.frame(width:100)
                    }
                    
                }
                else {
                    HStack {
                        Text("Signal")
                            .frame(width: 100, height: 40, alignment: .leading)
                            .font(.title)
                        Text("Registerd")
                            .foregroundColor(.blue)
                            .frame(width:250, height: 40)
                            .font(.title)
                    }

                    HStack {
                        Text(" ")
                            .frame(width: 100, height: 22, alignment: .leading)
                    }
                }

            }.frame(height:200)
            Button(action: {
                fireViewModel.setSetting(channel: tvCommand.name, training: self.Training, count: trainingCount)
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Text("Done")
            }
            .frame(width:100)
            .font(.title)
        }
    }
}

//struct SelectTrainingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectTrainingView(tvCommand: TvCommand(name: "1ch", setting: ["training": "腕立て","count": 10]), Training: "腹筋", trainingCount: 10).environmentObject(FireViewModel())
//    }
//}

