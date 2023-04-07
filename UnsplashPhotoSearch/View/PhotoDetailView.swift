//
//  PhotoDetailView.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 07.04.2023.
//

import UIKit
import MapKit

class PhotoDetailView: UIView {
    var countryNameLabel: UILabel = .init()
    var cityNameLabel: UILabel = .init()
    private let stackView: UIStackView = .init()
    private lazy var mapViewHeight =  mapView.heightAnchor.constraint(equalToConstant: 300)
    private lazy var mapViewHeightZero = mapView.heightAnchor.constraint(equalToConstant: 0)

    
    let mapView = MKMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .gray
        addSubview(stackView)
        addSubview(mapView)
        
        stackView.addArrangedSubview(countryNameLabel)
        stackView.addArrangedSubview(cityNameLabel)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution  = .fillEqually
        stackView.spacing = 8
        
        cityNameLabel.font = UIFont.systemFont(ofSize: 20)
        countryNameLabel.font = UIFont.systemFont(ofSize: 20)
    
        setupConstraints()
    }
    
    func changeMapHeight() {
        mapViewHeight.isActive = false
        mapViewHeightZero.isActive = true
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mapViewHeight,
            
            stackView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}
