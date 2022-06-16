//
//  MapStoreView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 16.06.2022.
//

import Foundation
import MapKit
import UIKit

class MapStoreView: UIView, MKMapViewDelegate {
    private var mapView = MKMapView()
    private var point: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    private var polygons = [[CLLocationCoordinate2D]]()
    private var storeIdentifier = "store_ann"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        mapView.delegate = self
        mapView.register(StoreAnnotaionView.self, forAnnotationViewWithReuseIdentifier: storeIdentifier)
        self.addSubview(mapView)
    }
    
    private func setupConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let mvCx = mapView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let mvCy = mapView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let mvCw = mapView.widthAnchor.constraint(equalTo: self.widthAnchor)
        let mvCh = mapView.heightAnchor.constraint(equalTo: self.heightAnchor)
        NSLayoutConstraint.activate([mvCx, mvCy, mvCw, mvCh])
    }
    
    func set(latitude: Double, longitude: Double) {
        point = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: point, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = point
        mapView.addAnnotation(pin)
    }
    
    func set(polygons array:[[CGPoint]]) {
        polygons = array.map({ $0.map({ CLLocationCoordinate2D(latitude: $0.x, longitude: $0.y) }) })
        //mapView.removeOverlays(mapView.overlays)
        for p in polygons {
            let polygon = MKPolygon(coordinates: p, count: p.count)
            mapView.addOverlay(polygon)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return mapView.dequeueReusableAnnotationView(withIdentifier: storeIdentifier)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = .orange
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        } else if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            polygonView.fillColor = .orange
            polygonView.strokeColor = .red
            polygonView.alpha = 0.25
            return polygonView
        }
        return MKPolylineRenderer(overlay: overlay)
    }
}

fileprivate class StoreAnnotaionView: MKAnnotationView {
    let iconView = UIImageView()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        let image = UIImage(systemName: "target")
        iconView.image = image
        iconView.tintColor = UIColor(hex6: 0x06d6a0)
        self.addSubview(iconView)
    }
    
    func setupConstraints() {
        iconView.translatesAutoresizingMaskIntoConstraints = false
        let wC = iconView.widthAnchor.constraint(equalToConstant: 40)
        let hC = iconView.heightAnchor.constraint(equalToConstant: 40)
        let xC = iconView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let yC = iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([wC, hC, xC, yC])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
