//
//  MainVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

final class MainVC: UIViewController {
    
    private let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.showsCancelButton = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //TODO: "models" will be removed by API model
    private let recipesModels: [String] = ["1", "2", "2", "2", "2", "4", "4", "5"]
    private var searchedRecipes: [String] = []
    
    private let mainTableView = MainTableView()
    var mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

//MARK: - Setup

private extension MainVC {
    
    func setup() {
        searchedRecipes = recipesModels
        hideMainTableView(isTableViewHidden: true)
        mainTableView.configure(models: searchedRecipes)
        setDelegate()
        setupView()
        setConstraints()
    }
    
    func setDelegate() {
        searchBar.delegate = self
    }
    
    func setupView() {
        view.addSubview(searchBar)
        view.addSubview(mainView)
        view.addSubview(mainTableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: mainView.topAnchor, constant: -20),
            searchBar.bottomAnchor.constraint(equalTo: mainTableView.topAnchor, constant: -20),
            
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateMainTableView() {
        mainTableView.configure(models: searchedRecipes)
        mainTableView.mainTableView.reloadData()
    }
    
    func hideMainTableView(isTableViewHidden: Bool) {
        mainTableView.isHidden = isTableViewHidden
        mainView.isHidden = !isTableViewHidden
    }
    
    
}
 
//MARK: - UISearchBarDelegate

extension MainVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedRecipes = recipesModels
        updateMainTableView()
        hideMainTableView(isTableViewHidden: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        hideMainTableView(isTableViewHidden: false)
        searchedRecipes = recipesModels.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
        updateMainTableView()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        hideMainTableView(isTableViewHidden: false)
    }
}
