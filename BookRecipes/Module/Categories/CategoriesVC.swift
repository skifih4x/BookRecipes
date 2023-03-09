//
//  CategoriesVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

class CategoriesVC: UIViewController {
    
    var categories = [
        ["Main Course", CategoryImages.mainCourse!, Categories.maincourse.rawValue],
        ["Side Dish", CategoryImages.sideDish!, Categories.sidedish.rawValue],
        ["Dessert", CategoryImages.dessert!, Categories.dessert.rawValue],
        ["Salad", CategoryImages.salad!, Categories.salad.rawValue],
        ["Breakfast", CategoryImages.breakfast!, Categories.breakfast.rawValue],
        ["Soup", CategoryImages.soup!, Categories.soup.rawValue],
        ["Snack", CategoryImages.snack!, Categories.snack.rawValue],
        ["Drink", CategoryImages.drink!, Categories.drink.rawValue]
    ]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
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
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .systemBackground
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
        
        let category = categories[indexPath.item][2] as? String
        let title = categories[indexPath.item][0] as? String
        
        let VC = RecipeListVC()
        VC.category = category
        VC.isSorted = false
        VC.title = title
        navigationController?.pushViewController(VC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
