//
//  MapViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/27/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    let latitude = 40.4155
    let longitude = 3.7074
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        
        moveToCoordinates(self.latitude, self.longitude)//(40.4155, 3.7074)//(0,0) // removed ".self" and made no difference
    }

    func moveToCoordinates(_ latitude: Double, _ longitude: Double) {
        
        let center = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 40,
                                    longitudeDelta: 60)
        
        let region = MKCoordinateRegion(center: center,
                                        span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .notDetermined:
                debugPrint("Not determined")
            case .restricted:
                debugPrint("restricted")
            case .denied:
                debugPrint("denied")
            case .authorizedAlways:
                debugPrint("authorized always")
            case .authorizedWhenInUse:
                debugPrint("authorized when in use")
            @unknown default:
                debugPrint("Unknow status")
            }
        }
    } // complete
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            debugPrint("Not determined")
        case .restricted:
            debugPrint("restricted")
        case .denied:
            debugPrint("denied")
        case .authorizedAlways:
            debugPrint("authorized always")
        case .authorizedWhenInUse:
            debugPrint("authorized when in use")
        @unknown default:
            debugPrint("Unknow status")
        }
    } // complete
    
} // complete
