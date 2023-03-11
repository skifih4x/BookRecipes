//
//  ExampleCollectionViewCell.swift
//  BookRecipes
//
//  Created by Ян Бойко on 28.02.2023.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    var mainView = MainView()
    var localSection = 0
    var localItem = 0
    var isSaved = false {
        didSet {
            bookmarkImageView.image = isSaved ?
            UIImage(named: "bookmark selected") : UIImage(named: "bookmark")
        }
    }

    var saveButtonCompletion: (() -> ())?
   
    private let foodImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let bookmarkButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.layer.cornerRadius = 17.5
        view.addTarget(nil, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func bookmarkButtonTapped() {
        saveButtonCompletion?()
        isSaved.toggle()
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
        view.text = "Loading..."
        view.textColor = .black
        view.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        view.textAlignment = .center
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 1
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
        addSubview(foodImageView)
        foodImageView.addSubview(bookmarkButton)
        bookmarkButton.addSubview(bookmarkImageView)
        addSubview(nameView)
        nameView.addSubview(nameLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        foodImageView.image = nil
    }
    func configure(model: Recipe, section: Int, item: Int, saveButtonCompletion: @escaping () -> ()) {
        
        self.nameLabel.text = model.title
        localSection = section
        localItem = item
        
        self.saveButtonCompletion = saveButtonCompletion
        
        foodImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let image = model.image else { return }
        guard let url = URL(string: image) else { return }
        foodImageView.sd_setImage(with: url)
        
        // checking whether the recipe is saved in database
        isSaved = RealmDataBase.shared.isItemSaved(withId: model.id)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            foodImageView.topAnchor.constraint(equalTo: topAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: nameView.topAnchor),

            bookmarkButton.topAnchor.constraint(equalTo: foodImageView.topAnchor, constant: 10),
            bookmarkButton.trailingAnchor.constraint(equalTo: foodImageView.trailingAnchor, constant: -10),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 35),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 35),
            
            bookmarkImageView.centerYAnchor.constraint(equalTo: bookmarkButton.centerYAnchor),
            bookmarkImageView.centerXAnchor.constraint(equalTo: bookmarkButton.centerXAnchor),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: 19),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 15),
            
            nameView.heightAnchor.constraint(equalToConstant: 30),
            nameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: nameView.trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: nameView.centerYAnchor),

        ])
    }
    
}
