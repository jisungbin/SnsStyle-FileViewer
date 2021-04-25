//
//  ViewBinder.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import SwiftUI

struct BindView: View {
    @ObservedObject var vm = MainViewModel()
    
    var body: some View {
        if !vm.isMainView { // 로그인 화면
            SignInView(vm: vm)
        } else { // 메인 화면 (로그인 완료 상태)
            MainView(vm: vm)
        }
    }
}
