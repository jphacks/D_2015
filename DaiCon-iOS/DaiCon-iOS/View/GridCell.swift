//
//  GridCell.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI

struct GridCell: View {
    @State var isPresented: Bool = false
    var tvCommand: TvCommand
    var body: some View {
        Button(action: {self.isPresented.toggle()}) {
            VStack {
                Image(tvCommand.name)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 100, height: 100)
                Text(tvCommand.name)
                    .foregroundColor(.black)
            }
        }
        .sheet(isPresented: $isPresented) {
            SelectTrainingView()
        }
    }
}

struct GridCell_Previews: PreviewProvider {
    static var previews: some View {
        GridCell(tvCommand: TvCommand(name: "person", setting: ["count": 10, "training": "腹筋"]))
    }
}
