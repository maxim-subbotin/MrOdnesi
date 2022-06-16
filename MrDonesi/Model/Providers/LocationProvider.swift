//
//  LocationProvider.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 16.06.2022.
//

import Foundation
import CoreLocation
import Combine

class LocationProvider: NSObject, ObservableObject, CLLocationManagerDelegate {
    struct Location {
        var lat: Double
        var lng: Double
        var address: String
    }
    enum Action {
        case locationUpdated(_ loc: Location)
    }
    
    @Published var authorizationStatus = CLAuthorizationStatus.notDetermined
    @Published var location: CLLocation?
    
    let locationManager = CLLocationManager()
    
    var subject = PassthroughSubject<Action, Never>()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func checkAuth() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func getLocation() {
        locationManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            getLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { placemarks, error in
                if let placemark = placemarks?.first {
                    let address = placemark.address
                    let point = Location(lat: loc.coordinate.latitude, lng: loc.coordinate.longitude, address: address)
                    self.subject.send(.locationUpdated(point))
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    deinit {
        subject.send(completion: .finished)
    }
}
