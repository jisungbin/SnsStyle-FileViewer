//
//  ContentView.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/21.
//

import SwiftUI
import ToastSwiftUI

struct ContentView: View {
    @State private var isShownImagePicker = false
    @State private var isShownToast = false
    @State private var pickedProfileImage: UIImage?
    
    var body: some View {
        VStack {
            if pickedProfileImage == nil {
                Image("ic_outline_profile_512")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                    .onTapGesture {
                        self.isShownImagePicker.toggle()
                    }
            } else {
                Image(uiImage: pickedProfileImage!)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth:4).shadow(radius: 10))
                    .onTapGesture {
                        self.isShownImagePicker.toggle()
                    }
            }
            Button(action: {
                if pickedProfileImage == nil {
                    isShownToast = true
                } else {
                    // todo
                }
            }) {
                Text("Sign in")
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .shadow(color: .white, radius: 10.0)
                    )
                    .foregroundColor(.white)
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
                self.pickedProfileImage = image
            }
        }
        .statusBarStyle(.lightContent)
        .toast(isPresenting: $isShownToast, message: "먼저 프로필 사진을 선택해 주세요.", icon: .error, autoDismiss: .after(1))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
