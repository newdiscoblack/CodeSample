//
//  ServersView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import SwiftUI

struct ServersView: View {
    private let interactor: ServersInteracting
    
    init(interactor: ServersInteracting) {
        self.interactor = interactor
    }
    
    var body: some View {
        VStack {
            Text("Servers List")
            Button(action: interactor.logOut) {
                Text("Log out")
            }
        }
    }
}

//#Preview {
//    ServersView()
//}
