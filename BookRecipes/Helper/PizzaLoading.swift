//
//  PizzaLoading.swift
//  BookRecipes
//
//  Created by User on 12.03.2023.
//

import UIKit

class PizzaLoading: UIImageView {
    
    lazy var loadingImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // https://media.tenor.com/On7kvXhzml4AAAAj/loading-gif.gif
        
        if let gifUrl = URL(string: "https://i.imgur.com/6dgpUXs.gif") {
            imageView.sd_setImage(with: gifUrl) { (image, error, cacheType, url) in
                if error != nil {
                    print("Error loading GIF image")
                } else {
                    imageView.image = image
                }
            }
        }
        
        return imageView
    }()
    
    lazy var backView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    var sizeMultiplier: CGFloat?
    
    convenience init(isCell: Bool = false) {
        self.init(frame: .zero)
        
        let screenHeight = UIScreen.main.bounds.height
        
        if isCell == true {
            NSLayoutConstraint.activate([
                loadingImageView.heightAnchor.constraint(equalToConstant: screenHeight / 20),
                loadingImageView.widthAnchor.constraint(equalToConstant: screenHeight / 20)
            ])
        } else {
            NSLayoutConstraint.activate([
                loadingImageView.heightAnchor.constraint(equalToConstant: screenHeight / 10),
                loadingImageView.widthAnchor.constraint(equalToConstant: screenHeight / 10)
            ])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backView)
        addSubview(loadingImageView)
        
        NSLayoutConstraint.activate([
            loadingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingImageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
