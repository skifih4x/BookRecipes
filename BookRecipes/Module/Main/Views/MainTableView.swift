//
//  MainTableView.swift
//  BookRecipes
//
//  Created by Buzz on 3/1/23.
//

import UIKit

final class MainTableView: UIView {

    private let mainTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        return table
    }()
    
    private var recipesItems: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: [String]) {
        recipesItems = model
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainTableView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipesItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}

//MARK: Setup

private extension MainTableView {
    
    func setup() {
        addSubview(mainTableView)
        setDelegate()
        setConstraints()
    }
    
    func setDelegate() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    func setConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: topAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
