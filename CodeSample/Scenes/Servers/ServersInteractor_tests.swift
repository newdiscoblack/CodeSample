//
//  ServersInteractor_tests.swift
//  CodeSampleTests
//
//  Created by Kacper Jagiełło on 19/08/2024.
//

import Foundation
import Quick
import Nimble

@testable import CodeSample

class ServersInteractorSpec: AsyncSpec {
    override class func spec() {
        describe("ServersInteractor") {
            var sut: ServersInteractor!
            var authorizer: AuthorizerSpy!
            var storedServersListService: StoredServersListServiceSpy!
            var remoteServersListService: RemoteServersListServiceSpy!
            var viewModel: ServersViewModel!
            
            beforeEach {
                authorizer = .init()
                storedServersListService = .init()
                remoteServersListService = .init()
                viewModel = .init()
                sut = .init(
                    authorizer: authorizer,
                    storedServersListService: storedServersListService,
                    remoteServersListService: remoteServersListService,
                    viewModel: viewModel
                )
            }
            
            afterEach {
                authorizer = nil
                storedServersListService = nil
                remoteServersListService = nil
                viewModel = nil
                sut = nil
            }
            
            context("given there are is no servers list stored") {
                context("when populating servers list") {
                    let expectedServers = [
                        ApiServer(name: "a_server", distance: 100),
                        ApiServer(name: "b_server", distance: 500)
                    ]
                    
                    beforeEach {
                        storedServersListService
                            .fetchServersListReturnValue = []
                        remoteServersListService
                            .fetchServersListReturnValue = expectedServers
                        await sut.populateServersList()
                    }
                    
                    it("will try to fetch servers list data from the api") {
                        await expect(remoteServersListService.fetchServersListCallsCount)
                            .toEventually(equal(1))
                    }
                    
                    it("will present servers list to the user") {
                        await expect(viewModel.servers as? [ApiServer])
                            .toEventually(equal(expectedServers))
                    }
                    
                    it("will store new servers list") {
                        await expect(
                            matchServers(
                                expectedServers,
                                storedServersListService.storeNewServersListCapturedServersList!
                            )
                        ).toEventually(beTrue())
                    }
                }
            }
            
            context("given there is an error while fetching servers list data from the api") {
                struct FetchServersListError: Error, Equatable {}
                let expectedError = FetchServersListError()
                
                beforeEach {
                    remoteServersListService
                        .fetchServersListThrowableError = expectedError
                    await sut.populateServersList()
                }
                
                it("will present the error") {
                    await expect(viewModel.error)
                        .toEventually(matchByDescription(expectedError))
                }
                
                it("will not populate servers list") {
                    await expect(viewModel.servers)
                        .toEventually(beEmpty())
                }
                
                it("will not try to store any server related data") {
                    await expect(storedServersListService.storeNewServersListCallsCount)
                        .toEventually(equal(0))
                }
            }
            
            context("given there is an existing sorting method selected") {
                beforeEach {
                    viewModel.selectedSortingMethod = .byDistance
                    remoteServersListService.fetchServersListReturnValue = [
                        ApiServer(name: "c_server", distance: 1300),
                        ApiServer(name: "a_server", distance: 250),
                        ApiServer(name: "b_server", distance: 420)
                    ]
                }
                
                context("when refreshing the servers list") {
                    beforeEach {
                        await sut.refreshServersList()
                    }
                    
                    it("will present the new list by respecting the selected sorting method") {
                        await expect(viewModel.servers as? [ApiServer])
                            .toEventually(
                                equal([
                                    ApiServer(name: "a_server", distance: 250),
                                    ApiServer(name: "b_server", distance: 420),
                                    ApiServer(name: "c_server", distance: 1300)
                                ])
                            )
                    }
                }
            }
            
            context("given there is a stored servers list") {
                let expectedServers = [
                    StorableServer(name: "a_server", distance: 100),
                    StorableServer(name: "b_server", distance: 500)
                ]
                
                beforeEach {
                    storedServersListService
                        .fetchServersListReturnValue = expectedServers
                    await sut.populateServersList()
                }
                
                it("will not try to fetch servers list data from the api") {
                    await expect(remoteServersListService.fetchServersListCallsCount)
                        .toEventually(equal(0))
                }
                
                it("will try to fetch stored servers list") {
                    await expect(storedServersListService.fetchServersListCallsCount)
                        .toEventually(equal(1))
                }
                
                it("will present servers list to the user") {
                    await expect(viewModel.servers as? [StorableServer])
                        .toEventually(equal(expectedServers))
                }
            }
            
            context("given user tries to refresh servers list") {
                let expectedServers = [
                    ApiServer(name: "a_server", distance: 100),
                    ApiServer(name: "b_server", distance: 500)
                ]
                
                beforeEach {
                    remoteServersListService
                        .fetchServersListReturnValue = expectedServers
                    await sut.refreshServersList()
                }
                
                it("will try to fetch servers list data from the api") {
                    await expect(remoteServersListService.fetchServersListCallsCount)
                        .toEventually(equal(1))
                }
                
                it("will present servers list to the user") {
                    await expect(viewModel.servers as? [ApiServer])
                        .toEventually(equal(expectedServers))
                }
                
                it("will store new servers list") {
                    await expect(
                        matchServers(
                            expectedServers,
                            storedServersListService.storeNewServersListCapturedServersList!
                        )
                    ).toEventually(beTrue())
                }
            }
            
            context("given the user selected filter options") {
                beforeEach {
                    sut.showFilters()
                }
                
                it("will show filter options") {
                    expect(viewModel.shouldShowFilters)
                        .to(beTrue())
                }
            }
            
            context("given the user selected sorting method") {
                beforeEach {
                    viewModel.servers = [
                        ApiServer(name: "c_server", distance: 600),
                        ApiServer(name: "a_server", distance: 250),
                        ApiServer(name: "b_server", distance: 1200)
                    ]
                }
                
                context("when sorting by distance") {
                    beforeEach {
                        sut.sort(.byDistance)
                    }
                    
                    it("will correctly sort the server list ") {
                        expect(viewModel.servers as? [ApiServer])
                            .to(
                                equal([
                                    ApiServer(name: "a_server", distance: 250),
                                    ApiServer(name: "c_server", distance: 600),
                                    ApiServer(name: "b_server", distance: 1200)
                                ])
                            )
                    }
                }
                
                context("when sorting alphabetically") {
                    beforeEach {
                        sut.sort(.alphabetically)
                    }
                    
                    it("will correctly sort the server list ") {
                        expect(viewModel.servers as? [ApiServer])
                            .to(
                                equal([
                                    ApiServer(name: "a_server", distance: 250),
                                    ApiServer(name: "b_server", distance: 1200),
                                    ApiServer(name: "c_server", distance: 600)
                                ])
                            )
                    }
                }
            }
            
            context("given the user selected log out option") {
                beforeEach {
                    sut.logOut()
                }
                
                it("will log out") {
                    expect(authorizer.logOutCallsCount)
                        .to(equal(1))
                }
            }
        }
    }
}

