//
//  HeaderSupplementaryView.swift
//  BookRecipes
//
//  Created by Ян Бойко on 28.02.2023.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {
    
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
    }
    
    func configureHeader(categoryName: String) {
        headerLabel.text = categoryName
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
