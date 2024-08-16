//
//  View+onErrorReceived.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

import SwiftUI

public extension View {
    func onErrorReceived(_ error: Binding<Error?>) -> some View {
        modifier(ErrorPresenter(error: error))
    }
}
