//
//  CategoriesVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

class CategoriesVC: UIViewController {
    
    var categories = [
        ["Main Course", CategoryImages.mainCourse!],
        ["Side Dish", CategoryImages.sideDish!],
        ["Dessert", CategoryImages.dessert!],
        ["Salad", CategoryImages.salad!],
        ["Breakfast", CategoryImages.breakfast!],
        ["Soup", CategoryImages.soup!],
        ["Snack", CategoryImages.snack!],
        ["Drink", CategoryImages.drink!]
    ]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 30) / 2
        
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: cellWidth, height: 80)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
}

extension CategoriesVC {
    
    func setupView() {
        
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            safeArea.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

// MARK: - Collection View Data Source
extension CategoriesVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        let title = self.categories[indexPath.item][0]
        let image = self.categories[indexPath.item][1]
        cell.titleLabel.text = title as? String
        cell.imageView.image = image as? UIImage
        return cell
    }
}

// MARK: - Collection View Delegate
extension CategoriesVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath.item + 1)")
    }
}
