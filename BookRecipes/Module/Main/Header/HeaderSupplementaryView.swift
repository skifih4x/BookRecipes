//
//  HeaderSupplementaryView.swift
//  BookRecipes
//
//  Created by Ян Бойко on 28.02.2023.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
    
    weak var navigationController: UINavigationController?
    
    private let headerLabel: UILabel = {
        let view = UILabel()
        view.text = "header"
        view.textAlignment = .center
        view.font = UIFont(name: "Helvetica Neue Bold", size: 28)
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let seeAllButton: UIButton = {
        let view = UIButton()
        view.addTarget(nil, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let seeAllLabel: UILabel = {
        let view = UILabel()
        view.text = "See all"
        view.textColor = .red
        view.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let arrowImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "arrow.forward")
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(headerLabel)
        addSubview(seeAllButton)
        seeAllButton.addSubview(seeAllLabel)
        seeAllButton.addSubview(arrowImageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func seeAllButtonTapped() {    
        let VC = RecipeListVC()
        let category: String?
        switch headerLabel.text {
        case "Popular \u{1F525}": category = Types.popularity.rawValue
        case "Healthy \u{1F966}": category = Types.healthiness.rawValue
        case "Dessert \u{1F370}": category = Types.sugar.rawValue
        default : category = ""
        }
        
        VC.configureRecipeListVC(isSorted: true, category: category, title: headerLabel.text)
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func configureHeader(categoryName: String, navController: UINavigationController) {
        headerLabel.text = categoryName
        navigationController = navController
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            
            seeAllButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            seeAllButton.widthAnchor.constraint(equalTo: widthAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            arrowImageView.centerYAnchor.constraint(equalTo: seeAllButton.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            seeAllLabel.centerYAnchor.constraint(equalTo: seeAllButton.centerYAnchor),
            seeAllLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -10),
        ])
    }
    
}
