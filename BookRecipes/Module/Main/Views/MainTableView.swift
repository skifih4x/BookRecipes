//
//  MainTableView.swift
//  BookRecipes
//
//  Created by Buzz on 3/1/23.
//

import UIKit

final class MainTableView: UIView {

    let mainTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private var recipesItems: [Recipe] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(models: [Recipe]) {
        recipesItems = models
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainTableView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipesItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        cell.configure(model: recipesItems[indexPath.item])
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
