//
//  MainView.swift
//  SNS
//

import Foundation
import SwiftUI
import ToastSwiftUI
import UniformTypeIdentifiers
import Photos
import AVKit

struct MainView: View {
    @ObservedObject var vm: MainViewModel // 앱 데이터베이스 모듈 불러오기
    
    var body: some View {
        TabView {
            NewsView(vm: vm) // 뉴스 탭 바인딩
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("News")
                }
            AddItemView(vm: vm) // 아이템 추가 탭 바인딩
                .tabItem {
                    Image(systemName: "icloud.and.arrow.up.fill")
                    Text("Upload")
                }
            FavoriteView(vm: vm) // 즐찾 탭 바인딩
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorite")
                }
        }
    }
}

struct FileItemBind: View { // 아이템 바인딩 뷰
    @State var item: FileItem // 바인드할 아이템 파일
    @State var isShownDetailView: Binding<Bool> // 아이템 자세히 보기 여부
    
    var body: some View {
        if item.type == FileType.PHOTO { // 사진 아이템 바인딩
            let _ = item.url.startAccessingSecurityScopedResource() // URL(https://ko.wikipedia.org/wiki/URL) 리소스 접근 허용
            let imageData = try! Data(contentsOf: item.url)
            Image(uiImage: UIImage(data: imageData)!)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .onTapGesture { isShownDetailView.wrappedValue.toggle() }
            let _ = item.url.stopAccessingSecurityScopedResource()
        } else if item.type == FileType.VIDEO { // 비디오 아이템 바인딩
            let _ = item.url.startAccessingSecurityScopedResource()
            let player = AVPlayer(url: item.url)
            VideoPlayer(player: player)
                .onAppear() { player.play() }
                .onDisappear() { player.pause() }
                .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                .onTapGesture { isShownDetailView.wrappedValue.toggle() }
            let _ = item.url.stopAccessingSecurityScopedResource()
        } else { // Audio // 오디오 아이템 바인딩
            let _ = item.url.startAccessingSecurityScopedResource()
            let audioPlayer = try! AVAudioPlayer(contentsOf: item.url)
            HStack(alignment: .firstTextBaseline) {
                Button(action: {
                    if audioPlayer.isPlaying { audioPlayer.pause() }
                    else { audioPlayer.play() }
                }) {
                    Image(systemName: "playpause")
                        .padding(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .shadow(color: .gray, radius: 10)
                        )
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                }.padding(.trailing, 20)
                Text(item.url.lastPathComponent)
                    .padding(.leading, 20)
                    .onTapGesture { isShownDetailView.wrappedValue.toggle() }
            }
            .frame(alignment: .center)
            .onTapGesture { isShownDetailView.wrappedValue.toggle() }
            .padding()
            let _ = item.url.stopAccessingSecurityScopedResource()
        }
    }
}

struct ItemView: View { // 아이템 보여주기 뷰
    var item: FileItem
    @ObservedObject var vm: MainViewModel
    @State var trashBoolean = false
    @State var isShownDetailView = false // 아이템 자세히 보기 여부
    
    var body: some View {
        VStack {
            FileItemBind(item: item, isShownDetailView: $isShownDetailView) // 아이템 바인딩
            HStack { // 즐찾/설명 레이아웃 바인딩
                HStack() {
                    if vm.favoriteItems.contains(item.id) { // 즐찾 포함
                        Image(systemName: "heart.fill") // 채워진 하트
                            .foregroundColor(.pink)
                            .onTapGesture {
                                vm.favoriteItems.append(item.id)
                            }
                            .onLongPressGesture {
                                vm.favoriteItems.remove(at: vm.favoriteItems.firstIndex(of: item.id)!)
                            }
                    } else {
                        Image(systemName: "heart") // 빈 하트 (좋아요 0개)
                            .foregroundColor(.pink)
                            .onTapGesture {
                                vm.favoriteItems.append(item.id)
                            }
                    }
                    Text(String(vm.favoriteItems.filter { $0 == item.id }.count)) // 좋아요 개수 카운팅
                }
                Text(item.comment).frame(maxWidth: .infinity, alignment: .trailing)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .modal(isPresented: $isShownDetailView) { // 아이템 자세히 보기 바인딩
            VStack {
                HStack {
                    Image(uiImage: vm.profileImage!) // 프사
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2).shadow(radius: 10))
                        .padding(.trailing, 15)
                    Text(item.time).padding(.leading, 15)
                }.padding(.bottom, 30)
                FileItemBind(item: item, isShownDetailView: $trashBoolean) // 아이템 바인딩
                HStack() { // 즐찾/설명 바인딩
                    Text(item.comment)
                    HStack {
                        if vm.favoriteItems.contains(item.id) { // 즐찾 포함
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                                .onTapGesture {
                                    vm.favoriteItems.append(item.id)
                                }
                                .onLongPressGesture {
                                    vm.favoriteItems.remove(at: vm.favoriteItems.firstIndex(of: item.id)!)
                                }
                        } else {
                            Image(systemName: "heart")
                                .foregroundColor(.pink)
                                .onTapGesture {
                                    vm.favoriteItems.append(item.id)
                                }
                        }
                    }.frame(alignment: .trailing)
                }.frame(alignment: .leading).padding(.top, 30)
                Button(action: {
                    isShownDetailView.toggle()
                }) {
                    Text("닫기")
                        .padding(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .shadow(color: .gray, radius: 10)
                        )
                        .foregroundColor(.gray)
                }.padding(.top, 10)
            }.onTapGesture {
                isShownDetailView.toggle()
            }.padding()
        }
    }
}

