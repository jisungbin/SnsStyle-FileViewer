//
//  FileItem.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import Foundation

struct FileItem: Identifiable {
    var id = UUID()
    var comment: String
    var fileUrl: URL
}
