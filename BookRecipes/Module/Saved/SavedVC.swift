//
//  SavedVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit
import SwiftUI

final class SavedVC: UIViewController {
    
    lazy var tableView = UITableView()
    var data = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Saved recipes"
        
        tableViewSetup()
        loadData()
        constraints()
    }
    
    private func loadData() {
        APICaller.shared.getSortedRecipes(type: .dessert) { result in
            switch result {
            case .success(let recipes):
                self.data = recipes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let err):
                print(err.localizedDescription)
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
//        cell.configure(with: recipe.image, text: recipe.title)
        return cell
    }
}
