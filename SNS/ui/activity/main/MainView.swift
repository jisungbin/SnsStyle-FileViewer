//
//  MainView.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import Foundation
import SwiftUI
import ToastSwiftUI
import UniformTypeIdentifiers
import Photos

struct MainView: View {
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        TabView {
            NewsView(vm: vm)
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("News")
                }
            AddItemView(vm: vm)
                .tabItem {
                    Image(systemName: "icloud.and.arrow.up.fill")
                    Text("Upload")
                }
            FavoriteView(vm: vm)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorite")
                }
        }
    }
}

struct PhotoView: View {
    var item: FileItem
    @ObservedObject var vm: MainViewModel
    
    
    var body: some View {
        VStack {
            Image(uiImage: item.image)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
            HStack {
                HStack {
                    if vm.favoriteItems.contains(item.id) { // 즐찾 포함
                        Image(systemName: "heart.fill")
                            .onTapGesture {
                                vm.favoriteItems.append(item.id)
                            }
                    } else {
                        Image(systemName: "heart")
                            .onTapGesture {
                                vm.favoriteItems.append(item.id)
                            }
                    }
                    Text(String(vm.favoriteItems.filter { $0 == item.id }.count))
                }
                Text(item.comment)
            }.frame(maxWidth: .infinity).background(Color.blue)
        }.padding().frame(maxWidth: .infinity).background(Color.red)
    }
}

struct VideoView: View {
    var item: FileItem
    
    var body: some View {
        Color.red
    }
}

struct AudioView: View {
    var item: FileItem
    
    var body: some View {
        Color.red
    }
}

struct NewsView: View {
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        if vm.fileItems.isEmpty {
            VStack {
                LottieView(filename: "empty").frame(width: 250, height: 250)
                Text("게시글이 없어요 😥\n첫 번째 게시글을 올려보세요 :)").multilineTextAlignment(.center)
            }
        } else {
            ScrollView {
                VStack {
                    ForEach(vm.fileItems) { item in
                        switch item.type {
                        case FileType.PHOTO: PhotoView(item: item, vm: vm)
                        case FileType.VIDEO: VideoView(item: item)
                        default: AudioView(item: item)
                        }
                    }
                }
            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
        }
    }
}

struct AddItemView: View {
    @ObservedObject var vm: MainViewModel
    
    @State private var description = ""
    @State private var showDocPicker = false
    @State private var fileName = "파일 선택"
    @State private var pickedImage: UIImage?
    @State private var isShownPicker = false
    @State private var isShownToast = false
    @State private var toastMessage = ""
    @State private var toastIcon = ToastView.Icon.error
    
    private func getNowTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    var body: some View {
        VStack {
            if pickedImage != nil {
                Image(uiImage: pickedImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 30)
            }
            Button(action: {
                isShownPicker.toggle()
            }) {
                Text(fileName)
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .shadow(color: .gray, radius: 10)
                    )
                    .foregroundColor(.gray)
                    .padding(.bottom, 30)
            }
            TextField("추가 메시지 입력", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 30)
            Button(action: {
                if fileName == "파일 선택" {
                    toastIcon = ToastView.Icon.error
                    isShownToast = true
                    toastMessage = "먼저 항목을 선택 해 주세요."
                } else {
                    let fileItem = FileItem(comment: description, image: pickedImage!, time: getNowTime(), type: FileType.PHOTO)
                    vm.fileItems.append(fileItem)
                    toastIcon = ToastView.Icon.success
                    isShownToast = true
                    toastMessage = "업로드 완료!"
                }
            }) {
                Text("업로드!")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
        }
        .padding()
        .fileImporter(isPresented: self.$isShownPicker, allowedContentTypes: [.png, .jpeg, .mp3, .mpeg4Movie, .movie, .mpeg4Audio]) { (result) in
            do {
                let fileUrl = try result.get()
                fileName = fileUrl.lastPathComponent
                
                guard fileUrl.startAccessingSecurityScopedResource() else {
                    toastIcon = ToastView.Icon.error
                    isShownToast = true
                    toastMessage = "Error at show image."
                    return
                }
                if let imageData = try? Data(contentsOf: fileUrl),
                   let image = UIImage(data: imageData) {
                    pickedImage = image
                }
                fileUrl.stopAccessingSecurityScopedResource()
            } catch {
                toastIcon = ToastView.Icon.error
                isShownToast = true
                toastMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        }.toast(isPresenting: $isShownToast, message: toastMessage, icon: toastIcon, autoDismiss: .after(1))
    }
}

struct FavoriteView: View {
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        Color.red
    }
}
