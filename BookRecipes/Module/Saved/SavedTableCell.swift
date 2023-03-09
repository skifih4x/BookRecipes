//
//  SavedTableCell.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit
import SDWebImage

class SavedTableCell: UITableViewCell {
    
    static let reuseId = "SavedTableCell"

    let inset: CGFloat = 16
    
    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    lazy var ratingView = RatingView()
    lazy var saveButton = SaveButton(isChecked: true)
    
    var saveButtonClosure: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellImageView)
        contentView.addSubview(nameLabel)
//        contentView.addSubview(ratingView)
        contentView.addSubview(saveButton)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        backgroundColor = .clear
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints() {
        NSLayoutConstraint.activate([
            
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            cellImageView.heightAnchor.constraint(equalTo: cellImageView.widthAnchor, multiplier: 9/16),
            
            nameLabel.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
//            ratingView.topAnchor.constraint(equalTo: cellImageView.topAnchor, constant: 10),
//            ratingView.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: 10),
//            ratingView.heightAnchor.constraint(equalToConstant: 35),
//            ratingView.widthAnchor.constraint(equalToConstant: 70),
            
            saveButton.topAnchor.constraint(equalTo: cellImageView.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 35),
            saveButton.widthAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    @objc func saveButtonTapped() {
        
        saveButtonClosure?()
    }
    
    func configure(with image: Data, text: String,  saveButtonAction: @escaping () -> ()) {
        self.cellImageView.image = UIImage(data: image)
        self.nameLabel.text = text
        self.saveButtonClosure = saveButtonAction
    }
}
