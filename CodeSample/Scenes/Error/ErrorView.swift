//
//  ErrorView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import SwiftUI

struct ErrorView: View {
    let error: Error

    var body: some View {
        VStack {
            VStack {
                Spacer()
                    .frame(height: 44)
                HStack {
                    Text(error.localizedDescription)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .ignoresSafeArea(.all)
        }
    }
}
