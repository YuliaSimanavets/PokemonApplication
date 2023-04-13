//
//  DetailsViewController.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    var presenter: DetailsViewPresenterProtocol!
    
    private let customView = CustomDetailsView()
    
    private let details = CustomViewModel(pokemonsName: "Dragon", pokemonsType: "night", pokemonsHeight: "7", pokemonsWeight: "20", pokemonsImage: UIImage(systemName: "sunrise.circle"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.set(details)
        
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
        print("everything is OK")
    }
    
    func failure(error: Error) {
        let alertController = UIAlertController(title: title, message: "Something went wrong :(", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
