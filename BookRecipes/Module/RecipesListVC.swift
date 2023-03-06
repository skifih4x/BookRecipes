//
//  ViewController.swift
//  recipes screen
//
//  Created by Вова on 02.03.2023.
//

import UIKit

class RecipeListVC: UIViewController {
    
    var recipeTableView = UITableView()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        if let gifUrl = URL(string: "https://media.tenor.com/On7kvXhzml4AAAAj/loading-gif.gif") {
            imageView.sd_setImage(with: gifUrl) { (image, error, cacheType, url) in
                if error != nil {
                    print("Error loading GIF image")
                } else {
                    imageView.image = image
                }
            }
        }
        
        return imageView
    }()
    
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
        configureNavigationBar()
    }
    
    func configureTableView() {
        
        view.addSubview(recipeTableView)
        view.addSubview(imageView)
        recipeTableView.translatesAutoresizingMaskIntoConstraints = false
        recipeTableView.separatorStyle = .none
        setTableviewDelegates()
        setConstraints()
        recipeTableView.register(RecipeTableViewCell.self, forCellReuseIdentifier: RecipeTableViewCell.identifier)
//        recipeTableView.rowHeight = view.frame.height/6
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
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func setTableviewDelegates () {
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
    }
    
//MARK: - Constraints

    func setConstraints () {
        
        let safeArea = view.safeAreaLayoutGuide
        
        let screenHeight = UIScreen.main.bounds.height
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: screenHeight / 16),
            imageView.widthAnchor.constraint(equalToConstant: screenHeight / 16)
        ])
        
        NSLayoutConstraint.activate([
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
                    self.imageView.isHidden = true
                }
            case .failure(let error) : print ("error in category: \(error)")
                
            }
        }
    }
}
