//
//  PageNumberView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 05.04.2023.
//

import UIKit

class PageNumberView: UIView {
    let previousPageButton = UIButton(configuration: .borderless())
    let nextPageButton = UIButton(configuration: .borderless())
    let pageNumberLabel = UILabel()
    let pageStackView = UIStackView()
    
    var onEvent: ((UIButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        addSubview(pageStackView)
        pageStackView.addArrangedSubview(previousPageButton)
        pageStackView.addArrangedSubview(pageNumberLabel)
        pageStackView.addArrangedSubview(nextPageButton)
        pageStackView.distribution = .equalSpacing
        pageStackView.spacing = 5
        pageStackView.backgroundColor = .systemGray3.withAlphaComponent(0.9)
        pageStackView.layer.cornerRadius = 8
        
        previousPageButton.configuration?.title = "<"
        previousPageButton.isEnabled = false
        nextPageButton.configuration?.title = ">"

        [previousPageButton, nextPageButton].forEach { button in
            button.addAction(
                UIAction { action in self.onEvent?(button) },
                for: .touchUpInside
            )
        }
        
        pageNumberLabel.text = "1"
        pageNumberLabel.textColor = .blue
        setupConstraints()
    }
    func setupConstraints() {
        pageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageStackView.heightAnchor.constraint(equalToConstant: 30),

        ])
    }
}
