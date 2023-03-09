//
//  MainVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

final class MainVC: UIViewController {
    
    private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    var recipesModels: [Recipe] = []
    var searchedRecipes: [Recipe] = []
    
    private let apiManager = APICaller.shared
    private let mainTableView = MainTableView()
    
    var mainView = MainView()
    private let sections = MockData.shared.pageData
    private lazy var baseRecipe = Recipe(id: 0, image: "", title: "")
    lazy var popularRecipes: [Recipe] = [baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe]
    lazy var healthyRecipes: [Recipe] = [baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe]
    lazy var dessertRecipes: [Recipe] = [baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe, baseRecipe]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        title = "Team 11"
        mainView.configure(delegate: self, dataSource: self)
        mainView.collectionView.collectionViewLayout = createLayout()
        //constraintView()
        setup()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchController.isActive = false
        hideMainTableView(isTableViewHidden: true)
        mainView.collectionView.reloadData()
    }
    
    func fetchData() {
        fetchCollectionData(for: .popular)
        fetchCollectionData(for: .healthy)
        fetchCollectionData(for: .dessert)

        
        //setup()
    }
    
    func updateMainTableView() {
        mainTableView.configure(models: searchedRecipes)
        mainTableView.mainTableView.reloadData()
    }
}

//MARK: - Setup

private extension MainVC {
    
    func setup() {
        setDelegate()
        setupView()
        setConstraints()
        configureNavigationBar()
        
        hideMainTableView(isTableViewHidden: true)
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
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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

extension MainVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hideMainTableView(isTableViewHidden: true)
    }
 
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        hideMainTableView(isTableViewHidden: false)
    }
}

//MARK: - UISearchResultsUpdating

extension MainVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            searchedRecipes = recipesModels
            updateMainTableView()
            return
        }
        
        fetchSearchedRecipe(with: searchText)
    }
}

//MARK: - Search Recipes

private extension MainVC {
    
    func fetchSearchedRecipe(with searchText: String) {
        apiManager.searchRecipe(keyWord: searchText) { [weak self] result in
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
    }
}

//MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("тыкнул по ячейке \(indexPath.item) в секции \(indexPath.section)")
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

extension MainVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
        case .popular(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let detailedRecipe = popularRecipes[indexPath.item]
            
            cell.configure(
                model: detailedRecipe,
                section: indexPath.section,
                item: indexPath.item,
                saveButtonCompletion: self.createCompletion(with: detailedRecipe))
            
            print("srabotal cellForItemAt")
            
//            if popularRecipes.count < 10 {
//                cell.configureCell(imageName: popular[indexPath.item].image, section: indexPath.section, item: indexPath.item)
//                print("srabotal cellForItemAt")
//            } else {
//                cell.configure(model: popularRecipes[indexPath.item], section: indexPath.section, item: indexPath.item)
//                print("srabotal cellForItemAt")
//            }
            return cell
            
        case .healthy(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let detailedRecipe = healthyRecipes[indexPath.item]
            
            cell.configure(
                model: detailedRecipe,
                section: indexPath.section,
                item: indexPath.item,
                saveButtonCompletion: self.createCompletion(with: detailedRecipe))
            return cell
            
        case .dessert(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let detailedRecipe = dessertRecipes[indexPath.item]
            
            cell.configure(
                model: detailedRecipe,
                section: indexPath.section,
                item: indexPath.item,
                saveButtonCompletion: self.createCompletion(with: detailedRecipe))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSupplementaryView", for: indexPath) as! HeaderSupplementaryView
            header.configureHeader(categoryName: sections[indexPath.section].title)
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    private func createCompletion(with recipe: Recipe) -> (() -> ()) {
        let closure = {
            if Storage.shared.isItemSaved(withId: recipe.id) {
                Storage.shared.deleteitem(withId: recipe.id)
            } else {
                Storage.shared.write(recipe: recipe)
            }
        }
        return closure
    }
}

//MARK: - Create Layout

extension MainVC {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil}
            let section = self.sections[sectionIndex]
            switch section {
            case .popular(_):
                //return self.createSalesSection()
                return self.createExampleSection()
            case .healthy(_):
                //return self.createCategorySection()
                return self.createExampleSection()
            case .dessert(_):
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
        //section.supplementariesFollowContentInsets = contentInsets
        return section
    }
     
    private func createExampleSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(0.3)), subitems: [item])
        
        let section = createLayoutSection(group: group,
                                          behavior: .continuous,
                                          interGroupSpacing: 20,
                                          supplementaryItems: [supplementaryHeaderItem()],
                                          contentInsets: false)
        
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    
}
