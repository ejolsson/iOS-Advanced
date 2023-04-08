//
//  MapViewController.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager?
    
    let heroViewModel = HeroViewModel()
    let mapViewModel = MapViewModel()
    var heroPlaces: [HeroModel] = []
    
    let latitude = 40.4155
    let longitude = -3.7074
    
    override func viewDidLoad() {
        super.viewDidLoad()

        heroPlaces = HeroViewModel.heroesShow
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        
        configureMapView()
        configureAnnotations()
    }

    func configureMapView() {
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    func configureAnnotations() {
        
        moveToCoordinates(self.latitude, self.longitude)
        let annotations = heroPlaces.map { Annotation(place: $0) } // this now shows hardcoded item
        mapView.showAnnotations(annotations, animated: true)
    }
    
    func createAnnotation(_ place: HeroModel) {
      
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(place.latitude ?? 0.0), longitude: Double(place.longitude ?? 0.0))
        annotation.title = place.name // was .id
        annotation.subtitle = "You are seeing \(place.id)"
        
        mapView.addAnnotation(annotation)
    }
    
    func createAnnotations(_ heroes: [HeroModel]) {

        heroPlaces.forEach(createAnnotation)
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

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        debugPrint("annotation -> \(annotation)")
        let id = MKMapViewDefaultAnnotationViewReuseIdentifier
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id)
        
        if let annotation = annotation as? Annotation {
            
            annotationView?.canShowCallout = true
            annotationView?.detailCalloutAccessoryView = Callout(annotation: annotation)
            
            return annotationView
        }
        return nil
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
    }
    
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
    }
}
