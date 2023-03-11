//
//  ViewController3.swift
//  BookRecipes
//
//  Created by Ян Бойко on 08.03.2023.
//

import UIKit

class FavouritesViewController: UIViewController {

    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Favourites")
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "You can save recipes to favorites and return to it later!"
        view.font = UIFont(name: "Helvetica Neue Bold", size: 40)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let endButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Let's cook \u{1F373}", for: .normal)
        view.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        view.backgroundColor = .red
        view.setTitleColor(.black, for: .normal)
        view.layer.cornerRadius = 10
        view.addTarget(nil, action: #selector(endButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    @objc func endButtonTapped() {
        UserDefaults.standard.set(true, forKey: "hasOnboarded")
        let tabBar = BaseTabBarController()
        tabBar.modalPresentationStyle = .fullScreen
        self.present(tabBar, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(textLabel)
        view.addSubview(logoImageView)
        view.addSubview(endButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            logoImageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            endButton.heightAnchor.constraint(equalToConstant: 50),
            endButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            endButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            endButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
