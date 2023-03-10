//
//  DetailViewController.swift
//  BookRecipes
//
//  Created by pvl kzntsv on 03.03.2023.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController  {
    
    private let apiManager = APICaller.shared
    
    private var recipe: DetailedRecipe?
    var detailRecipeID: Int = 1697641
    
    //MARK: - FetchData
    private func fetchData() {
        APICaller.shared.getDetailedRecipe(with: detailRecipeID) { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.recipe = recipes
                DispatchQueue.main.async {
                    self?.ingridientsTableView.reloadData()
                    self?.dishNameLableView.text = recipes.title
                    self?.numberOfReviewsLabel.text = "\(recipes.aggregateLikes!)" + " Likes"
                    self?.descriptionOfDishesLabel.text = self?.apiManager.convertHTML(from: recipes.summary ?? "cant convert from html")?.string
                    self?.descriptionOfCookingLabel.text = self?.apiManager.convertHTML(from: recipes.instructions ?? "cant convert from html")?.string
                    self?.dishPictureImageView.sd_setImage(with: URL(string: recipes.image ?? ""))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    var id: Int?
    
    //MARK: - Elements
    
    lazy var contentScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
//        scroll.backgroundColor = .red
        scroll.contentSize = CGSize(width: 100, height: 1500)
        scroll.isUserInteractionEnabled = true
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    lazy var dishNameLableView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    lazy var dishPictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var starRaitngImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "hand.thumbsup")
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ratingLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins", size: 15)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var numberOfReviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "(300 Reviews)"
        label.font = UIFont(name: "Poppins", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .systemGray
        return label
    }()
    
    private let raitingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
       }()
    
    lazy var descriptionOfDishesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionOfCookingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let ingridientsTableView: UITableView = {
//        let table = UITableView(frame: .zero, style: .plain)
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(IngridientTableViewCell.self, forCellReuseIdentifier: "cell")
        table.bounces = false
        table.separatorStyle = .none
        table.register(IngridientsTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        table.sectionHeaderTopPadding = 0
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    //MARK: - setupUI
    
     private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(dishNameLableView)
        contentScrollView.addSubview(dishPictureImageView)
        contentScrollView.addSubview(raitingStackView)
        raitingStackView.addArrangedSubview(starRaitngImageView)
        raitingStackView.addArrangedSubview(ratingLabel)
        raitingStackView.addArrangedSubview(numberOfReviewsLabel)
        contentScrollView.addSubview(descriptionOfDishesLabel)
        contentScrollView.addSubview(descriptionOfCookingLabel)
        
        view.addSubview(ingridientsTableView)
        
        setConstraints()
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            dishPictureImageView.topAnchor.constraint(equalTo: dishNameLableView.bottomAnchor, constant: 27),
//            contentImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentScrollView.bottomAnchor, constant: -20),
            dishPictureImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20 ),
            dishPictureImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dishPictureImageView.heightAnchor.constraint(equalToConstant: 200),
  
            dishNameLableView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            dishNameLableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 19),
            dishNameLableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -23),
//            dishNameLableView.bottomAnchor.constraint(equalTo: contentImageView.topAnchor, constant: -27)
 
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 19),
            contentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            contentScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
            contentScrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6),

            starRaitngImageView.widthAnchor.constraint(equalToConstant: 18),
            starRaitngImageView.heightAnchor.constraint(equalToConstant: 20),

            ratingLabel.widthAnchor.constraint(equalToConstant: 25),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            ratingLabel.leadingAnchor.constraint(equalTo: starRaitngImageView.trailingAnchor, constant: 7),
 
            numberOfReviewsLabel.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 15),
        
            raitingStackView.topAnchor.constraint(equalTo: dishPictureImageView.bottomAnchor, constant: 10),
            raitingStackView.heightAnchor.constraint(equalToConstant: 20),
            raitingStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            raitingStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
  
            descriptionOfDishesLabel.topAnchor.constraint(equalTo: raitingStackView.bottomAnchor, constant: 25),
            descriptionOfDishesLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27),
            descriptionOfDishesLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
//            descriptionOfDishesLabel.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),

            descriptionOfCookingLabel.topAnchor.constraint(equalTo: descriptionOfDishesLabel.bottomAnchor, constant: 25),
            descriptionOfCookingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 23),
            descriptionOfCookingLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            descriptionOfCookingLabel.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
       
            ingridientsTableView.topAnchor.constraint(equalTo: contentScrollView.bottomAnchor, constant: 3),
            ingridientsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ingridientsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ingridientsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupUI()
        setDelegates()
//        fetchData()
    }
    
    private func setDelegates() {
        ingridientsTableView.delegate = self
        ingridientsTableView.dataSource = self
    }
}

// MARK: - extension UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingridients = recipe?.extendedIngredients else {return 1}
        return ingridients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath) as! IngridientTableViewCell
//        guard let ingridient = recipe?.extendedIngredients[indexPath.row] else { return UITableViewCell() } //  если делать через guard то создается пустая ячейка
        if let ingridient = recipe?.extendedIngredients[indexPath.row]  {
            cell.configure(ingridient)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! IngridientsTableViewHeader
        let ingridientsCount = recipe?.extendedIngredients.count ?? 0
        header.configure(text: "\(ingridientsCount) items") //set number of items
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

// MARK: - extension UITableViewDelegate

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         65
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        print("нажата ячейка \(recipe?.extendedIngredients[indexPath.row].name ?? "не прогрузилась")")
//        
//    }
}


