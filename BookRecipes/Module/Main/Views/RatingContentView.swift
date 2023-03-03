//
//  RatingContentView.swift
//  BookRecipes
//
//  Created by Buzz on 3/1/23.
//

import UIKit

final class RatingContentView: UIView {
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
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
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(rating: String) {
        ratingLabel.text = rating
    }
}

//MARK: Setup

private extension RatingContentView {
    
    func setup() {
        setupView()
        setConstraints()
    }
    
    func setupView() {
        addSubview(contentView)
        contentView.addSubview(starImageView)
        contentView.addSubview(ratingLabel)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            starImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            starImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            starImageView.heightAnchor.constraint(equalToConstant: 20),
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            
            ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            ratingLabel.heightAnchor.constraint(equalToConstant: 20),
            ratingLabel.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}

