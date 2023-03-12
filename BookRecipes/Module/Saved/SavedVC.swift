//
//  SavedVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit
import RealmSwift

final class SavedVC: UIViewController {
    
    // MARK: - Properties
    
    lazy var tableView = UITableView()
    
    var items: Results<RealmRecipe>!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved recipes"

        setupDeleteAllItems()
        tableViewSetup()
        constraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    // MARK: - Private Methods
    
    private func loadData() {
        RealmDataBase.shared.read { recipes in
            self.items = recipes
        }
        tableView.reloadData()
    }
    
    private func tableViewSetup() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SavedTableCell.self, forCellReuseIdentifier: SavedTableCell.reuseId)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
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
            RealmDataBase.shared.deleteitem(withId: id)
            self.tableView.reloadData()
        }
    }
}

// MARK: - DeleteAll Button setup

extension SavedVC {
    
    private func setupDeleteAllItems() {
        let deleteAllItems = UIBarButtonItem(
            title: "Remove All",
            style: .plain,
            target: self,
            action: #selector(deleteAllItemsAction))
        navigationItem.rightBarButtonItem = deleteAllItems
    }
    
    @objc func deleteAllItemsAction() {
        RealmDataBase.shared.deleteAll()
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate

extension SavedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = items[indexPath.row].id
        let detailViewController = DetailViewController()
        detailViewController.detailRecipeID = id
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - TableView Data Source

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
