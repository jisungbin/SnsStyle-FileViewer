//
//  MainView.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import Foundation
import SwiftUI
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
                        // Text(item.name)
                    }
                }
            }.frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
        }
    }
}

struct AddItemView: View {
    @ObservedObject var vm: MainViewModel
    
    @State var description = ""
    @State var showDocPicker = false
    @State private var fileName = "파일 선택"
    @State private var pickedImage: UIImage?
    @State private var openFile = false
    
    var body: some View {
        VStack {
            if pickedImage != nil {
                Image(uiImage: pickedImage!)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2).shadow(radius: 10))
            }
            Button(action: {
                openFile.toggle()
            }) {
                Text(fileName)
                    .padding(10.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                            .shadow(color: .gray, radius: 10)
                    )
                    .foregroundColor(.gray)
            }
            TextField("추가 메시지 입력", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.top, 30)
        }
        .padding()
        .fileImporter(isPresented: self.$openFile, allowedContentTypes: [.png, .jpeg, .mp3, .mpeg4Movie, .movie, .mpeg4Audio]) { (result) in
            do {
                let fileUrl = try result.get()
                fileName = fileUrl.lastPathComponent
                
                guard fileUrl.startAccessingSecurityScopedResource() else { return }
                if let imageData = try? Data(contentsOf: fileUrl),
                   let image = UIImage(data: imageData) {
                    pickedImage = image
                }
                fileUrl.stopAccessingSecurityScopedResource()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct FavoriteView: View {
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        Color.red
    }
}
