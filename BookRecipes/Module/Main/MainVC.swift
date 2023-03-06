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
    
    private var recipesModels: [SafeRecipe] = []
    private var searchedRecipes: [SafeRecipe] = []
    
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
    
    func updateMainTableView() {
        mainTableView.configure(models: searchedRecipes)
        mainTableView.mainTableView.reloadData()
    }
    
    func hideMainTableView(isTableViewHidden: Bool) {
        mainTableView.isHidden = isTableViewHidden
        mainView.isHidden = !isTableViewHidden
    }
    
    func fetchData(for type: Types) {
        let dispatchGroup = DispatchGroup()
        APICaller.shared.getSortedRecipes(type: type) { results in
            switch results {
            case .success(let recipes):
                // Успешно получено
                for i in recipes {
                    dispatchGroup.enter()
                    APICaller.shared.getDetailedRecipe(with: i.id) { results in
                        switch results {
                        case .success(let recipe):
                            print(recipe)
                            // успешно получены детальные данные
                            APICaller.shared.getImage(from: recipe.image!) { result in
                                switch result {
                                case .success(let imageData):
                                    let safeRecipe = SafeRecipe(recipe: recipe, imageData: imageData)
                                    self.recipesModels.append(safeRecipe)
//                                    switch type {
//                                    case .popular:
//                                        self.mainView.popularRecipes.append(safeRecipe)
//                                    case .healthy:
//                                        self.mainView.healthyRecipes.append(safeRecipe)
//                                    case .dessert:
//                                        self.mainView.dessertRecipes.append(safeRecipe)
//                                    }
                                case .failure(let error):
                                    print(error)
                                }
                                dispatchGroup.leave()
                            }
                        case .failure(let error):
                            print(error)
                            // получена ошибка при запросе детальных данных
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.mainView.collectionView.reloadData()
                    self.searchedRecipes = self.recipesModels
                    self.updateMainTableView()
                }
            case .failure(let error):
                print (error)
                // получена ошибка
            }
        }
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
        apiManager.searchRecipe(keyWord: searchText) { [weak self] result in
            switch result {
            case .success(let data):
//                data.forEach { recipe in
//                    self?.apiManager.getImage(from: recipe.image) { result in
//                        switch result {
//                        case .success(let imageData):
//                            let safeRecipe = SafeRecipe(recipe: recipe, imageData: imageData)
//                        case .failure(let error):
//                            print (error)
//                        }
//                    }
//                }
                
                var models: [SafeRecipe] = []
                data.forEach { recipe in
                    guard let index = self?.recipesModels.firstIndex(where: { $0.recipe.id == recipe.id }), let model = self?.recipesModels[index] else { return }
                    models.append(model)
                }
                
                self?.searchedRecipes = models
                DispatchQueue.main.async {
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
            Storage.shared.write(recipe: recipe)
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
        
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    
}
