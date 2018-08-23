//
//  ViewController.swift
//  MultiTags
//
//  Created by Vishal Madheshia on 23/08/18.
//  Copyright © 2018 Vishal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = ["Hi", "Hello", "Welcome", "Hola", "Hello World", "Welcome to you", "Bonjour", "Bonnuit", "Bon appetite", "Hi", "Hello", "Welcome"]
    private var tagHeight: CGFloat = 36
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = NBCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagCell
        
        cell.bind(items[indexPath.item], backgroundColor: .gray, textColor: .white)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.items[indexPath.row]
        let width = item.width(usingFont: TagCell.font) + 24
        return CGSize(width: width, height: self.tagHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.2, delay: (0.02 * Double(indexPath.row)), options: .curveLinear, animations: {
            cell.alpha = 1.0
        }, completion: nil)
    }
    
}

class TagCell: UICollectionViewCell {
    
    static var font: UIFont = UIFont.boldSystemFont(ofSize: 16)
    
    @IBOutlet weak var titleL: UILabel!
    
    func bind(_ string: String, backgroundColor: UIColor, textColor: UIColor) {
        self.titleL.text = string
        self.accessibilityIdentifier = string
        self.titleL.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleL.font = TagCell.font
        self.titleL.textAlignment = .center
        self.layer.cornerRadius = 6.0
        self.layoutIfNeeded()
    }
}

extension String {
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

class NBCollectionViewFlowLayout: UICollectionViewFlowLayout {
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if var answer = super.layoutAttributesForElements(in: rect) {
            let count = answer.count
            for i in 1..<count {
                let currentLayoutAttributes = answer[i]
                let prevLayoutAttributes = answer[i-1]
                let maxSpacing = 4
                let origin = prevLayoutAttributes.frame.maxX
                if (origin + 2 * CGFloat(maxSpacing) + currentLayoutAttributes.frame.size.width) < self.collectionViewContentSize.width {
                    var frame = currentLayoutAttributes.frame
                    frame.origin.x = origin + CGFloat(maxSpacing)
                    currentLayoutAttributes.frame = frame
                }
                answer[i] = currentLayoutAttributes
            }
            return answer
        } else {
            return []
        }
    }
}
