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
        
        fetchData(for: .popular)
        fetchData(for: .healthy)
        fetchData(for: .dessert)
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
    
    func fetchData(for type: Types) {
        let dispatchGroup = DispatchGroup()
        APICaller.shared.getSortedRecipes(type: type) { results in
            switch results {
            case .success(let recipes):
                // Успешно получено
                for i in recipes {
                    dispatchGroup.enter()
                    APICaller.shared.getDetailedRecipe(with: i.id) { results in
                        switch results {
                        case .success(let recipe):
                            print(recipe)
                            // успешно получены детальные данные
                            APICaller.shared.getImage(from: recipe.image!) { result in
                                switch result {
                                case .success(let imageData):
                                    let safeRecipe = SafeRecipe(recipe: recipe, imageData: imageData)
                                    switch type {
                                    case .popular:
                                        self.mainView.popularRecipes.append(safeRecipe)
                                    case .healthy:
                                        self.mainView.healthyRecipes.append(safeRecipe)
                                    case .dessert:
                                        self.mainView.dessertRecipes.append(safeRecipe)
                                    }
                                case .failure(let error):
                                    print(error)
                                }
                                dispatchGroup.leave()
                            }
                        case .failure(let error):
                            print(error)
                            // получена ошибка при запросе детальных данных
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.mainView.collectionView.reloadData()
                }
            case .failure(let error):
                print (error)
                // получена ошибка
            }
        }
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
