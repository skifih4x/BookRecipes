//
//  SavedVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit
import RealmSwift

final class SavedVC: UIViewController {
    
    lazy var tableView = UITableView()
    var data = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let deleteAllItems = UIBarButtonItem(
            title: "Remove All",
            style: .plain,
            target: self,
            action: #selector(deleteAllItemsAction))
        navigationItem.rightBarButtonItem = deleteAllItems
        
        title = "Saved recipes"
        
        tableViewSetup()
        constraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    private func loadData() {
        
        var items: Results<RealmRecipe>!
        
        DataBase.shared.read { recipes in
            items = recipes
        }
        var error: Error? = nil
        
        for i in items {
            APICaller.shared.getDetailedRecipe(with: i.id) { recipe in
                switch recipe {
                case .success(let result):
                    let recipe = Recipe(
                        id: result.id,
                        image: result.image,
                        title: result.title)
                    self.data.append(recipe)
                case .failure(let err):
                    error = err
                    print(err)
                }
            }
            
            if let error = error {
                presentErrorAlert(with: error)
            }
        }
        
    }
    
    private func tableViewSetup() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SavedTableCell.self, forCellReuseIdentifier: SavedTableCell.reuseId)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func presentErrorAlert(with error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension SavedVC {
    @objc func deleteAllItemsAction() {
        DataBase.shared.deleteAll()
    }
}

extension SavedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SavedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedTableCell.reuseId)
                as? SavedTableCell else { return UITableViewCell() }
        let recipe = data[indexPath.row]
        
        guard let recipeImage = recipe.image,
              let recipeTitle = recipe.title else { return UITableViewCell() }
        
        cell.configure(with: recipeImage, text: recipeTitle)
        return cell
    }  
}
