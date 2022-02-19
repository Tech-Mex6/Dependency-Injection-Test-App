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

// 2 things to do

// 1. set up controllers as show below
// 2. create a JSON file with an array of `DataModel` objects (this can be helpful for testing.)

// approximately this:

/*
 Main View Controller
(with two children controllers)
┌─────────────────────────────────────────────┐
│                                             │
│                                             │
│                                             │
│           Header View Controller            │
│                                             │
│    this will be simple with some labels     │
│                                             │
│                                             │
│                                             │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│                                             │
│                                             │
│                                             │
│                                             │
│       Entries View Controller               │
│                                             │
│      this will basically be for             │
│      displaying the table view              │
│                                             │
│                                             │
│                                             │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│                                             │
│                                             │
│                                             │
│                                             │
└─────────────────────────────────────────────┘
 */

class MainVC: UIViewController {
    /// will fetch data `[DataModel]` and pass it to its children

}

class HeaderVC: UIViewController {
    //var titleLabel
    // var soemOtherLabel -- maybe some kind of summary of the entries, like count
}

class EntriesVC: UIViewController {

}

