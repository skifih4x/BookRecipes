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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    convenience init(isChecked: Bool) {
        self.init(frame: .zero)
        bookmarkImageView.image = isChecked ? UIImage(named: "bookmark selected") : UIImage(named: "bookmark")
    }
    
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
    
    func toggle(with isChecked: Bool) {
        bookmarkImageView.image = isChecked ? UIImage(named: "bookmark selected") : UIImage(named: "bookmark")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
