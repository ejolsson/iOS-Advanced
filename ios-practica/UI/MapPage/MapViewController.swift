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
    
    let heroPlaces = [
        
        HeroModel(id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94", name: "Goku", photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300", description: "I am Goku!!!.", favorite: true, latitude: 39.326, longitude: -4.83),
        HeroModel(id: "D88BE50B-913D-4EA8-AC42-04D3AF1434E3", name: "Krilin", photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300", description: "This is Krilin...", favorite: false, latitude: 40.0, longitude: -5.0)
    ]
    
//    let heroPlaces = HeroListViewController.herosModel
    
    var heroLocations: [HeroModel] = []
    
    let latitude = 40.4155
    let longitude = -3.7074
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(heroPlaces)\n")
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        
        moveToCoordinates(self.latitude, self.longitude)//(40.4155, 3.7074)//(0,0) // removed ".self" and made no difference
        
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
//        let annotations = heroLocations.map { Annotation(place: $0) }
        let annotations = heroPlaces.map { Annotation(place: $0) } // this now shows hardcoded item
        
        mapView.showAnnotations(annotations, animated: true)
        
        print("MapViewController > heroModel[6]: \(HeroListViewController.herosModel[6])\n")
    } // end viewDidLoad

    func createAnnotation(_ place: HeroModel) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(place.latitude ?? 0.0), longitude: Double(place.longitude ?? 0.0))
        annotation.title = place.name // was .id
        annotation.subtitle = "You are seeing \(place.id)"
        
        mapView.addAnnotation(annotation)
    }
    
    func createAnnotations(_ heros: [HeroModel]) {
//        heroLocations.forEach(createAnnotation)
        heroPlaces.forEach(createAnnotation) // this now shows hardcoded item
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
