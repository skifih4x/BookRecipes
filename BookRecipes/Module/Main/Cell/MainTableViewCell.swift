//
//  MainTableViewCell.swift
//  BookRecipes
//
//  Created by Buzz on 3/1/23.
//

import UIKit
import SDWebImage

final class MainTableViewCell: UITableViewCell {
    
    private let recipeImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.sd_imageIndicator = SDWebImageActivityIndicator.gray
        return view
    }()
    
    private let recipeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica Neue Bold", size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var saveButton = SaveButton()
    
    var isSaved = false {
        didSet {
            saveButton.toggle(with: isSaved)
        }
    }
    var saveButtonClosure: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        saveButtonSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Recipe, saveButtonClosure: @escaping () -> ()) {
        guard let image = model.image else { return }
        recipeImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "loading.jpg"))
        recipeNameLabel.text = model.title
        isSaved = Storage.shared.isItemSaved(withId: model.id)
        self.saveButtonClosure = saveButtonClosure
    }
}

//MARK: Setup

private extension MainTableViewCell {
    
    func setup() {
        setupView()
        setConstraints()
    }
    
    func setupView() {
        clipsToBounds = true
        contentView.addSubview(recipeImageView)
        contentView.addSubview(recipeNameLabel)
        contentView.addSubview(saveButton)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recipeImageView.heightAnchor.constraint(equalToConstant: 200),
            
            recipeNameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 10),
            recipeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recipeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            recipeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            saveButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 35),
            saveButton.widthAnchor.constraint(equalToConstant: 35),
        ])
    }

}

//  MARK: - Save button setup

extension MainTableViewCell {
    
    private func saveButtonSetup() {
        saveButton.addTarget(
            self,
            action: #selector(saveButtonTapped),
            for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        saveButtonClosure?()
        isSaved.toggle()
    }
}