func matchServers(_ expected: [Server], _ actual: [Server]) -> Bool {
    guard expected.count == actual.count else { return false }
    for (expectedServer, actualServer) in zip(expected, actual) {
        if expectedServer.name != actualServer.name || expectedServer.distance != actualServer.distance {
            return false
        }
    }
    return true
}

private final class StoredServersListServiceSpy: StoredServersListServing {
    var fetchServersListCallsCount = 0
    var fetchServersListReturnValue: [StorableServer]?
    func fetchServersList() throws -> [StorableServer]? {
        fetchServersListCallsCount += 1
        return fetchServersListReturnValue
    }
    
    var storeNewServersListCallsCount = 0
    var storeNewServersListCapturedServersList: [StorableServer]?
    func storeNewServersList(_ serversList: [StorableServer]) {
        storeNewServersListCallsCount += 1
        storeNewServersListCapturedServersList = serversList
    }
}

private final class RemoteServersListServiceSpy: RemoteServersListServing {
    var fetchServersListCallsCount = 0
    var fetchServersListReturnValue: [ApiServer]?
    var fetchServersListThrowableError: Error?
    func fetchServersList() async throws -> [ApiServer] {
        fetchServersListCallsCount += 1
        if let fetchServersListThrowableError {
            throw fetchServersListThrowableError
        }
        return fetchServersListReturnValue ?? []
    }
}
