//
//  MainVC.swift
//  BookRecipes
//
//  Created by Emil Guseynov on 27.02.2023.
//

import UIKit

final class MainVC: UIViewController {
    
    private let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.showsCancelButton = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        mainView.configure(delegate: self, dataSource: self)
        mainView.collectionView.collectionViewLayout = createLayout()
        //constraintView()
        setup()
        fetchData()
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
        
        hideMainTableView(isTableViewHidden: true)
    }
    
    func setDelegate() {
        searchBar.delegate = self
    }
    
    func setupView() {
        view.addSubview(searchBar)
        view.addSubview(mainView)
        view.addSubview(mainTableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: mainView.topAnchor, constant: -20),
            searchBar.bottomAnchor.constraint(equalTo: mainTableView.topAnchor, constant: -20),
            
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func hideMainTableView(isTableViewHidden: Bool) {
        mainTableView.isHidden = isTableViewHidden
        mainView.isHidden = !isTableViewHidden
    }
}
 
//MARK: - UISearchBarDelegate

extension MainVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchedRecipes = recipesModels
        updateMainTableView()
        hideMainTableView(isTableViewHidden: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchedRecipes = recipesModels
            updateMainTableView()
            return
        }
        
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
                    self?.hideMainTableView(isTableViewHidden: false)
                    self?.updateMainTableView()
                }
            case .failure(let error):
                print (error)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        hideMainTableView(isTableViewHidden: false)
    }
}





//MARK: - UICollectionViewDelegate

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("тыкнул по ячейке \(indexPath.item) в секции \(indexPath.section)")
        let detailVC = DetailViewController()
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
            cell.configure(model: popularRecipes[indexPath.item], section: indexPath.section, item: indexPath.item)
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
            cell.configure(model: healthyRecipes[indexPath.item], section: indexPath.section, item: indexPath.item)
            return cell
            
        case .dessert(_):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(model: dessertRecipes[indexPath.item], section: indexPath.section, item: indexPath.item)
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
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    
}
