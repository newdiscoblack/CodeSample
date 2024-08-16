//
//  ErrorPresenter.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import SwiftUI

struct ErrorPresenter: ViewModifier {
    @Binding var error: Error?

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            VStack {
                if let error = error {
                    ErrorView(error: error)
                        .transition(.move(edge: .top))
                        .onAppear {
                            dismissErrorAfter(seconds: 2)
                        }
                }
            }
            .animation(.easeInOut, value: UUID())
        }
    }

    private func dismissErrorAfter(seconds: TimeInterval) {
        Task { @MainActor in
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            withAnimation {
                error = nil
            }
        }
    }
}
