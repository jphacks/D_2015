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
        VStack {
            Spacer()
            HStack {
                Text("DaiCon")
                    .font(.system(size: 48, weight: .heavy))
                    .offset(x:25)
                Image("DaiCon_illust")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .offset(x:25)
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
            Button(action: {self.fireviewmodel.loginFlag = true},
                   label: {
                        Text("Login")
                            .fontWeight(.medium)
                            .frame(minWidth: 160)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.accentColor)
                            .cornerRadius(8)
            })
                .fullScreenCover(isPresented: $fireviewmodel.loginFlag,
                             content: HomeView.init)
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(FireViewModel())
    }
}
