//
//  HeaderCollectionView.swift
//  PokemonApplication
//
//  Created by Yuliya on 14/04/2023.
//

import UIKit

struct HeaderViewModel {
    let titleText: String
}

class HeaderCollectionView: UICollectionReusableView {
    
    static var identifier: String {
        return String(describing: HeaderCollectionView.self)
    }
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 24, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func set(_ data: HeaderViewModel) {
        titleLabel.text = data.titleText
    }
}
