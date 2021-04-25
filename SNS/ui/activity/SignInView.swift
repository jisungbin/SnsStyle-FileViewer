//
//  ContentView.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import SwiftUI
import ToastSwiftUI

struct SignInView: View { // 로그인 화면
    @State private var isShownImagePicker = false // 이미지 픽커 활성화 상태 여부
    @State private var isShownToast = false // 토스트 활성화 상태 여부
    @ObservedObject var vm: MainViewModel // 앱 데이터베이스 모델 불러오기
    
    var body: some View {
        VStack {
            if vm.profileImage == nil { // 프사 선택됐는지 여부
                Image(systemName: "person.crop.circle") // 기본 프사
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        isShownImagePicker.toggle()
                    }
            } else {
                Image(uiImage: vm.profileImage!) // 선택된 프사
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2).shadow(radius: 10))
                    .onTapGesture {
                        isShownImagePicker.toggle()
                    }
            }
            Button(action: { // 로그인 버튼
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
        .background(Color.white).edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isShownImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                vm.profileImage = image
            }
        }
        .statusBarStyle(.darkContent)
        .toast(isPresenting: $isShownToast, message: "먼저 프로필 사진을 선택해 주세요.", icon: .error, autoDismiss: .after(1)) // 토스트 바인딩 (토스트: https://developer.android.com/guide/topics/ui/notifiers/toasts?hl=ko)
    }
}
