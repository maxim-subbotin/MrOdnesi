//
//  LocationProvider.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 16.06.2022.
//

import Foundation
import CoreLocation
import Combine

struct Location {
    var lat: Double
    var lng: Double
    var address: String
}
enum LocationAction {
    case locationUpdated(_ loc: Location)
}

protocol LocationProvider: AnyObject {
    var subject: PassthroughSubject<LocationAction, Never> { get }
    func checkAuth()
}

class GPSLocationProvider: NSObject, LocationProvider, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus = CLAuthorizationStatus.notDetermined
    @Published var location: CLLocation?
    
    private let locationManager = CLLocationManager()
    
    var subject = PassthroughSubject<LocationAction, Never>()
    
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
    
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            getLocation()
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    deinit {
        subject.send(completion: .finished)
    }
}

class TestLocationProvider: NSObject, LocationProvider {
    var subject = PassthroughSubject<LocationAction, Never>()
    
    func checkAuth() {
        let lat = 44.8088835 + Double(Int.random(in: -200..<200)) / Double(10000)
        let lng = 20.4634834 + Double(Int.random(in: -200..<200)) / Double(10000)
        let loc = CLLocation(latitude: lat, longitude: lng)
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { placemarks, error in
            if let placemark = placemarks?.first {
                let address = placemark.address
                let point = Location(lat: loc.coordinate.latitude, lng: loc.coordinate.longitude, address: address)
                self.subject.send(.locationUpdated(point))
            }
        })
    }
}
