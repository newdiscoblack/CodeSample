//
//  FetchServersList.swift
//  CodeSample
//
//  Created by Kacper Jagiełło on 16/08/2024.
//

struct FetchServersList: Resource {
    let path: String = "v1/servers"
    let httpRequestMethod: RequestMethod = .GET
    let authorizationNeeds: AuthorizationNeeds = .standard
}
