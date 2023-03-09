//
//  ExampleCollectionViewCell.swift
//  BookRecipes
//
//  Created by Ян Бойко on 28.02.2023.
//

import UIKit
import SDWebImage

class ExampleCollectionViewCell: UICollectionViewCell {
    
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
        //view.image = UIImage(named: "loading")
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
    
    private let bookmarkButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.layer.cornerRadius = 17.5
        view.addTarget(nil, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func bookmarkButtonTapped() {
        print("тыкнул по кнопке сохранить")
        
        saveButtonCompletion?()
        isSaved.toggle()
        
//        if mainView.boolArray[localSection][localItem] {
//            bookmarkImageView.image = UIImage(named: "bookmark")
//            mainView.boolArray[localSection][localItem] = false
//            print(mainView.boolArray)
//        } else {
//            bookmarkImageView.image = UIImage(named: "bookmark selected")
//            mainView.boolArray[localSection][localItem] = true
//            print(mainView.boolArray)
//        }
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
        foodImageView.addSubview(ratingView)
        ratingView.addSubview(starImageView)
        ratingView.addSubview(ratingLabel)
        foodImageView.addSubview(bookmarkButton)
        bookmarkButton.addSubview(bookmarkImageView)
        addSubview(nameView)
        nameView.addSubview(nameLabel)
    }
    
//    func checkBookmark(section: Int, item: Int) {
//        if mainView.boolArray[section][item] {
//            bookmarkImageView.image = UIImage(named: "bookmark selected")
//        } else {
//            bookmarkImageView.image = UIImage(named: "bookmark")
//        }
//    }
    
//    func configureCell(imageName: String, section: Int, item: Int) {
//        foodImageView.image = UIImage(named: imageName)
//        localSection = section
//        localItem = item
//        checkBookmark(section: section, item: item)
//        print("вызвали configureCell  метод")
//    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        foodImageView.image = nil
    }
    func configure(model: Recipe, section: Int, item: Int, saveButtonCompletion: @escaping () -> ()) {
        
        self.nameLabel.text = model.title
        //self.foodImageView.image = UIImage(data: model.imageData)
        localSection = section
        localItem = item
//        checkBookmark(section: section, item: item)
        print("вызвали configure метод")
        
        self.saveButtonCompletion = saveButtonCompletion
        
        foodImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        guard let image = model.image else { return }
        guard let url = URL(string: image) else { return }
        foodImageView.sd_setImage(with: url)
        
        // checking whether the recipe is saved in database
        isSaved = Storage.shared.isItemSaved(withId: model.id)
//

    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
        
            foodImageView.topAnchor.constraint(equalTo: topAnchor),
            foodImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            foodImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            foodImageView.bottomAnchor.constraint(equalTo: nameView.topAnchor),
            
            ratingView.topAnchor.constraint(equalTo: foodImageView.topAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: foodImageView.leadingAnchor, constant: 10),
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
