//
//  MainView.swift
//  SNS
//
//  Created by Ji Sungbin on 2021/04/22.
//

import Foundation
import SwiftUI

struct MainView: View {
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        TabView {
            NewsView(vm: vm)
                .tabItem {
                    Image(systemName: "phone.fill")
                    Text("First Tab")
                }
            FavoriteView(vm: vm)
                .tabItem {
                    Image(systemName: "tv.fill")
                    Text("Second Tab")
                }
            AddItemView(vm: vm)
                .tabItem {
                    Image(systemName: "tv.fill")
                    Text("Second Tab")
                }
        }
    }
}

struct NewsView: View {
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.fileItems) { item in
                    Text(item.name)
                }
            }
        }.frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}

struct AddItemView: View {
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        Color.blue
    }
}

struct FavoriteView: View {
    @ObservedObject var vm: MainViewModel
    
    var body: some View {
        Color.red
    }
}
