//
//  LoginView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 14/08/2024.
//

import SwiftUI

struct LoginView: View {
    @Bindable private var viewModel: LoginViewModel
    private let interactor: LoginInteracting
    
    init(
        viewModel: LoginViewModel,
        interactor: LoginInteracting
    ) {
        self.viewModel = viewModel
        self.interactor = interactor
    }
    
    var body: some View {
        VStack {
            testioHeaderView
                .padding(.bottom, 40)
            VStack(spacing: 16) {
                LoginTextField(text: $viewModel.username, purpose: .username)
                LoginTextField(text: $viewModel.password, purpose: .password)
            }
            .padding(.bottom, 24)
            AsyncButton(action: interactor.logIn) {
                logInButtonLabel
            }
        }
        .frame(maxWidth:.infinity, maxHeight: .infinity)
        .background {
            backgroundView
        }
        .ignoresSafeArea()
        .onErrorReceived($viewModel.error)
    }
    
    private var testioHeaderView: some View {
        HStack(alignment: .bottom, spacing: 4) {
            Image("testio")
            Image("testio_dot")
        }
        .frame(width: 186, height: 48)
    }
    
    private var backgroundView: some View {
        VStack {
            Spacer()
            Image("login_background")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private var logInButtonLabel: some View {
        Text("Log in")
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color.loginButtonColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 32)
    }
}

private struct LoginTextField: View {
    enum Purpose {
        case username
        case password
    }
    
    @Binding var text: String
    let purpose: Purpose
    
    var body: some View {
        HStack(spacing: 8) {
            switch purpose {
            case .username:
                Image("user_icon")
                    .frame(width: 16, height: 16)
                TextField(text: $text) {
                    Text("Username")
                        .font(.system(size: 17))
                        .foregroundStyle(
                            Color.loginTextfieldPlaceholderTextColor
                        )
                }
                .textInputAutocapitalization(.never)
            case .password:
                Image("lock_icon")
                    .frame(width: 16, height: 16)
                SecureField(text: $text) {
                    Text("Password")
                        .font(.system(size: 17))
                        .foregroundStyle(
                            Color.loginTextfieldPlaceholderTextColor
                        )
                }
                .textInputAutocapitalization(.never)
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 8)
        .background(Color.loginTextFieldBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 32)
    }
}

//#Preview {
//    LoginView(
//        viewModel: LoginViewModel(),
//        interactor: LoginInteractor(viewModel: LoginViewModel())
//    )
//}

private extension Color {
    static var loginTextFieldBackgroundColor: Color {
        Color(
            red: 118/255,
            green: 118/255,
            blue: 128.255,
            opacity: 0.12
        )
    }
    
    static var loginTextfieldPlaceholderTextColor: Color {
        Color(
            red: 60/255,
            green: 60/255,
            blue: 67/255,
            opacity: 0.6
        )
    }
    
    static var loginButtonColor: Color {
        Color(
            red: 70/255,
            green: 135/255,
            blue: 255/255,
            opacity: 1
        )
    }
}
