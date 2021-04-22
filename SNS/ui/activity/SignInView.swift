//
//  ContentView.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import SwiftUI
import ToastSwiftUI

struct SignInView: View {
    @State private var isShownImagePicker = false
    @State private var isShownToast = false
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        VStack {
            if vm.profileImage == nil {
                Image("ic_outline_profile_512")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        self.isShownImagePicker.toggle()
                    }
            } else {
                Image(uiImage: vm.profileImage!)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2).shadow(radius: 10))
                    .onTapGesture {
                        self.isShownImagePicker.toggle()
                    }
            }
            Button(action: {
                if vm.profileImage == nil {
                    isShownToast = true
                } else {
                    vm.isMainView = true
                }
            }) {
                Text("Sign in")
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .shadow(color: .gray, radius: 10)
                    )
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
        .padding()
        .background(Color(UIColor(named:"colorPrimary")!)
                        .edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isShownImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                vm.profileImage = image
            }
        }
        .statusBarStyle(.darkContent)
        .toast(isPresenting: $isShownToast, message: "먼저 프로필 사진을 선택해 주세요.", icon: .error, autoDismiss: .after(1))
    }
}
