//
//  DIViewModel.swift
//  Dependency Injection App
//
//  Created by meekam okeke on 2/18/22.
//

import Foundation

class DIViewModel {
    
    private let networkManager: NetworkManager
    let rating = "pg"
    var dataModel: [DataModel] = []
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchData() {

    }
}
