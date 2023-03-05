//
//  SaveButton.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 03.03.2023.
//

import UIKit

final class SaveButton: UIButton {
    
    lazy var bookmarkImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bookmark")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 17.5
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bookmarkImageView)
        
        NSLayoutConstraint.activate([
            bookmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            bookmarkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: 19),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
