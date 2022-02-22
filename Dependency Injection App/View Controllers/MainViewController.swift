//
//  MainViewController.swift
//  Dependency Injection App
//
//  Created by meekam okeke on 2/18/22.
//

import UIKit

class MainViewController: UIViewController {
    let tableView = UITableView()
    let networkManager: NetworkManager
    let rating = "pg"
    var isSearching = false
    var dataResponse: [DataModel] = []
    var searchData: [DataModel] = []
    
    struct Cells {
        static let gifCell = "GIFCell"
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchController()
        fetchData()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewConstraints()
        setTableViewDelegates()
        tableView.rowHeight = 120
        tableView.register(GIFCell.self, forCellReuseIdentifier: Cells.gifCell)
    }
    
    func setTableViewDelegates() {
        tableView.delegate   = self
        tableView.dataSource = self
    }
    
    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureSearchController() {
        let searchController                                  = UISearchController()
        searchController.searchResultsUpdater                 = self
        searchController.searchBar.placeholder                = "Search for GIF"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController                       = searchController
    }
    
    func fetchData() {
        networkManager.fetchTrendingData(rating: rating) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let dataResponse):
                self.dataResponse = dataResponse.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case.failure(.invalidData):
                print("Invalid data.")
            case.failure(.invalidResponse):
                print("Invalid response.")
            case.failure(.unableToComplete):
                print("Unable to complete.")
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchData.isEmpty {
            return searchData.count
        }
        return dataResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.gifCell) as! GIFCell
        if !searchData.isEmpty {
            cell.setCell(data: searchData[indexPath.row])
        } else {
            cell.setCell(data: dataResponse[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSearching == false {
            let response = dataResponse[indexPath.row]
            let vc = DetailViewController(ID: response.id, networkService: self.networkManager)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let response = searchData[indexPath.row]
            let vc = DetailViewController(ID: response.id, networkService: self.networkManager)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text
        if !query!.isEmpty {
            isSearching = true
            networkManager.fetchSearchData(query: query!) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case.success(let searchResponse):
                    self.searchData = searchResponse.data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(.invalidData):
                    print("Invalid data.")
                case .failure(.unableToComplete):
                    print("Unable to complete.")
                case .failure(.invalidResponse):
                    print("Invalid response.")
                }
            }
        } else {
            searchData.removeAll()
            isSearching = false
            fetchData()
        }
    }
}

