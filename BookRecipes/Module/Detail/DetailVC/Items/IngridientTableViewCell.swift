//
//  IngridientTableViewCell.swift
//  BookRecipes
//
//  Created by pvl kzntsv on 03.03.2023.
//

import UIKit
import SDWebImage

 final class IngridientTableViewCell: UITableViewCell {
    
    //MARK: - Elements
    
    private let backgroundCell: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let contentStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        return stack
    }()
    
    private let ingridientImageView: UIImageView = {
        let imageView = UIImageView()
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
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()
     
     private var checkboxUIButtom: UIButton = {
         let button = UIButton(type: .system)
         button.translatesAutoresizingMaskIntoConstraints = false
         button.addTarget(nil, action: #selector(checkboxTapped), for: .touchUpInside)
         button.setImage(UIImage(systemName: "checkmark"), for: .normal)
         button.tintColor = #colorLiteral(red: 0.5258541185, green: 0.5836154322, blue: 1, alpha: 1)
         return button
     }()
     
    @objc private func checkboxTapped() {
        checkboxUIButtom.isSelected = !checkboxUIButtom.isSelected
     }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
//MARK: - Configure Cell
     
    func configure(_ ingridient: ExtendedIngredient) {
        backgroundCell.backgroundColor = #colorLiteral(red: 0.9562537074, green: 0.9562535882, blue: 0.9562535882, alpha: 1) //#F1F1F1
        ingridientNameLable.text = ingridient.name?.capitalized
        ingridientCountLable.text = String(format: "%.1F", ingridient.amount!) + " " + (ingridient.unit!)
        DispatchQueue.main.async {
            self.ingridientImageView.sd_setImage(with: URL(string: "https://spoonacular.com/cdn/ingredients_100x100/" + ingridient.image!), placeholderImage: UIImage(systemName: "fish"))
        }
    }
    
    //MARK: - setupUI
    
    private func setupUI() {
        contentView.addSubview(backgroundCell)
//        addSubview(backgroundCell)
        backgroundCell.addSubview(contentStackView)
        contentStackView.addArrangedSubview(ingridientImageView)
        contentStackView.addArrangedSubview(ingridientNameLable)
        contentStackView.addArrangedSubview(ingridientCountLable)
        contentStackView.addArrangedSubview(checkboxUIButtom)
        selectionStyle = .none
    }
    
    //MARK: - setContraints
    
    private func setConstraints() {
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
            ingridientCountLable.trailingAnchor.constraint(equalTo: checkboxUIButtom.leadingAnchor, constant: -10),
            ingridientCountLable.widthAnchor.constraint(equalToConstant: 80),
            
            checkboxUIButtom.trailingAnchor.constraint(equalTo: backgroundCell.trailingAnchor, constant: -15),
            checkboxUIButtom.widthAnchor.constraint(equalToConstant: 30),
            checkboxUIButtom.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

