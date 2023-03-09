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
        print("кнопка See all нажалась")
    
        let VC = RecipeListVC()
        VC.title = headerLabel.text
        
        switch VC.title {
        case "Popular \u{1F525}": VC.category = Types.popularity.rawValue
        case "Healthy \u{1F966}": VC.category = Types.healthiness.rawValue
        case "Dessert \u{1F370}": VC.category = Types.sugar.rawValue
        default : break
        }
        
        VC.isSorted = true
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
            seeAllButton.widthAnchor.constraint(equalToConstant: 85),
            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            seeAllLabel.centerYAnchor.constraint(equalTo: seeAllButton.centerYAnchor),
            seeAllLabel.leadingAnchor.constraint(equalTo: seeAllButton.leadingAnchor),
            
            arrowImageView.centerYAnchor.constraint(equalTo: seeAllButton.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: seeAllButton.trailingAnchor),
        ])
    }
    
}
