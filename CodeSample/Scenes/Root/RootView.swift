//
//  RootView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom,spacing: 4) {
                Image("testio")
                Image("testio_dot")
            }
            .frame(width: 186, height: 48)
            ProgressView()
                .tint(.gray)
            Spacer()
        }
        .background(Color.white)
    }
}
