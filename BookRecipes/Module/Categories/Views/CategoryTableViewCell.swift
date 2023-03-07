//
//  CategoryTableViewCell.swift
//  BookRecipes
//
//  Created by User on 04.03.2023.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryTableViewCell"

    lazy var backImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "MainCourse")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var view: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.65)
        view.layer.cornerRadius = 8
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Main Course"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryTableViewCell {
    
    func setupView() {
        
        contentView.addSubview(backImageView)
        contentView.addSubview(view)
        contentView.addSubview(titleLabel)
    }
    
    func setupConstraints() {
        
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            backImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            backImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            safeArea.trailingAnchor.constraint(equalTo: backImageView.trailingAnchor, constant: 16),
            safeArea.bottomAnchor.constraint(equalTo: backImageView.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            safeArea.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            safeArea.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 26),
            safeArea.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 26)
        ])
    }
}

