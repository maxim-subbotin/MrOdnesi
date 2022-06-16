//
//  StoreViewController.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit
import Combine

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let imageView = UIImageView()
    private let toneView = GradientView()
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let scrollView = UIScrollView()
    private let openLabel = ImageLabelView()
    private let deliveryTimeLabel = ImageLabelView()
    private let ratingLabel = ImageLabelView()
    private let distanceLabel = ImageLabelView()
    private let discountLabel = ImageLabelView()
    private var mapView = MapStoreView()
    private var menuView = UITableView()
    
    private var cancellable = Set<AnyCancellable>()
    
    private var menuItemCell = "menu_item_cell"
    
    var viewModel: StoreViewModel? {
        didSet {
            prepare()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.alpha = 0
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        
        imageView.addSubview(toneView)
        
        nameLabel.textColor = .white
        nameLabel.font = .customBold(ofSize: 22)
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        nameLabel.layer.shadowRadius = 3.0
        nameLabel.layer.shadowOpacity = 1.0
        imageView.addSubview(nameLabel)
        
        addressLabel.textColor = .white
        addressLabel.font = .customMedium(ofSize: 16)
        addressLabel.layer.shadowColor = UIColor.black.cgColor
        addressLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        addressLabel.layer.shadowRadius = 3.0
        addressLabel.layer.shadowOpacity = 1.0
        imageView.addSubview(addressLabel)
        
        self.view.addSubview(scrollView)
        
        openLabel.image = UIImage(systemName: "house.fill")
        openLabel.iconColor = .gray
        scrollView.addSubview(openLabel)
        
        deliveryTimeLabel.image = UIImage(systemName: "car.fill")
        deliveryTimeLabel.iconColor = .gray
        scrollView.addSubview(deliveryTimeLabel)
        
        ratingLabel.image = UIImage(systemName: "star.fill")
        ratingLabel.iconColor = UIColor(hex6: 0xffb703)
        scrollView.addSubview(ratingLabel)
        
        distanceLabel.image = UIImage(systemName: "pin.fill")
        distanceLabel.iconColor = .gray
        scrollView.addSubview(distanceLabel)
        
        discountLabel.image = UIImage(systemName: "tag.fill")
        discountLabel.iconColor = .gray
        scrollView.addSubview(discountLabel)
        
        scrollView.addSubview(mapView)
        
        menuView.delegate = self
        menuView.dataSource = self
        menuView.backgroundColor = .white
        menuView.register(MenuItemCellView.self, forCellReuseIdentifier: menuItemCell)
        menuView.isScrollEnabled = false
        scrollView.addSubview(menuView)

        let backImg = UIImage(systemName: "chevron.left.circle.fill")
        self.navigationController?.navigationBar.backIndicatorImage = backImg
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImg
        self.navigationController?.navigationBar.backItem?.backButtonTitle = " "
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        refreshScrollSize()
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let ivCt = imageView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let ivCh = imageView.heightAnchor.constraint(equalToConstant: 250)
        let ivCw = imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let ivCx = imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        NSLayoutConstraint.activate([ivCt, ivCh, ivCw, ivCx])
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        let alCb = addressLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10)
        let alCx = addressLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        let alCw = addressLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: -40)
        let alCh = addressLabel.heightAnchor.constraint(equalToConstant: 25)
        NSLayoutConstraint.activate([alCb, alCx, alCw, alCh])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nlCb = nameLabel.bottomAnchor.constraint(equalTo: addressLabel.topAnchor)
        let nlCx = nameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        let nlCw = nameLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: -40)
        let nlCh = nameLabel.heightAnchor.constraint(equalToConstant: 40)
        NSLayoutConstraint.activate([nlCb, nlCx, nlCw, nlCh])
        
        toneView.translatesAutoresizingMaskIntoConstraints = false
        let tvCx = toneView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        let tvCt = toneView.topAnchor.constraint(equalTo: imageView.topAnchor)
        let tvCw = toneView.widthAnchor.constraint(equalTo: imageView.widthAnchor)
        let tvCb = toneView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        NSLayoutConstraint.activate([tvCx, tvCt, tvCw, tvCb])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let svCt = scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor)
        let svCb = scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        let svCx = scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let svCw = scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        NSLayoutConstraint.activate([svCt, svCb, svCx, svCw])
        
        let views = [openLabel, deliveryTimeLabel, ratingLabel, distanceLabel, discountLabel]
        var prevView: UIView? = nil
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            let vCt = prevView == nil ? view.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10) : view.topAnchor.constraint(equalTo: prevView!.bottomAnchor)
            let vCw = view.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -40)
            let vCh = view.heightAnchor.constraint(equalToConstant: 40)
            let vCl = view.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20)
            NSLayoutConstraint.activate([vCt, vCw, vCh, vCl])
            prevView = view
        }
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let mvCt = mapView.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 10)
        let mvCw = mapView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        let mvCh = mapView.heightAnchor.constraint(equalToConstant: 160)
        let mvCl = mapView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor)
        NSLayoutConstraint.activate([mvCt, mvCw, mvCh, mvCl])
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        let menuCt = menuView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0)
        let menuCw = menuView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        let menuCx = menuView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        let menuCh = menuView.heightAnchor.constraint(equalToConstant: 0)
        menuCh.identifier = "menu_list_height"
        NSLayoutConstraint.activate([menuCt, menuCw, menuCx, menuCh])
    }
    
    func prepare() {
        viewModel?.loadData()
        viewModel?.subject.sink(receiveValue: { action in
            self.on(action: action)
        }).store(in: &cancellable)
        _ = viewModel?.downloadImage(callback: { res in
            switch res {
            case .success(let img):
                DispatchQueue.main.async {
                    self.imageView.image = img
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                        self.imageView.alpha = 1.0
                    }
                }
            case .failure(let error):
                print("\(error)")
            }
        })
        nameLabel.text = viewModel?.store.name
        if let city = viewModel?.store.city, let address = viewModel?.store.location {
            addressLabel.text = "\(city), \(address)"
        }
        openLabel.attributedTitle = viewModel?.openHoursText()
        deliveryTimeLabel.attributedTitle = viewModel?.deliveryTimeText()
        ratingLabel.attributedTitle = viewModel?.ratingText()
        distanceLabel.attributedTitle = viewModel?.distanceText()
        discountLabel.attributedTitle = viewModel?.discountText()
        if let lat = viewModel?.store.lat, let lng = viewModel?.store.lng {
            mapView.set(latitude: lat, longitude: lng)
        }
    }
    
    func on(action: StoreViewModelAction) {
        switch action {
        case .dataLoaded:
            if let points = viewModel?.store.deliveryZone?.map({ $0.polygon.points }) {
                mapView.set(polygons: points)
                menuView.reloadData()
                refreshScrollSize()
            }
        }
    }
    
    func refreshScrollSize() {
        var maxY: CGFloat = 0
        for v in scrollView.subviews {
            if !(v is UITableView) {
                maxY = max(maxY, v.frame.maxY)
            }
        }
        var h: CGFloat = 0
        if let groupCount = viewModel?.store.groups?.count {
            for i in 0..<groupCount {
                h += (50 + 20)
                if let count = viewModel?.itemGroupCount(index: i) {
                    h += (120.5 * CGFloat(count))
                }
            }
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: maxY + h)
        
        if let hC = menuView.constraints.first(where: { $0.identifier == "menu_list_height" }) {
            hC.constant = h
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.store.groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.itemGroupCount(index: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = tableView.dequeueReusableCell(withIdentifier: menuItemCell, for: indexPath)
        if let itemView = view as? MenuItemCellView {
            itemView.clear()
            itemView.name = viewModel?.itemName(groupNum: indexPath.section, itemNum: indexPath.item)
            itemView.itemDescription = viewModel?.itemDescription(groupNum: indexPath.section, itemNum: indexPath.item)
            itemView.itemPrice = viewModel?.itemPrice(groupNum: indexPath.section, itemNum: indexPath.item)
            itemView.groupNumber = indexPath.section
            itemView.itemNumber = indexPath.item
            itemView.viewModel = viewModel
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.itemGroupName(index: section) ?? ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = MenuGroupHeaderView()
        view.title = viewModel?.itemGroupName(index: section) ?? ""
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

class GradientView: UIView {
    private let gradient : CAGradientLayer = CAGradientLayer()

    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }

    override public func draw(_ rect: CGRect) {
        gradient.frame = self.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor(hex6: 0x000000, alpha: 0.4).cgColor, UIColor(hex6: 0x000000, alpha: 0.6).cgColor, UIColor(hex6: 0x000000, alpha: 0.6).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }
}
