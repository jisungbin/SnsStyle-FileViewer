//
//  ContentView.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import SwiftUI
import ToastSwiftUI

struct FileItem: Identifiable {
    var id = UUID()
    var type: Int
}

struct ContentView: View {
    @State var tests = [
        FileItem(type: 8),
        FileItem(type: 5),
        FileItem(type: 10)
    ]
    
    @State private var isShownImagePicker = false
    @State private var isShownToast = false
    @State private var pickedProfileImage: UIImage?
    @State private var isLogined = false
    
    var body: some View {
        if isLogined == false {
            VStack {
                if pickedProfileImage == nil {
                    Image("ic_outline_profile_512")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            self.isShownImagePicker.toggle()
                        }
                } else {
                    Image(uiImage: pickedProfileImage!)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth:4).shadow(radius: 10))
                        .onTapGesture {
                            self.isShownImagePicker.toggle()
                        }
                }
                Button(action: {
                    if pickedProfileImage == nil {
                        isShownToast = true
                    } else {
                        self.isLogined.toggle()
                    }
                }) {
                    Text("Sign in")
                        .padding(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                                .shadow(color: .gray, radius: 10.0)
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
                    self.pickedProfileImage = image
                }
            }
            .statusBarStyle(.darkContent)
            .toast(isPresenting: $isShownToast, message: "먼저 프로필 사진을 선택해 주세요.", icon: .error, autoDismiss: .after(1))
        } else {
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-views-in-a-loop-using-foreach
            ZStack {
                ScrollView {
                    VStack {
                        ForEach(tests) { result in
                            Text("Result: \(result.type)")
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            tests.append(FileItem(type: 999))
                        }) {
                            Text("+")
                                .font(.system(.largeTitle))
                                .frame(width: 66, height: 60)
                                .foregroundColor(Color.white)
                                .padding(.bottom, 7)
                        }
                        .background(Color.gray)
                        .cornerRadius(38.5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 3,
                                x: 3,
                                y: 3)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
