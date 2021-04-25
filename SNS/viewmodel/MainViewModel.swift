//
//  ProfileImageData.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject { // 앱 데이터들을 담을 데이터 모델 생성 (https://developer.android.com/topic/libraries/architecture/viewmodel?hl=ko)
    @Published var profileImage: UIImage?
    @Published var isMainView = false
    @Published var fileItems = [FileItem]()
    @Published var favoriteItems = [UUID]()
}
