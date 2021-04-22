//
//  FileItem.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import Foundation
import SwiftUI

struct FileItem: Identifiable {
    var id = UUID()
    var url: URL
    var comment: String
    var time: String
    var type: FileType
}
