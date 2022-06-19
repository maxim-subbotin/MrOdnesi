//
//  StoreGroupScrollView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import UIKit
import Combine

class StoreGroupScrollView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    typealias TapCallback = (Int) -> ()
    
    enum CellType: String {
        case store
    }
    
    private var viewModel: StoresViewModel
    var name: String? {
        didSet {
            /*self.performBatchUpdates({
                let index = viewModel.group(forName: name ?? "")?.stores.count ?? 0
                var paths = [IndexPath]()
                for i in 0..<index {
                    paths.append(IndexPath(item: i, section: 0))
                }
                self.reloadItems(at: paths)
            }, completion: nil)*/
            //self.reloadData()
        }
    }
    var tapCallback: TapCallback?
    
    private var cancellable = Set<AnyCancellable>()

    init(viewModel: StoresViewModel, name: String? = nil) {
        self.viewModel = viewModel
        self.name = name
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 280, height: 140)
        layout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(StoreGroupViewCell.self, forCellWithReuseIdentifier: CellType.store.rawValue)
        self.backgroundColor = UIColor.white
        
        self.delegate = self
        self.dataSource = self
        
        viewModel.subject.sink(receiveValue: on(action:)).store(in: &cancellable)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = MrDiStoresViewModel(provider: WebStoresProvider())
        self.name = ""
        super.init(coder: coder)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.group(forName: name ?? "")?.stores.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellView = self.dequeueReusableCell(withReuseIdentifier: CellType.store.rawValue, for: indexPath)
        cellView.backgroundColor = .lightGray
        cellView.backgroundView?.backgroundColor = .lightGray
        if let storeCellView = cellView as? StoreGroupViewCell {
            storeCellView.clear()
            storeCellView.viewModel = viewModel
            storeCellView.index = indexPath.item
            storeCellView.groupName = name
            storeCellView.prepare()
            return storeCellView
        }
        return cellView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let name = name {
            viewModel.selectStore(index: indexPath.item, groupName: name)
        }
    }
    
    func on(action: StoresViewModelAction) {
        if case let StoresViewModelAction.updateCollection(name, delete, insert, moves) = action {
            if self.name == name {
                self.performBatchUpdates({
                    if delete.count > 0 {
                        self.deleteItems(at: delete.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if insert.count > 0 {
                        self.insertItems(at: insert.map({ IndexPath(item: $0, section: 0) }))
                    }
                }, completion: {_ in 
                    self.performBatchUpdates({
                        moves.forEach({
                            self.moveItem(at: IndexPath(item: $0.from, section: 0), to: IndexPath(item: $0.to, section: 0))
                        })
                    })
                })
            }
        }
        if case let StoresViewModelAction.completeReloading = action {
            self.reloadData()
        }
    }
}
