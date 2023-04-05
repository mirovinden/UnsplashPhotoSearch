//
//  ItemPerPageView.swift
//  UnsplashPhotoSearch
//
//  Created by Apple on 05.04.2023.
//

import UIKit

class ItemPerPageView: UIView {
    let segmentedControl = UISegmentedControl()
    let itemsPerPageLabel = UILabel()
    let stackView = UIStackView()
    var onEvent: (() -> Void)?

    init() {
        super.init(frame: CGRect())
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(stackView)


        itemsPerPageLabel.text = "Photos per page:"
        itemsPerPageLabel.font = .systemFont(ofSize: 14)

        stackView.addArrangedSubview(itemsPerPageLabel)
        stackView.addArrangedSubview(segmentedControl)
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 30)
        ])

        setupSegmentedControl()
    }

    func setupSegmentedControl() {
        segmentedControl.insertSegment(withTitle: "10", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "20", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "30", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addAction(
            UIAction { _ in self.onEvent?() },
            for: .valueChanged
        )

    }
}
