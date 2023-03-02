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
        table.rowHeight = 200
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
    
    //TODO: "models: [String]" will be removed by API model
    func configure(models: [String]) {
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
        //TODO: We'll pass a model here
        cell.configure(model: "")
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
