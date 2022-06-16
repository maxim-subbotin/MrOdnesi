//
//  StoreViewModel.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit
import Combine

enum StoreViewModelAction {
    case dataLoaded
}

protocol StoreViewModel {
    var store: Store { get }
    init(store: Store, provider: StoresProvider)
    var subject: PassthroughSubject<StoreViewModelAction, Never> { get }
    func loadData() 
    func downloadImage(callback: @escaping (Result<UIImage, Error>) -> ()) -> UUID?
    func openHoursText() -> NSAttributedString
    func deliveryTimeText() -> NSAttributedString
    func ratingText() -> NSAttributedString
    func distanceText() -> NSAttributedString
    func discountText() -> NSAttributedString
}

class MyStoreViewModel: ObservableObject, StoreViewModel {
    private(set) var store: Store
    private var imageProvider = ImageProvider()
    var provider: StoresProvider
    
    var subject = PassthroughSubject<StoreViewModelAction, Never>()
    
    required init(store: Store, provider: StoresProvider) {
        self.store = store
        self.provider = provider
    }
    
    func loadData() {
        provider.fetchStoreInfo(storeId: store.id, callback: { res in
            switch res {
            case .success(let store):
                self.store = store
                self.subject.send(.dataLoaded)
            case .failure(let error):
                // TODO: represent error info in UI
                print("\(error)")
            }
        })
    }
    
    func downloadImage(callback: @escaping (Result<UIImage, Error>) -> ()) -> UUID? {
        if let path = store.imageUrl, let url = URL(string: path) {
            return imageProvider.fetchImage(url: url, callback: callback)
        }
        return nil
    }
    
    func openHoursText() -> NSAttributedString {
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "Open  ", attributes: [.font: UIFont.customMedium(ofSize: 14), .foregroundColor: UIColor.gray]))
        let hours = store.workingHours.hours(forDay: Date().weekDay)
        var msg = "Closed"
        if let start = hours?.first?.start, let end = hours?.last?.end {
            msg = "\(start) - \(end)"
        }
        text.append(NSAttributedString(string: msg, attributes: [.font: UIFont.customBold(ofSize: 14), .foregroundColor: UIColor.black]))
        return text
    }
    
    func deliveryTimeText() -> NSAttributedString {
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "Delivery time  ", attributes: [.font: UIFont.customMedium(ofSize: 14), .foregroundColor: UIColor.gray]))
        text.append(NSAttributedString(string: "\(store.deliveryTime ?? "--") min", attributes: [.font: UIFont.customBold(ofSize: 14), .foregroundColor: UIColor.black]))
        return text
    }
    
    func ratingText() -> NSAttributedString {
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "Rating  ", attributes: [.font: UIFont.customMedium(ofSize: 14), .foregroundColor: UIColor.gray]))
        text.append(NSAttributedString(string: "\(store.rating)  ", attributes: [.font: UIFont.customBold(ofSize: 14), .foregroundColor: UIColor.black]))
        text.append(NSAttributedString(string: "(\(store.ratingCount))", attributes: [.font: UIFont.customMedium(ofSize: 14), .foregroundColor: UIColor.gray]))
        return text
    }
    
    func distanceText() -> NSAttributedString {
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "Distance  ", attributes: [.font: UIFont.customMedium(ofSize: 14), .foregroundColor: UIColor.gray]))
        let msg = store.distance != nil ? "\(store.distance!) m" : "-"
        text.append(NSAttributedString(string: msg, attributes: [.font: UIFont.customBold(ofSize: 14), .foregroundColor: UIColor.black]))
        return text
    }
    
    func discountText() -> NSAttributedString {
        let text = NSMutableAttributedString()
        text.append(NSAttributedString(string: "Discount  ", attributes: [.font: UIFont.customMedium(ofSize: 14), .foregroundColor: UIColor.gray]))
        let msg = !(store.discountMessage ?? "").isEmpty ? (store.discountMessage ?? "") : "No discount"
        text.append(NSAttributedString(string: msg, attributes: [.font: UIFont.customBold(ofSize: 14), .foregroundColor: UIColor.black]))
        return text
    }
}
