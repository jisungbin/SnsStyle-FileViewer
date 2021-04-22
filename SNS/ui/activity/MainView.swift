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
        VStack {
            Spacer()
            HStack {
                // https://medium.com/programming-with-swift/create-a-floating-action-button-with-swiftui-4d05dcddc365
                Spacer()
                Button(action: {
                    // todo
                }, label: {
                    Text("+")
                        .font(.system(.largeTitle))
                        .frame(width: 66, height: 60)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 7)
                })
                .background(Color.gray)
                .cornerRadius(38.5)
                .padding()
                .shadow(color: Color.gray.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
            }
        }
    }
}
