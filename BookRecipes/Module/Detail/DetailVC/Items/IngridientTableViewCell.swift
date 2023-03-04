//
//  IngridientTableViewCell.swift
//  BookRecipes
//
//  Created by pvl kzntsv on 03.03.2023.
//

import UIKit

class IngridientTableViewCell: UITableViewCell {
    
    //MARK: - Elements
    
    private let backgroundCell: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9562537074, green: 0.9562535882, blue: 0.9562535882, alpha: 1) //#F1F1F1
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.distribution = .fill
//        stack.contentMode = .scaleAspectFit
        stack.spacing = 20
        return stack
    }()
    
    private let ingridientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "fish")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let ingridientNameLable: UILabel = {
        let label = UILabel()
        label.text = "Fish"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let ingridientCountLable: UILabel = {
        let label = UILabel()
        label.text = "100g"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setCinstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setupUI
    
    private func setupUI() {
        addSubview(backgroundCell)
        backgroundCell.addSubview(contentStackView)
        contentStackView.addArrangedSubview(ingridientImageView)
        contentStackView.addArrangedSubview(ingridientNameLable)
        contentStackView.addArrangedSubview(ingridientCountLable)
        selectionStyle = .none
    }
    
    //MARK: - setContraints
    
    private func setCinstraints() {
        NSLayoutConstraint.activate([
            backgroundCell.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            backgroundCell.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            backgroundCell.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            backgroundCell.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: backgroundCell.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: backgroundCell.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: backgroundCell.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor),
            
//            ingridientImageView.heightAnchor.constraint(equalToConstant: 35),
            ingridientImageView.widthAnchor.constraint(equalToConstant: 50),
            ingridientImageView.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            ingridientImageView.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: 5),
            ingridientImageView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 20),
            ingridientImageView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: -5),

            ingridientNameLable.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            
            ingridientCountLable.centerYAnchor.constraint(equalTo: backgroundCell.centerYAnchor),
            ingridientCountLable.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -20),
            ingridientCountLable.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}

