//
//  MainViewController.swift
//  Dependency Injection App
//
//  Created by meekam okeke on 2/18/22.
//

import UIKit

class MainViewController: UITableViewController {
    var viewModel: DIViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        fetchData()
    }
    
    private func configureViewModel() {
        viewModel = DIViewModel(networkManager: NetworkManager.shared)
    }
    
    func fetchData() {
        viewModel.fetchData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
