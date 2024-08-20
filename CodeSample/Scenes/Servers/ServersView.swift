//
//  ServersView.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 15/08/2024.
//

import SwiftUI

struct ServersView: View {
    @Bindable private var viewModel: ServersViewModel
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
                    ForEach(viewModel.servers, id: \.id) {
                        ServerCell(server: $0)
                    }
                } header: {
                    serversListHeader
                }
            }
            .refreshable {
                interactor.refreshServersList()
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
                        showFiltersIcon
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        interactor.logOut()
                    } label: {
                        logOutIcon
                    }
                }
            }
        }
        .onAppear {
            interactor.populateServersList()
        }
        .onErrorReceived($viewModel.error)
    }
    
    private var showFiltersIcon: some View {
        HStack(spacing: 10) {
            Image("sort_icon")
            Text("Filter")
        }
    }
    
    private var logOutIcon: some View {
        HStack(spacing: 10) {
            Text("Logout")
            Image("logout_icon")
        }
    }
    
    private var serversListHeader: some View {
        HStack {
            Text("SERVER")
                .font(.system(size: 12))
            Spacer()
            Text("DISTANCE")
                .font(.system(size: 12))
        }
    }
}

private struct ServerCell: View {
    let server: any Server
    
    var body: some View {
        HStack {
            Text(server.name)
            Spacer()
            Text("\(server.distance) km")
        }
    }
}

#Preview {
    ServersView(
        viewModel: ServersViewModel(),
        interactor: ServersInteractorMock()
    )
}

private struct ServersInteractorMock: ServersInteracting {
    func populateServersList() {}
    func refreshServersList() {}
    func showFilters() {}
    func sort(_ type: Sort) {}
    func logOut() {}
}
