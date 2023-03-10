//
//  ViewController1.swift
//  BookRecipes
//
//  Created by Ян Бойко on 08.03.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "result2")
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "Welcome to our recipe book \u{1F4D6}"
        view.font = UIFont(name: "Helvetica Neue Bold", size: 40)
        view.numberOfLines = 2
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 234/255, green: 226/255, blue: 183/255, alpha: 1)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(textLabel)
        view.addSubview(logoImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            logoImageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 30),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
