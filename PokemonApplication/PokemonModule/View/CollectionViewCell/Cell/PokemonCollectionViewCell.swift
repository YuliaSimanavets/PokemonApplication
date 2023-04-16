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
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "seal.fill")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func setupView() {
        super.setupView()
        
        contentView.backgroundColor = .cellsColor
        contentView.layer.cornerRadius = 12
        
        contentView.addSubview(dotImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            dotImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dotImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            
            nameLabel.centerYAnchor.constraint(equalTo: dotImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: dotImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: chevronImageView.leadingAnchor, constant: -20),
            
            chevronImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    func set(_ data: PokemonModel) {
        nameLabel.text = data.name
    }
}
