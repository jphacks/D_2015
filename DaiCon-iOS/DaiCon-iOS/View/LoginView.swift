//
//  LoginView.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var fireviewmodel: FireViewModel
    @State var inputEmail: String = ""
    @State var inputPassword: String = ""
    var body: some View {
        ZStack {
            Image("DaiCon_back")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            Image("DaiCon_illust")
                .resizable()
                .frame(width: 300, height: 300, alignment: .bottom)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.3)
            VStack {
                Spacer()
                HStack {
                    Text("DaiCon")
                        .font(.system(size: 48, weight: .heavy))
                        .foregroundColor(Color.black)
                }
                VStack(spacing: 24) {
                    TextField("Mail address", text: $inputEmail)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                    SecureField("Password", text: $inputPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(maxWidth: 280)
                }
                .frame(height: 100)
                .padding(.bottom, 30)
                Button(action: {self.fireviewmodel.loginFlag = true},
                       label: {
                            Text("Login")
                                .fontWeight(.medium)
                                .frame(minWidth: 160)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.green)
                                .cornerRadius(8)
                })
                    .fullScreenCover(isPresented: $fireviewmodel.loginFlag,
                                 content: HomeView.init)
                Spacer()
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(FireViewModel())
    }
}
