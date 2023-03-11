//
//  MainVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    var recipesModels: [Recipe] = []
    var searchedRecipes: [Recipe] = []
    
    private let apiManager = APICaller.shared
    private let mainTableView = MainTableView()
    private var searchTimer: Timer?
    
    var mainView = MainView()
    private let sections = SectionsData.shared.sectionsArray
        
    lazy var popularRecipes: [Recipe] = []
    lazy var healthyRecipes: [Recipe] = []
    lazy var dessertRecipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Team 11"
        mainView.configure(delegate: self, dataSource: self)
        mainView.collectionView.collectionViewLayout = createLayout()
        setup()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchedRecipes = recipesModels
        updateMainTableView()
        searchController.isActive = false
        hideMainTableView(isTableViewHidden: true)
        mainView.collectionView.reloadData()
    }
    
    func fetchData() {
        fetchCollectionData(for: .popularity)
        fetchCollectionData(for: .healthiness)
        fetchCollectionData(for: .sugar)
    }
    
    func updateMainTableView() {
        mainTableView.configure(models: searchedRecipes, navigationController: navigationController)
        mainTableView.mainTableView.reloadData()
    }
}

//MARK: - Setup

private extension MainViewController {
    
    func setup() {
        setDelegate()
        setupView()
        setConstraints()
        configureNavigationBar()
        getBaseItems()
    }
    
    private func getBaseItems() {
        let baseRecipe = Recipe(id: 0, image: "", title: "")
        for _ in 1...10 {
            popularRecipes.append(baseRecipe)
            healthyRecipes.append(baseRecipe)
            dessertRecipes.append(baseRecipe)
        }
    }
    
    func setDelegate() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    func setupView() {
        navigationItem.searchController = searchController
        view.addSubview(mainView)
        view.addSubview(mainTableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.hidesBarsWhenKeyboardAppears = false
    }
    
    func hideMainTableView(isTableViewHidden: Bool) {
        mainTableView.isHidden = isTableViewHidden
        mainView.isHidden = !isTableViewHidden
    }
}
 
//MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchedRecipes = recipesModels
        updateMainTableView()
        hideMainTableView(isTableViewHidden: true)
    }
 
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        hideMainTableView(isTableViewHidden: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isEmpty else { return }
        
        searchController.isActive = false
        searchedRecipes = []
        updateMainTableView()
    }
}

//MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else { return }
        
        guard searchController.isActive, let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            return
        }
        
        fetchSearchedRecipe(with: searchText)
    }
}

//MARK: - Search Recipes

private extension MainViewController {
    
    func fetchSearchedRecipe(with searchText: String) {
        searchTimer?.invalidate()
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { [weak self] (timer) in
            self?.apiManager.searchRecipe(keyWord: searchText) { [weak self] result in
                switch result {
                case .success(let recipes):
                    let dispatchGroup = DispatchGroup()
                    var models: [Recipe] = []
                    recipes.forEach { recipe in
                        dispatchGroup.enter()
                        self?.apiManager.getDetailedRecipe(with: recipe.id) { result in
                            defer { dispatchGroup.leave() }
                            switch result {
                            case .success(let data):
                                guard let title = data.title, let image = data.image else { return }
                                models.append(Recipe(id: data.id, image: image, title: title))
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }

                    dispatchGroup.notify(queue: .main) {
                        self?.searchedRecipes = models
                        self?.updateMainTableView()
                        self?.hideMainTableView(isTableViewHidden: false)
                    }
                case .failure(let error):
                    print (error)
                }
            }
        })
    }
}

//MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var id = 0
        switch indexPath.section {
        case 0:
            id = popularRecipes[indexPath.item].id
        case 1:
            id = healthyRecipes[indexPath.item].id
        case 2:
            id = dessertRecipes[indexPath.item].id
        default:
            return
        }
        
        let detailVC = DetailViewController()
        detailVC.detailRecipeID = id
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
        case .popular:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? CollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let detailedRecipe = popularRecipes[indexPath.item]
            
            cell.configure(
                model: detailedRecipe,
                section: indexPath.section,
                item: indexPath.item,
                saveButtonCompletion: Storage.shared.createCompletion(with: detailedRecipe))
            return cell
            
        case .healthy:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? CollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let detailedRecipe = healthyRecipes[indexPath.item]
            
            cell.configure(
                model: detailedRecipe,
                section: indexPath.section,
                item: indexPath.item,
                saveButtonCompletion: Storage.shared.createCompletion(with: detailedRecipe))
            return cell
            
        case .dessert:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? CollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let detailedRecipe = dessertRecipes[indexPath.item]
            
            cell.configure(
                model: detailedRecipe,
                section: indexPath.section,
                item: indexPath.item,
                saveButtonCompletion: Storage.shared.createCompletion(with: detailedRecipe))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSupplementaryView", for: indexPath) as! HeaderSupplementaryView
            header.configureHeader(categoryName: sections[indexPath.section].title, navController: navigationController!)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - Create Layout

extension MainViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil}
            let section = self.sections[sectionIndex]
            switch section {
            case .popular:
                return self.createExampleSection()
            case .healthy:
                return self.createExampleSection()
            case .dessert:
                return self.createExampleSection()
            }
        }
    }
    
    private func createLayoutSection(group: NSCollectionLayoutGroup,
                                     behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior,
                                     interGroupSpacing: CGFloat,
                                     supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem],
                                     contentInsets: Bool) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = behavior
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        return section
    }
     
    private func createExampleSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(0.23)), subitems: [item])
        
        let section = createLayoutSection(group: group,
                                          behavior: .continuous,
                                          interGroupSpacing: 20,
                                          supplementaryItems: [supplementaryHeaderItem()],
                                          contentInsets: false)
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}
