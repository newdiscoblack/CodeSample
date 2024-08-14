//
//  ViewFactory+buildLoginView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI

extension ViewFactory {
    @ViewBuilder func buildLoginView() -> some View {
        let viewModel = LoginViewModel()
        let interactor = LoginInteractor(viewModel: viewModel)
        LoginView(viewModel: viewModel, interactor: interactor)
    }
}
