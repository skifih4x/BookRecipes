//
//  SavedTableCell.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

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
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellImageView)
        contentView.addSubview(nameLabel)
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
            cellImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, constant: -inset),
            
            nameLabel.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: inset),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ])
    }
    
    func configure(with image: UIImage?, text: String) {
        self.cellImageView.image = image
        self.nameLabel.text = text
    }
}
