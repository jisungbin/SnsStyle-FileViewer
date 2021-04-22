//
//  ViewBinder.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import SwiftUI

struct ViewBind: View {
    @ObservedObject var vm = MainViewModel()
    
    var body: some View {
        if !vm.isMainView {
            SignInView(vm: vm)
        } else {
            MainView(vm: vm)
        }
    }
}
