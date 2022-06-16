//
//  StoreGroupScrollView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 14.06.2022.
//

import Foundation
import UIKit

class StoreGroupScrollView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    typealias TapCallback = (Int) -> ()
    
    enum CellType: String {
        case store
    }
    
    private var viewModel: StoresViewModel
    var name: String? {
        didSet {
            self.reloadData()
        }
    }
    var tapCallback: TapCallback?

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
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = MyStoresViewModel(provider: WebStoresProvider())
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
}
