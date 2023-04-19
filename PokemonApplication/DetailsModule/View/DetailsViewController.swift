//
//  DetailsViewController.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    var presenter: DetailsViewPresenterProtocol?
    private var customView = CustomDetailsView()
    private var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
        createActivityIndicator()
        presenter?.getPokemon()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customView.widthAnchor.constraint(equalToConstant: 300),
            customView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func createActivityIndicator() {
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

// MARK: - DetailsViewProtocol
extension DetailsViewController: DetailsViewProtocol {
    func setPokemon(pokemon: CustomViewModel?) {
        guard let pokemon = pokemon else { return }
        customView.set(pokemon)
    }
    
    func succes() {
        activityIndicator.stopAnimating()
    }
    
    func failure(error: Error) {
        let alertController = UIAlertController(title: "Something was wrong :(",
                                                message: "Please, try again later",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        print(error.localizedDescription)
    }
}
