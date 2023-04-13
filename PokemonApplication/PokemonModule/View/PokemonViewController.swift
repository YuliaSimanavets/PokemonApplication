//
//  ViewController.swift
//  PokemonApplication
//
//  Created by Yuliya on 11/04/2023.
//

import UIKit

class PokemonViewController: UIViewController,
                             UICollectionViewDelegate,
                             UICollectionViewDataSource,
                             UICollectionViewDelegateFlowLayout {

    var presenter: PokemonViewPresenterProtocol!
    var activityIndicator = UIActivityIndicatorView()
    
    private let pokemonsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
// Array for a test run (data is not from the network)
    private let arrayName = ["bulbasaur", "ivysaur", "venusaur", "charmander", "charmeleon", "charizard", "bulbasaur", "ivysaur", "venusaur", "charmander", "charmeleon", "charizard", "bulbasaur", "ivysaur", "venusaur", "charmander", "charmeleon", "charizard"]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        
        view.addSubview(pokemonsCollectionView)
        pokemonsCollectionView.delegate = self
        pokemonsCollectionView.dataSource = self
        
        pokemonsCollectionView.register(PokemonCollectionViewCell.self,
                                        forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)

        createActivityIndicator()
        
        NSLayoutConstraint.activate([
            pokemonsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pokemonsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pokemonsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayName.count
//        return presenter.pokemons?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as? PokemonCollectionViewCell else { return UICollectionViewCell() }
        
//        let item = presenter.pokemons?[indexPath.item].name
//        let url = presenter.pokemons?[indexPath.item].url
        let name = arrayName[indexPath.item]
        cell.set(.init(name: name, url: ""))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = collectionView.frame
        let widthCell = frame.width - CGFloat(20)
        let heightCell = CGFloat(50)
        return CGSize(width: widthCell, height: heightCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        tapOnCellAction(indexPath)
    }
    
    @objc
    func tapOnCellAction(_ sender: IndexPath) {
        let detailsUrl = presenter.pokemons?[sender.row].url
        
        let detailsViewController = ModuleBuilder.createDetailsModule(url: detailsUrl!)
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    private func createActivityIndicator() {

        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

extension PokemonViewController: PokemonViewProtocol {
    
    func succes() {
        pokemonsCollectionView.reloadData()
    }
    
    func failure(error: Error) {
        print(error)
    }
}