struct NewsView: View {
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        if vm.fileItems.isEmpty { // 만약 게시글이 없다면
            VStack {
                LottieView(filename: "empty").frame(width: 250, height: 250)
                Text("게시글이 없어요 😥\n첫 번째 게시글을 올려보세요 :)").multilineTextAlignment(.center)
            }
        } else { // 있다면?
            ScrollView {
                VStack {
                    ForEach(vm.fileItems) { item in // 게시글 아이템별로
                        ItemView(item: item, vm: vm) // 레이아웃 바인딩
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
    
    @State private var description = "" // 아이템 설명
    @State private var fileName = "파일 선택" // 선택된 아이템 이름
    @State private var isShownPicker = false // 아이템 파일 피커 활성화 여부
    @State private var isShownToast = false // 토스트 활성화 여부
    @State private var toastMessage = "" // 토스트 메시지 내용
    @State private var toastIcon = ToastView.Icon.error // 토스트 아이콘
    @State private var selectedFile: FileItem? // 선택된 파일
    
    private func getNowTime() -> String { // 현재 시간 구하기 (업로드된 시간 구하기용)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 포멧 (https://nowonbun.tistory.com/502)
        return dateFormatter.string(from: Date())
    }
    
    var body: some View { // 선택된 파일 미리보기 (위 설명했던 구조와 동일)
        VStack {
            if selectedFile != nil {
                if selectedFile!.type == FileType.PHOTO {
                    let _ = selectedFile!.url.startAccessingSecurityScopedResource()
                    let imageData = try! Data(contentsOf: selectedFile!.url)
                    Image(uiImage: UIImage(data: imageData)!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                    let _ = selectedFile!.url.stopAccessingSecurityScopedResource()
                } else if selectedFile!.type == FileType.VIDEO {
                    let _ = selectedFile!.url.startAccessingSecurityScopedResource()
                    let player = AVPlayer(url: selectedFile!.url)
                    VideoPlayer(player: player)
                        .onAppear() { player.play() }
                        .onDisappear() { player.pause() }
                        .frame(maxWidth: .infinity, minHeight: 300, maxHeight: 300)
                    let _ = selectedFile!.url.stopAccessingSecurityScopedResource()
                } else { // Audio
                    let _ = selectedFile!.url.startAccessingSecurityScopedResource()
                    let audioPlayer = try! AVAudioPlayer(contentsOf: selectedFile!.url)
                    HStack(alignment: .firstTextBaseline) {
                        Button(action: {
                            if audioPlayer.isPlaying {
                                audioPlayer.pause()
                            } else {
                                audioPlayer.play()
                            }
                        }) {
                            Image(systemName: "playpause")
                                .padding(10.0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        .shadow(color: .gray, radius: 10)
                                )
                                .foregroundColor(.gray)
                                .padding(.top, 50)
                        }.padding(.trailing, 20)
                        Text(selectedFile!.url.lastPathComponent).padding(.leading, 20)
                    }.frame(alignment: .center)
                    let _ = selectedFile!.url.stopAccessingSecurityScopedResource()
                }
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
            }.padding(.top, 30)
            TextField("추가 메시지 입력", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 30)
            Button(action: {
                hideKeyboard() // 올리기 버튼 눌렀으면 키보드 내리기
                if fileName == "파일 선택" {
                    toastIcon = ToastView.Icon.error
                    isShownToast = true
                    toastMessage = "먼저 파일을 선택 해 주세요."
                } else {
                    let fileItem = FileItem(url: selectedFile!.url, comment: description, time: selectedFile!.time, type: selectedFile!.type)
                    vm.fileItems.append(fileItem) // 앱 데이터에 게시글(파일) 업로드
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
        .fileImporter(isPresented: self.$isShownPicker, allowedContentTypes: [.png, .jpeg, .mp3, .mpeg4Movie, .movie, .mpeg4Audio]) { (result) in // 파일 픽커 바인딩
            do {
                let fileUrl = try result.get()
                // .png, .jpeg, .mp3, .mpeg4Movie, .movie, .mpeg4Audio // 선택 가능한 파일 목록
                var fileType = FileType.PHOTO
                let fileSuffix = fileUrl.pathExtension
                if ["mp3", "m4a"].contains(fileSuffix) { // 파일 타입 구하기
                    fileType = FileType.AUDIO
                } else if ["mp4"].contains(fileSuffix) {
                    fileType = FileType.VIDEO
                }
                selectedFile = FileItem(url: fileUrl, comment: "", time: getNowTime(), type: fileType)
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
        
        if vm.favoriteItems.isEmpty { // 만약 즐찾이 없다면
            VStack { // 즐찾 유도
                LottieView(filename: "empty-favorite").frame(width: 250, height: 250)
                Text("좋아요한 게시글이 없어요 😥\n맘에 드는 게시글에 좋아요를 해 보세요 :)").multilineTextAlignment(.center)
            }
        } else { // 즐찾 있다면
            ScrollView {
                VStack {
                    ForEach(favoriteItems) { item in // 즐찾 아이템 불러와서
                        ItemView(item: item, vm: vm) // 뷰 바인딩
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
