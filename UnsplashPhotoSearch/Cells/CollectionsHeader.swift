//
//  CollectionsHeader.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 30.03.2023.
//

import UIKit

class CollectionsHeaderView: UICollectionReusableView {
        
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 15)

        return label
    }()

    let photoCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 11)

        return label
    }()

    let stackView: UIStackView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(stackView)

        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(photoCountLabel)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
    
}

class SectionBackgroundColor: UICollectionReusableView {
    let view: UIView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(view)
        view.backgroundColor = .systemGray2.withAlphaComponent(0.15)
        view.layer.cornerRadius = 5
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }

}
