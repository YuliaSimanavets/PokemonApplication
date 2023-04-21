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
        layer.cornerRadius = ConstantsOffset.cornerRadius.rawValue
        
        addSubview(pokemonsNameLabel)
        addSubview(pokemonsImageView)
        addSubview(stackView)
        
        stackView.addArrangedSubview(pokemonsTypeLabel)
        stackView.addArrangedSubview(pokemonsWeightLabel)
        stackView.addArrangedSubview(pokemonsHeightLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pokemonsNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: ConstantsOffset.topBottomOffset.rawValue),
            pokemonsNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            pokemonsImageView.topAnchor.constraint(equalTo: pokemonsNameLabel.bottomAnchor, constant: ConstantsOffset.topBottomOffset.rawValue),
            pokemonsImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pokemonsImageView.widthAnchor.constraint(equalToConstant: ConstantsOffset.sizeImage.rawValue),
            pokemonsImageView.heightAnchor.constraint(equalToConstant: ConstantsOffset.sizeImage.rawValue),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ConstantsOffset.sideOffset.rawValue),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ConstantsOffset.sideOffset.rawValue),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ConstantsOffset.topBottomOffset.rawValue)
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
