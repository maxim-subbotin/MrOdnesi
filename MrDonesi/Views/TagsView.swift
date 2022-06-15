//
//  TagLabelView.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 15.06.2022.
//

import Foundation
import UIKit

class TagsView: UIView {
    var tags = [String]() {
        didSet {
            apply(tags: tags)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(tags: [String]) {
        self.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let gap: CGFloat = 10
        let offset: CGFloat = 10
        
        let font = UIFont.systemFont(ofSize: 14)
        
        let max = self.frame.size.width
        
        var sum: CGFloat = 0
        var items = [(frame: CGRect, title: String)]()
        for tag in tags {
            let w = tag.width(withConstrainedHeight: 100, font: font)
            let h = tag.height(withConstrainedWidth: 10000, font: font)
            let dx = w + 2 * offset + gap
            if sum + dx < max {
                let rect = CGRect(x: sum, y: 0, width: w + 2 * offset, height: h + 2 * offset)
                items.append((frame: rect, title: tag))
                sum += dx
            }
        }
        sum -= gap
        let startOffset = (max - sum) / 2
        var x = startOffset
        for i in 0..<items.count {
            items[i].frame.origin.x = x
            x += (items[i].frame.width + gap)
        }
        for item in items {
            let label = UILabel(frame: item.frame)
            label.text = item.title
            label.textColor = UIColor.white
            label.font = font
            label.backgroundColor = UIColor(hex6: 0x000000, alpha: 0.3)
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            self.addSubview(label)
        }
    }
}
