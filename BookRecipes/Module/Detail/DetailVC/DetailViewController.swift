//
//  DetailViewController.swift
//  BookRecipes
//
//  Created by pvl kzntsv on 03.03.2023.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController  {
    
    var label: UILabel? //что за лэйбл? нейминг
    
    private let apiManager = APICaller.shared
    
    var recipe: DetailedRecipe?
    
    var detailRecipeID: Int = 1697641
    var saveButtonCompletion: (() -> ())?
    var isSaved = false {
        didSet {
            saveButton.toggle(with: isSaved)
        }
    }
    
    var saveButton = SaveButton(isChecked: false)
    
    //MARK: - FetchData
    private func fetchData() {
        APICaller.shared.getDetailedRecipe(with: detailRecipeID) { [weak self] result in
            switch result {
            case .success(let recipes):
                self?.recipe = recipes
                DispatchQueue.main.async {
                    self?.ingridientsTableView.reloadData()
                    self?.navigationController?.navigationBar.prefersLargeTitles = false
                    
                    let titleLabel: UILabel = {
                        let view = UILabel()
                        view.text = recipes.title
                        view.numberOfLines = 0
                        view.font = UIFont(name: "Helvetica Neue Bold", size: 28)
                        view.adjustsFontSizeToFitWidth = true
                        view.translatesAutoresizingMaskIntoConstraints = false
                        return view
                    }()
                                           
                    self?.navigationItem.titleView = titleLabel
                    
                    //self?.dishNameLableView.text = recipes.title
                    self?.numberOfReviewsLabel.text = "\(recipes.aggregateLikes!)" + " Likes"
                    self?.descriptionOfDishesLabel.text = self?.convertHTML(from: recipes.summary ?? "cant convert from html")?.string
                    self?.descriptionOfCookingLabel.text = self?.convertHTML(from: recipes.instructions ?? "cant convert from html")?.string
                    self?.dishPictureImageView.sd_setImage(with: URL(string: recipes.image ?? ""))
                    
                    self?.checkIfItemIsSaved()
                    self?.barSaveButtonSetup()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    //MARK: - Elements
    
    private lazy var contentScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentSize = CGSize(width: 100, height: 1500)
        scroll.isUserInteractionEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.isDirectionalLockEnabled = true
        return scroll
    }()

    private lazy var dishNameLableView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()

    private lazy var dishPictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    private lazy var starRaitngImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "hand.thumbsup")
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var ratingLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins", size: 15)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var numberOfReviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "(300 Reviews)"
        label.font = UIFont(name: "Poppins", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var raitingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
       }()
     
    private lazy var descriptionDish: UILabel = {
        let label = UILabel()
        label.text = "A description of the dish"
        //label.font = UIFont(name: "Arial-ItalicMT", size: 20)
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        //label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionOfDishesLabel: UILabel = {
        let label = UILabel()
        //label.font = .systemFont(ofSize: 15, weight: .regular)
        label.font = UIFont(name: "Arial-ItalicMT", size: 15)
        label.textColor = .black
        label.numberOfLines = 0
        //label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionCook: UILabel = {
        let label = UILabel()
        label.text = "The description of cooking"
        //label.font = UIFont(name: "Arial-ItalicMT", size: 20)
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        //label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionOfCookingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Arial-ItalicMT", size: 15)
        label.textColor = .black
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var cellsSelectedStateDict = [Int:Bool]()
    
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
         
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .systemBackground
        view.backgroundColor = .white
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(dishPictureImageView)
        raitingStackView.addArrangedSubview(starRaitngImageView)
        raitingStackView.addArrangedSubview(numberOfReviewsLabel)
        contentScrollView.addSubview(raitingStackView)
        contentScrollView.addSubview(descriptionDish)
        contentScrollView.addSubview(descriptionOfDishesLabel)
        contentScrollView.addSubview(descriptionCook)
        contentScrollView.addSubview(descriptionOfCookingLabel)
        
        view.addSubview(ingridientsTableView)
        
        setConstraints()
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentScrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6),
            
            dishPictureImageView.topAnchor.constraint(equalTo: contentScrollView.topAnchor, constant: 10),
            dishPictureImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dishPictureImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dishPictureImageView.heightAnchor.constraint(equalToConstant: 200),

            starRaitngImageView.widthAnchor.constraint(equalToConstant: 18),
            starRaitngImageView.centerYAnchor.constraint(equalTo: raitingStackView.centerYAnchor),
            
            raitingStackView.topAnchor.constraint(equalTo: dishPictureImageView.bottomAnchor, constant: 10),
            raitingStackView.heightAnchor.constraint(equalToConstant: 20),
            raitingStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            raitingStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            descriptionDish.topAnchor.constraint(equalTo: raitingStackView.bottomAnchor, constant: 20),
            descriptionDish.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            descriptionDish.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            descriptionOfDishesLabel.topAnchor.constraint(equalTo: descriptionDish.bottomAnchor, constant: 10),
            descriptionOfDishesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            descriptionOfDishesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            //descriptionOfDishesLabel.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            
            descriptionCook.topAnchor.constraint(equalTo: descriptionOfDishesLabel.bottomAnchor, constant: 20),
            descriptionCook.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            descriptionCook.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            descriptionOfCookingLabel.topAnchor.constraint(equalTo: descriptionCook.bottomAnchor, constant: 10),
            descriptionOfCookingLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
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
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton
        
        backButton.tintColor = .black
//        fetchData()
    }

    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setDelegates() {
        ingridientsTableView.delegate = self
        ingridientsTableView.dataSource = self
        contentScrollView.delegate = self
    }
}

// MARK: - extension UITableViewDataSource

extension DetailViewController: UITableViewDataSource, IngridientTableViewCellDelegate {
    
    func checkboxToggle(sender: IngridientTableViewCell) {
        if let selectedIndexPath = ingridientsTableView.indexPath(for: sender) {
            cellsSelectedStateDict[selectedIndexPath.row] = !(cellsSelectedStateDict[selectedIndexPath.row] ?? false)
        }
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingridients = recipe?.extendedIngredients else {return 1}
        return ingridients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell" , for: indexPath) as! IngridientTableViewCell
        cell.delegate = self
//        guard let ingridient = recipe?.extendedIngredients[indexPath.row] else { return UITableViewCell() } //  если делать через guard то создается пустая ячейка
        if let ingridient = recipe?.extendedIngredients[indexPath.row]  {
            cell.configure(ingridient)
//            print(cellsSelectedStateDict)
            cell.checkboxUIButtom.isSelected = cellsSelectedStateDict[indexPath.row] ?? false
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
}

//  MARK: - Database

extension DetailViewController {
    
    private func checkIfItemIsSaved() {
        isSaved = Storage.shared.isItemSaved(withId: detailRecipeID)
    }
    
    private func barSaveButtonSetup() {
        
        guard let recipe = recipe else { return }
        saveButtonCompletion = Storage.shared.createCompletion(with: recipe)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    @objc func saveButtonTapped() {
        saveButtonCompletion?()
        isSaved.toggle()
    }
}


//MARK: - HTML converter

extension DetailViewController {
    func convertHTML (from string: String) -> NSAttributedString?{
        do{
            let atrString = try NSAttributedString(data: string.data(using: .utf8) ?? .init(), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return atrString
        }catch{
            print("error in HTML converter: \(error)")
            return nil
        }
    }
}
