//
//  AnnotationView.swift
//  ios-practica
//
//  Created by Eric Olsson on 2/11/23.
//

import MapKit

class AnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let value = newValue as? Annotation else { return }
            detailCalloutAccessoryView = Callout(annotation: value)
            let pinImage = UIImage(named: "marker-blue")
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            self.image = resizedImage
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
}
