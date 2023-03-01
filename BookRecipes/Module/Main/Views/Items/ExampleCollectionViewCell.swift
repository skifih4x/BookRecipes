//
//  ExampleCollectionViewCell.swift
//  BookRecipes
//
//  Created by Ян Бойко on 28.02.2023.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell {
    
    var isSaved: Bool = false
    
    private let burgerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "burger1")
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 180/255, green: 182/255, blue: 188/255, alpha: 0.9)
        view.layer.cornerRadius = 7
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let starImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let view = UILabel()
        view.text = "4,5"
        view.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saveButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.layer.cornerRadius = 17.5
        view.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func saveButtonTapped() {
        print("тыкнул по кнопке сохранить")
        if !isSaved {
            isSaved = true
            bookmarkImageView.image = UIImage(named: "bookmark selected")
        } else {
            isSaved = false
            bookmarkImageView.image = UIImage(named: "bookmark")
        }
    }
    
    private let bookmarkImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bookmark")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.text = "How to sharwama at home"
        view.textColor = .black
        view.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        clipsToBounds = true
        //layer.cornerRadius = 10
        addSubview(burgerImageView)
        burgerImageView.addSubview(ratingView)
        ratingView.addSubview(starImageView)
        ratingView.addSubview(ratingLabel)
        burgerImageView.addSubview(saveButton)
        saveButton.addSubview(bookmarkImageView)
        addSubview(nameView)
        nameView.addSubview(nameLabel)
    }
    
    func configureCell(imageName: String) {
        burgerImageView.image = UIImage(named: imageName)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            burgerImageView.topAnchor.constraint(equalTo: topAnchor),
            burgerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            burgerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            burgerImageView.bottomAnchor.constraint(equalTo: nameView.topAnchor),
            
            ratingView.topAnchor.constraint(equalTo: burgerImageView.topAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: burgerImageView.leadingAnchor, constant: 10),
            ratingView.heightAnchor.constraint(equalToConstant: 35),
            ratingView.widthAnchor.constraint(equalToConstant: 70),
            
            starImageView.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            starImageView.leadingAnchor.constraint(equalTo: ratingView.leadingAnchor, constant: 7),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingView.trailingAnchor, constant: -7),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            ratingLabel.widthAnchor.constraint(equalToConstant: 30),
            
            saveButton.topAnchor.constraint(equalTo: burgerImageView.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: burgerImageView.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 35),
            saveButton.widthAnchor.constraint(equalToConstant: 35),
            
            bookmarkImageView.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            bookmarkImageView.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: 19),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 15),
            
            nameView.heightAnchor.constraint(equalToConstant: 30),
            nameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.centerXAnchor.constraint(equalTo: nameView.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: nameView.centerYAnchor),

        ])
    }
    
}
