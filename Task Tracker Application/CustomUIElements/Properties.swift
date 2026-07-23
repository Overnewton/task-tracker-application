//
//  Properties.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 20/7/2026.
//

import UIKit

final class UIProperties: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var properties: [String] = [] {
        didSet { reload() }
    }
    
    func reload() {
        let propertiesFiltered = properties.filter({ $0 == "" })
        //this check is important as otherwise there WILL be an infinite loop
        if properties != propertiesFiltered {
            properties = propertiesFiltered
        }
    }
    
    private let propertyCellCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIProperties.makeLayout())
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        properties.count + 1
    }
    
    //TODO: implement remaining code
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == properties.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIPropertiesAddCell.reuseID, for: indexPath) as! UIPropertiesAddCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIPropertiesCell.reuseID, for: indexPath) as! UIPropertiesCell
            let action = UIAction() { _ in
                self.properties.remove(at: indexPath.item)
            }
            cell.action = action
            cell.property = properties[indexPath.item]
            return cell
        }
    }
    
    static func makeLayout(horizontalSpacing: CGFloat = 0, verticalSpacing: CGFloat = 0) -> UICollectionViewLayout {
        let flowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .center)
        flowLayout.minimumInteritemSpacing = horizontalSpacing
        flowLayout.minimumLineSpacing = verticalSpacing
        return flowLayout
    }
}

final class UIPropertiesCell: UICollectionViewCell {
    static let reuseID = "UIPropertiesCell"
    
    var property: String = ""
    var action = UIAction { _ in }
    let textField = UITextField()
    
    func configure() {
        textField.text = property
        let button = UIButton(type: .system)
        button.setTitle("X", for: .normal)
        button.addAction(action, for: .touchUpInside)
        textField.rightView = button
    }
}

final class UIPropertiesAddCell: UICollectionViewCell {
    static let reuseID = "UIPropertiesAddCell"
    
}
