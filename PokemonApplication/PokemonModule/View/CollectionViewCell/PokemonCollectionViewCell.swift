//
//  PokemonCollectionViewCell.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import UIKit

struct PokemonModel {
    let name: String
    let url: String
}

class PokemonCollectionViewCell: BaseCollectionViewCell {
    
    static var identifier: String {
        return String(describing: PokemonCollectionViewCell.self)
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setupView() {
        super.setupView()
        
        contentView.addSubview(nameLabel)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func set(_ data: PokemonModel) {

        nameLabel.text = data.name
    }
}
