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
    
    var items: Results<RealmRecipe>!

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
        
        Storage.shared.read { recipes in
            self.items = recipes
        }
        tableView.reloadData()
        
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
    
    private func createClosure(forItem id: Int) -> (() -> ()) {
        return {
            Storage.shared.deleteitem(withId: id)
            self.tableView.reloadData()
        }
    }
}

extension SavedVC {
    @objc func deleteAllItemsAction() {
        Storage.shared.deleteAll()
        tableView.reloadData()
    }
}

extension SavedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SavedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedTableCell.reuseId)
                as? SavedTableCell else { return UITableViewCell() }
        
        let recipe = items[indexPath.row]
        
        cell.configure(
            with: recipe.image,
            text: recipe.title,
            saveButtonAction: createClosure(
                forItem: recipe.id))
        
        return cell
    }  
}
