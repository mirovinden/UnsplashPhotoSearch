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
    let photoDetailView = PhotoDetailView()
    let location: Location
    
    init(location: Location) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension PhotoDetailViewController {

    @objc func doneButtonPressed() {
        dismiss(animated: true)
    }

    func setup() {
        navigationItem.setLeftBarButton(
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed)),
            animated: true
        )
        title = "Info"
        view.addSubview(photoDetailView)
        view.backgroundColor = .gray
        photoDetailView.countryNameLabel.text = "Country: \(location.country ?? "")"
        photoDetailView.cityNameLabel.text = "City: \(location.city ?? "")"

        setupMapView()
        setupConstraints()
    }

    func setupMapView() {
        guard let latitude = location.position.latitude, let longitude = location.position.longitude else {
            photoDetailView.changeMapHeight()
            return
        }
    
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        photoDetailView.mapView.setRegion(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)),
            animated: true
        )

        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        photoDetailView.mapView.addAnnotation(pin)
        
    }
    
    func setupConstraints() {
        photoDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            photoDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photoDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
