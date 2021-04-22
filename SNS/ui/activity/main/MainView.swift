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
import AVKit

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

struct ItemView: View {
    var item: FileItem
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        VStack {
            if item.type == FileType.PHOTO {
                let _ = item.url.startAccessingSecurityScopedResource()
                let imageData = try! Data(contentsOf: item.url)
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                let _ = item.url.stopAccessingSecurityScopedResource()
            } else if item.type == FileType.VIDEO {
                Text("TODO")
            } else { // Audio
                let _ = item.url.startAccessingSecurityScopedResource()
                let audioPlayer = try! AVAudioPlayer(contentsOf: item.url)
                HStack {
                    Button(action: {
                        audioPlayer.play()
                    }) {
                        Image(systemName: "play.circle")
                            .padding(10.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .shadow(color: .gray, radius: 10)
                            )
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    }.padding(.trailing, 30)
                    Button(action: {
                        audioPlayer.pause()
                    }) {
                        Image(systemName: "pause.circle")
                            .padding(10.0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(lineWidth: 2)
                                    .shadow(color: .gray, radius: 10)
                            )
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                    }.padding(.leading, 30)
                }.frame(maxWidth: .infinity, alignment: Alignment.center).padding()
                let _ = item.url.stopAccessingSecurityScopedResource()
            }
            HStack {
                HStack() {
                    if vm.favoriteItems.contains(item.id) { // 즐찾 포함
                        Image(systemName: "heart.fill")
                            .onTapGesture {
                                vm.favoriteItems.append(item.id)
                            }
                            .onLongPressGesture {
                                vm.favoriteItems.remove(at: vm.favoriteItems.firstIndex(of: item.id)!)
                            }
                    } else {
                        Image(systemName: "heart")
                            .onTapGesture {
                                vm.favoriteItems.append(item.id)
                            }
                    }
                    Text(String(vm.favoriteItems.filter { $0 == item.id }.count))
                }
                Text(item.comment).frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.padding().frame(maxWidth: .infinity)
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
                        ItemView(item: item, vm: vm)
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
    @State private var fileUrl: URL?
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
                hideKeyboard()
                if fileName == "파일 선택" {
                    toastIcon = ToastView.Icon.error
                    isShownToast = true
                    toastMessage = "먼저 파일을 선택 해 주세요."
                } else {
                    // .png, .jpeg, .mp3, .mpeg4Movie, .movie, .mpeg4Audio
                    var fileType = FileType.PHOTO
                    let fileSuffix = fileUrl!.pathExtension
                    if ["mp3", "m4a"].contains(fileSuffix) {
                        fileType = FileType.AUDIO
                    } else if ["mp4"].contains(fileSuffix) {
                        fileType = FileType.VIDEO
                    }
                    let fileItem = FileItem(url: fileUrl!, comment: description, time: getNowTime(), type: fileType)
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
                self.fileUrl = fileUrl
                fileName = fileUrl.lastPathComponent
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
        let favoriteItems = vm.fileItems.filter { (item: FileItem) -> Bool in return vm.favoriteItems.contains(item.id) }
        
        if vm.favoriteItems.isEmpty {
            VStack {
                LottieView(filename: "empty-favorite").frame(width: 250, height: 250)
                Text("좋아요한 게시글이 없어요 😥\n맘에 드는 게시글에 좋아요를 해 보세요 :)").multilineTextAlignment(.center)
            }
        } else {
            ScrollView {
                VStack {
                    ForEach(favoriteItems) { item in
                        ItemView(item: item, vm: vm)
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

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
