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
    var comment: String
    var image: UIImage
    var time: String
    var type: FileType
}
