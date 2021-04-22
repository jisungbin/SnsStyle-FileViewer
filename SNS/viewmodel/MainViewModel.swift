//
//  ProfileImageData.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var isMainView = false
}
