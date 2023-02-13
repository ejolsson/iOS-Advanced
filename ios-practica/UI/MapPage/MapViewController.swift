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
    
    let heroPlaces = [

//        Place(name: "España", latitude: 39.3260685, longitude: -4.8379791, image: "https://photo980x880.mnstatic.com/37f93c7924cb320de906a1f1b9f4e12a/la-gran-via-de-madrid-1072541.jpg"),

//        Place(name: "España", latitude: 39.3260685, longitude: -4.8379791, image: "http://i.annihil.us/u/prod/marvel/i/mg/b/c0/553a9abceb412/portrait_incredible.jpg"),

        Place(name: "Bilbao", latitude: 43.2630018, longitude: -2.9350039, image: "http://i.annihil.us/u/prod/marvel/i/mg/b/c0/553a9abceb412/portrait_incredible.jpg"),
        Place(name: "A Coruna", latitude: 43.3709703, longitude: -8.3959425, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300"),
        Place(name: "Barcelona", latitude: 41.3828939, longitude: 2.1774322, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/dragon-ball-satan.jpg?width=300"),
        Place(name: "Pamplona", latitude: 42.8182536, longitude: -1.6440304, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300"),
        Place(name: "Malaga", latitude: 36.7213028, longitude: -4.4216366, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300"),
        Place(name: "Las Palmas", latitude: 28.1288694, longitude: -15.4349015, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300"),
        Place(name: "Cadiz", latitude: 36.5297438, longitude: -6.2928976, image: "https://cdn.alfabetajuega.com/alfabetajuega/2021/01/Bulma-Dragon-Ball.jpg?width=300"),
        Place(name: "San Sebastian", latitude: 43.3224219, longitude: -1.9838889, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/freezer-dragon-ball-bebe-abj.jpg?width=300"),
        Place(name: "Alicante", latitude: 38.3436365, longitude: -0.4881708, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/dragon-ball-super-beerus.jpg?width=300"),
        Place(name: "Palma de Mallorca", latitude: 39.5695818, longitude: 2.6500745, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/09/piccolo.jpg?width=300"),
        Place(name: "Zaragoza", latitude: 41.6521342, longitude: -0.8809428, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/09/Por-esto-aun-Kaito-no-lo-han-resucitado.jpg?width=300"),
        Place(name: "Cordoba", latitude: 37.8845813, longitude: -4.7760138, image: "https://cdn.alfabetajuega.com/alfabetajuega/2019/10/Raditz.jpg?width=300"),
        Place(name: "Granada", latitude: 37.1734995, longitude: -3.5995337, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/05/3CD8B1C5-134E-419E-AB5D-D1440C922A7E-e1590480274537.png?width=300"),
        Place(name: "Valencia", latitude: 39.4697065, longitude: -0.3763353, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/01/Androide-18.jpg?width=300"),
        Place(name: "Seville", latitude: 37.3886303, longitude: -5.9953403, image: "https://cdn.alfabetajuega.com/alfabetajuega/2019/10/dragon-ball-androide-17.jpg?width=300"),
        Place(name: "Madrid", latitude: 40.4167047, longitude: -3.7035825, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/07/Trunks.jpg?width=300"),
        Place(name: "Salamanca", latitude: 40.9651572, longitude: -5.6640182, image: "https://wallpaperaccess.com/full/1130512.jpg"),
    ]
    
    let latitude = 40.4155
    let longitude = -3.7074
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        
        moveToCoordinates(self.latitude, self.longitude)//(40.4155, 3.7074)//(0,0) // removed ".self" and made no difference
        
        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let annotations = heroPlaces.map { Annotation(place: $0) }
        
        mapView.showAnnotations(annotations, animated: true)
    }

    func createAnnotation(_ place: Place) {
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        annotation.title = place.name
        annotation.subtitle = "You are seeing \(place.name)"
        
        mapView.addAnnotation(annotation)
    }
    
    func createAnnotations(_ places: [Place]) {
        places.forEach(createAnnotation)
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
