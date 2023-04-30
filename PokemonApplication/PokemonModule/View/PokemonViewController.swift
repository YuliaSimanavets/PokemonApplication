//
//  ViewController.swift
//  PokemonApplication
//
//  Created by Yuliya on 11/04/2023.
//

import UIKit

class PokemonViewController: UIViewController {

    var presenter: PokemonViewPresenterProtocol?
    private var activityIndicator = UIActivityIndicatorView()
    
    private let pokemonsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let showMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show more", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let headerTitle = "Choose your pokemon 🙌🏼"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        addSubviews()
        setupConstraints()
        createActivityIndicator()
        
        pokemonsCollectionView.delegate = self
        pokemonsCollectionView.dataSource = self
        
        pokemonsCollectionView.register(PokemonCollectionViewCell.self,
                                        forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        pokemonsCollectionView.register(HeaderCollectionView.self,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                        withReuseIdentifier: HeaderCollectionView.identifier)
    }
    
    private func addSubviews() {
        view.addSubview(pokemonsCollectionView)
        view.addSubview(showMoreButton)
        showMoreButton.addTarget(self, action: #selector(actionShowMore), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pokemonsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pokemonsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstantsOffset.sideOffset.rawValue),
            pokemonsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstantsOffset.sideOffset.rawValue),
            pokemonsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -ConstantsOffset.topBottomOffset.rawValue),
            
            showMoreButton.topAnchor.constraint(equalTo: pokemonsCollectionView.bottomAnchor),
            showMoreButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            showMoreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createActivityIndicator() {
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    @objc
    func tapOnCellAction(_ sender: IndexPath) {
        guard let detailsUrl = presenter?.pokemons?[sender.row].url else { return }
        let detailsViewController = ModuleBuilder.createDetailsModule(url: detailsUrl)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    @objc
    func actionShowMore() {
        presenter?.loadNextPokemons()
    }
}

// MARK: - UICollectionViewDataSource
extension PokemonViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.pokemons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as? PokemonCollectionViewCell else { return UICollectionViewCell() }
        
        let name = presenter?.pokemons?[indexPath.item].name
        let url = presenter?.pokemons?[indexPath.item].url
        cell.set(.init(name: name ?? "", url: url ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.identifier, for: indexPath) as? HeaderCollectionView else { return UICollectionReusableView() }
        
        let item = headerTitle
        header.set(.init(titleText: item))
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PokemonViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = collectionView.frame
        let widthCell = frame.width - CGFloat(20)
        let heightCell = CGFloat(50)
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 60)
    }
}

// MARK: - UICollectionViewDelegate
extension PokemonViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapOnCellAction(indexPath)
    }
}

// MARK: - PokemonViewProtocol
extension PokemonViewController: PokemonViewProtocol {
    
    func succes() {
        activityIndicator.stopAnimating()
        pokemonsCollectionView.reloadData()
    }
    
    func failure(error: Error) {
        let alertController = UIAlertController(title: "Something was wrong :(",
                                                message: "Please, try again later",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        activityIndicator.stopAnimating()
    }
}
