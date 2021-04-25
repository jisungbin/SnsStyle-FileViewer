//
//  FileItem.swift
//  SNS
//

import Foundation
import SwiftUI

struct FileItem: Identifiable { // 게시글 모델
    var id = UUID() // 게시글 고유 아이디
    var url: URL // 파일 주소
    var comment: String // 설명
    var time: String // 올린 시간
    var type: FileType // 파일 타입
}
