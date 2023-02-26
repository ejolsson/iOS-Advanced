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
    
    let heroPlaces = [ // TODO: Replace this array with one from Core Data

        Place(id: "AB3A873C-37B4-4FDE-A50F -8014D40D94FE", latitud: "39.3260685", longitud: "-4.8379791"),//, dateShow: "2022-09-11T00: 00:00Z", name: "Test"),

//        Place(name: "España", latitude: 39.3260685, longitude: -4.8379791, image: "http://i.annihil.us/u/prod/marvel/i/mg/b/c0/553a9abceb412/portrait_incredible.jpg"),

//        Place(id: "Bilbao", latitud: 43.2630018, longitud: -2.9350039, image: "http://i.annihil.us/u/prod/marvel/i/mg/b/c0/553a9abceb412/portrait_incredible.jpg"),
//        Place(id: "A Coruna", latitud: 43.3709703, longitud: -8.3959425, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300"),
//        Place(id: "Barcelona", latitud: 41.3828939, longitud: 2.1774322, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/dragon-ball-satan.jpg?width=300"),
//        Place(id: "Pamplona", latitud: 42.8182536, longitud: -1.6440304, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/08/Krilin.jpg?width=300"),
//        Place(id: "Malaga", latitud: 36.7213028, longitud: -4.4216366, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300"),
//        Place(id: "Las Palmas", latitud: 28.1288694, longitud: -15.4349015, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300"),
//        Place(id: "Cadiz", latitud: 36.5297438, longitud: -6.2928976, image: "https://cdn.alfabetajuega.com/alfabetajuega/2021/01/Bulma-Dragon-Ball.jpg?width=300"),
//        Place(id: "San Sebastian", latitud: 43.3224219, longitud: -1.9838889, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/freezer-dragon-ball-bebe-abj.jpg?width=300"),
//        Place(id: "Alicante", latitud: 38.3436365, longitud: -0.4881708, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/dragon-ball-super-beerus.jpg?width=300"),
//        Place(id: "Palma de Mallorca", latitud: 39.5695818, longitud: 2.6500745, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/09/piccolo.jpg?width=300"),
//        Place(id: "Zaragoza", latitud: 41.6521342, longitud: -0.8809428, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/09/Por-esto-aun-Kaito-no-lo-han-resucitado.jpg?width=300"),
//        Place(id: "Cordoba", latitud: 37.8845813, longitud: -4.7760138, image: "https://cdn.alfabetajuega.com/alfabetajuega/2019/10/Raditz.jpg?width=300"),
//        Place(id: "Granada", latitud: 37.1734995, longitud: -3.5995337, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/05/3CD8B1C5-134E-419E-AB5D-D1440C922A7E-e1590480274537.png?width=300"),
//        Place(id: "Valencia", latitud: 39.4697065, longitud: -0.3763353, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/01/Androide-18.jpg?width=300"),
//        Place(id: "Seville", latitud: 37.3886303, longitud: -5.9953403, image: "https://cdn.alfabetajuega.com/alfabetajuega/2019/10/dragon-ball-androide-17.jpg?width=300"),
//        Place(id: "Madrid", latitud: 40.4167047, longitud: -3.7035825, image: "https://cdn.alfabetajuega.com/alfabetajuega/2020/07/Trunks.jpg?width=300"),
//        Place(id: "Salamanca", latitud: 40.9651572, longitud: -5.6640182, image: "https://wallpaperaccess.com/full/1130512.jpg"),
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
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(place.latitud) ?? 0.0, longitude: Double(place.longitud) ?? 0.0)
        annotation.title = place.id
        annotation.subtitle = "You are seeing \(place.id)"
        
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
