//
//  MainView.swift
//  BookRecipes
//
//  Created by Ян Бойко on 28.02.2023.
//

import UIKit

class MainView: UIView {
    
    var popularRecipes: [SafeRecipe] = []
    var healthyRecipes: [SafeRecipe] = []
    var dessertRecipes: [SafeRecipe] = []
    
    var boolArray: [[Bool]] = [[false, false, false, false, false, false, false, false, false, false],
                               [false, false, false, false, false, false, false, false, false, false],
                               [false, false, false, false, false, false, false, false, false, false]]
    
    private let sections = MockData.shared.pageData
    
    let collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .none
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
        setDelegates()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(collectionView)
        collectionView.register(ExampleCollectionViewCell.self, forCellWithReuseIdentifier: "ComingSoonCollectionViewCell")
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSupplementaryView")
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

//MARK: - Create Layout

extension MainView {
    
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

//MARK: - UICollectionViewDelegate

extension MainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("тыкнул по ячейке \(indexPath.item) в секции \(indexPath.section)")
    }
}

//MARK: - UICollectionViewDataSource

extension MainView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if popularRecipes.count < 10 {
            return sections[section].count
        } else {
            return popularRecipes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch sections[indexPath.section] {
        case .popular(let popular):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            if popularRecipes.count < 10 {
                cell.configureCell(imageName: popular[indexPath.item].image, section: indexPath.section, item: indexPath.item)
                print("srabotal cellForItemAt")
            } else {
                cell.configure(model: popularRecipes[indexPath.item], section: indexPath.section, item: indexPath.item)
                print("srabotal cellForItemAt")
            }
            return cell
            
        case .healthy(let healthy):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            if dessertRecipes.count < 10 {
                cell.configureCell(imageName: healthy[indexPath.item].image, section: indexPath.section, item: indexPath.item)
            } else {
                cell.configure(model: healthyRecipes[indexPath.item], section: indexPath.section, item: indexPath.item)
            }
            return cell
            
        case .dessert(let dessert):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComingSoonCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            if dessertRecipes.count < 10 {
                cell.configureCell(imageName: dessert[indexPath.item].image, section: indexPath.section, item: indexPath.item)
            } else {
                cell.configure(model: dessertRecipes[indexPath.item], section: indexPath.section, item: indexPath.item)
            }
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

//MARK: - Set Constraints

extension MainView {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
