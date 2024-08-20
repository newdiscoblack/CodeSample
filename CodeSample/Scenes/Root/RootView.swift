//
//  RootView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI

struct RootView: View {
    private let interactor: RootViewInteracting
    
    init(interactor: RootViewInteracting) {
        self.interactor = interactor
    }
    
    @State private var scale = 50.0
    var body: some View {
        VStack {
            Spacer()
            testioHeaderView
            ProgressView()
                .tint(.gray)
            Spacer()
        }
        .background(Color.white)
        .onAppear {
            interactor.onAppear()
        }
    }
    
    private var testioHeaderView: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Image("testio")
            Image("testio_dot")
        }
        .frame(width: 186, height: 48)
    }
}
