//
//  ViewController.swift
//  recipes screen
//
//  Created by Вова on 02.03.2023.
//

import UIKit

class RecipeListVC: UIViewController {
    
    var recipeTableView = UITableView()
    
    lazy var imageView = PizzaLoading()
    
    var recipesInList: [DetailedRecipe] = []
    
    var category: String?
    var isSorted: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData(for: category!)
        configureTableView()
        configureNavigationBar()
    }
}

extension RecipeListVC {
    
    func configureRecipeListVC (isSorted: Bool?, category: String?, title: String?) {
        self.isSorted = isSorted
        self.category = category
        self.title = title
    }
    
    func configureTableView() {
        view.addSubview(recipeTableView)
        view.addSubview(imageView)
        recipeTableView.showsVerticalScrollIndicator = false
        recipeTableView.translatesAutoresizingMaskIntoConstraints = false
        recipeTableView.separatorStyle = .none
        setTableviewDelegates()
        setConstraints()
        recipeTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.identifier)

    }
    
    func configureNavigationBar() {
        let backButtonImage = UIImage(named: "BackButton")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(goBack))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.hidesBackButton = true
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .systemBackground
    }
    
    func setTableviewDelegates () {
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
    }
    
    func setConstraints () {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recipeTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            recipeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            recipeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            recipeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - Actions
extension RecipeListVC {
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Delegates
extension RecipeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("tapped on \(indexPath.row) row!!!")
        let id = recipesInList[indexPath.row].id
        let detailVC = DetailViewController()
        detailVC.detailRecipeID = id
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesInList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = recipeTableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier) as! RecipeTableViewCell
        let recipe = recipesInList[indexPath.row]
        cell.setupData(recipe: recipe)
        return cell
    }
    
    
}

//MARK: - Networking
extension RecipeListVC {
    func fetchData(for category: String) {
        let dispatchGroup = DispatchGroup()
        
        APICaller.shared.getCategoryRecipes(sorted: isSorted!, searchParameter: category) { categoryResults in
            switch categoryResults {
                
            case .success(let recipes):
                for recipe in recipes {
                    dispatchGroup.enter()
                    
                    APICaller.shared.getDetailedRecipe(with: recipe.id) { detailedResults in
                        
                        switch detailedResults {
                        case .success(let recipe): self.recipesInList.append(recipe)
                        case .failure(let error): print("error in detailed: \(error)")
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.recipeTableView.reloadData()
                    self.imageView.isHidden = true
                }
            case .failure(let error) : print ("error in category: \(error)")
                
            }
        }
    }
}
