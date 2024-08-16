//
//  ServersView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import SwiftUI

struct ServersView: View {
    @ObservedObject private var viewModel: ServersViewModel
    private let interactor: ServersInteracting
    
    init(
        viewModel: ServersViewModel,
        interactor: ServersInteracting
    ) {
        self.viewModel = viewModel
        self.interactor = interactor
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(viewModel.servers, id: \.id) { server in
                        HStack {
                            Text(server.name)
                            Spacer()
                            Text("\(server.distance) km")
                        }
                    }
                } header: {
                    HStack {
                        Text("SERVER")
                            .font(.system(size: 12))
                        Spacer()
                        Text("DISTANCE")
                            .font(.system(size: 12))
                    }
                }
            }
            .confirmationDialog(
                "",
                isPresented: $viewModel.shouldShowFilters
            ) {
                Button("By distance") {
                    interactor.sort(.byDistance)
                }
                Button("Alphabetical") {
                    interactor.sort(.alphabetically)
                }
            }
            .navigationTitle("Testio.")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        interactor.showFilters()
                    } label: {
                        HStack(spacing: 10) {
                            Image("sort_icon")
                            Text("Filter")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        interactor.logOut()
                    } label: {
                        HStack(spacing: 10) {
                            Text("Logout")
                            Image("logout_icon")
                        }
                    }
                }
            }
        }
        .onAppear {
            interactor.populateServersList()
        }
    }
}

#Preview {
    ServersView(
        viewModel: ServersViewModel(),
        interactor: ServersInteractorMock()
    )
}

struct ServersInteractorMock: ServersInteracting {
    func populateServersList() {}
    func showFilters() {}
    func sort(_ type: Sort) {}
    func logOut() {}
}
