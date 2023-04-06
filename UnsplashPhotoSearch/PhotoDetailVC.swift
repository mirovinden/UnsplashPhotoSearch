//
//  PhotoDetailViewController.swift
//  UnsplashPhotoSearch
//
//  Created by oleg on 04.04.2023.
//

import UIKit
import MapKit
import CoreLocation

class PhotoDetailViewController: UIViewController {
    var countryNameLabel: UILabel = .init()
    var cityNameLabel: UILabel = .init()
    var stackView: UIStackView = .init()
    
    let location: Location
    let mapView = MKMapView()
    
    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}


private extension PhotoDetailViewController {

    @objc func doneButtonPressed() {
        dismiss(animated: true)
    }

    func setupUI() {
        navigationItem.setLeftBarButton(
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed)),
            animated: true
        )
        title = "Info"
        
        view.backgroundColor = .gray
        view.addSubview(stackView)
        view.addSubview(mapView)

        stackView.addArrangedSubview(countryNameLabel)
        stackView.addArrangedSubview(cityNameLabel)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution  = .fillEqually
        
        countryNameLabel.text = "Country: \(location.country ?? "")"
        cityNameLabel.text = "City: \(location.city ?? "")"

        setupMapView()
        setupConstraints()
    }

    func setupMapView() {
        let latitude = location.position.latitude ?? 0
        let longitude = location.position.longitude ?? 0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        mapView.setRegion(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)),
            animated: true
        )

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let mapViewHeight: CGFloat = 200
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mapView.heightAnchor.constraint(equalToConstant: mapViewHeight),
            
            stackView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
}
