//
//  ViewController.swift
//  recipes screen
//
//  Created by Вова on 02.03.2023.
//

import UIKit

class RecipeListVC: UIViewController {
    
    var recipeTableView = UITableView()
    
//    var categoryLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Desserts"
//        label.textColor = .black
//        label.numberOfLines = 0
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 25)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
    var recipesInList: [SafeRecipe] = []
    
    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData(for: category!)
        configureTableView()
        
    }
    
    func configureTableView () {
//        view.addSubview(categoryLabel)
        view.addSubview(recipeTableView)
        recipeTableView.translatesAutoresizingMaskIntoConstraints = false
        setTableviewDelegates()
        setConstraints()
        recipeTableView.register(RecipeCell.self, forCellReuseIdentifier: "RecipeCell")
        recipeTableView.rowHeight = view.frame.height/6
        
    }
    
    func setTableviewDelegates () {
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
    }
    
//MARK: - Constraints

    func setConstraints () {
        NSLayoutConstraint.activate([
            
//            categoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            categoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            categoryLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            recipeTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            recipeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            recipeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            recipeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

}

//MARK: - Delegates

extension RecipeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("tapped on \(indexPath.row) row!!!")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesInList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = recipeTableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
        let recipe = recipesInList[indexPath.row]
        cell.setData(recipe: recipe)
        return cell
    }
    
    
}

//MARK: - Networking

extension RecipeListVC {
    func fetchData(for category: String) {
        let dispatchGroup = DispatchGroup()
        
        APICaller.shared.getCategoryRecipes(category: category) { categoryResults in
            switch categoryResults {
                
            case .success(let recipes):
                for recipe in recipes {
                    dispatchGroup.enter()
                    
                    APICaller.shared.getDetailedRecipe(with: recipe.id) { detailedResults in
                        switch detailedResults {
                            
                        case .success(let recipe):
                            print ("успешно получены детальные данные")
                            APICaller.shared.getImage(from: recipe.image!) { imageResults in
                                
                                switch imageResults {
                                case.success(let imageData):
                                    
                                    let safeRecipe = SafeRecipe(recipe: recipe, imageData: imageData)
                                    self.recipesInList.append(safeRecipe)
                                    
                                case .failure(let error): print ("error in image: \(error)")
                                }
                                dispatchGroup.leave()
                            }
                            
                            
                        case .failure(let error): print("error in detailed: \(error)")
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.recipeTableView.reloadData()
                }
            case .failure(let error) : print ("error in category: \(error)")
                
            }
        }
    }
}
