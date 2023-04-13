//
//  DetailsViewController.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    var presenter: DetailsViewPresenterProtocol!
    private var customView = CustomDetailsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pokemon Details"
        view.backgroundColor = .lightGray
        
        view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        presenter.getPokemon()
    
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customView.widthAnchor.constraint(equalToConstant: 300),
            customView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}

extension DetailsViewController: DetailsViewProtocol {
    
    func succes() {
        print("succes")
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }

    func setPokemon(pokemon: CustomViewModel?) {
        guard let pokemon = pokemon else { return }
        customView.set(pokemon)
    }
}
