//
//  CustomDetailsView.swift
//  PokemonApplication
//
//  Created by Yuliya on 12/04/2023.
//

import UIKit

struct CustomViewModel {
    let pokemonsName: String
    let pokemonsType: String
    let pokemonsHeight: String
    let pokemonsWeight: String
    let pokemonsImage: UIImage?
}

class CustomDetailsView: UIView {

    private let pokemonsNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokemonsTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokemonsHeightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pokemonsWeightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pokemonsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
 
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        
        backgroundColor = .cellsColor
        layer.cornerRadius = 20
        addSubview(pokemonsNameLabel)
        addSubview(pokemonsImageView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(pokemonsTypeLabel)
        stackView.addArrangedSubview(pokemonsWeightLabel)
        stackView.addArrangedSubview(pokemonsHeightLabel)
        
        NSLayoutConstraint.activate([
            pokemonsNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            pokemonsNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pokemonsImageView.topAnchor.constraint(equalTo: pokemonsNameLabel.bottomAnchor, constant: 20),
            pokemonsImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pokemonsImageView.widthAnchor.constraint(equalToConstant: 120),
            pokemonsImageView.heightAnchor.constraint(equalToConstant: 120),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
            
        ])
    }
    
    func set(_ data: CustomViewModel) {
        
        pokemonsNameLabel.text = data.pokemonsName
        pokemonsTypeLabel.text = "type: " + data.pokemonsType
        pokemonsWeightLabel.text = "weight: " + data.pokemonsWeight + " " + "kg"
        pokemonsHeightLabel.text = "height: " +  data.pokemonsHeight + " " + "cm"
        pokemonsImageView.image = data.pokemonsImage
    }
}
