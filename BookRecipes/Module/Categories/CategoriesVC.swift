//
//  CategoriesVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

class CategoriesVC: UIViewController {
    
    var categories = [
        ["Main Course", CategoryImages.mainCourse!],
        ["Side Dish", CategoryImages.sideDish!],
        ["Dessert", CategoryImages.dessert!],
        ["Salad", CategoryImages.salad!],
        ["Breakfast", CategoryImages.breakfast!],
        ["Soup", CategoryImages.soup!],
        ["Snack", CategoryImages.snack!],
        ["Drink", CategoryImages.drink!]
    ]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
}

extension CategoriesVC {
    
    func setupView() {
        
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

// MARK: - Collection View Data Source
extension CategoriesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        
        let title = categories[indexPath.row][0]
        let image = categories[indexPath.row][1]
        
        cell.titleLabel.text = title as? String
        cell.backImageView.image = image as? UIImage
        return cell
    }
}

// MARK: - Collection View Delegate
extension CategoriesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(categories[indexPath.row][0]) is selected!")
    }
}
