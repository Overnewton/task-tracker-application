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
    
    var textColor: UIColor = .label {
        didSet { reload() }
    }
    
    var secondaryTextColor: UIColor = .secondaryLabel {
        didSet { reload() }
    }
    
    var iconColor: UIColor = .white {
        didSet { reload() }
    }
    
    func reload() {
        let propertiesFiltered = properties.filter({ $0 != "" })
        //this check is important as otherwise there WILL be an infinite loop
        if properties != propertiesFiltered {
            properties = propertiesFiltered
        }
        propertyCellCollectionView.reloadData()
    }
    
    private let propertyCellCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIProperties.makeLayout())
    
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //sets up UI
    private func setup() {
        addSubview(propertyCellCollectionView)
        propertyCellCollectionView.translatesAutoresizingMaskIntoConstraints = false
        propertyCellCollectionView.backgroundColor = backgroundColor
        
        //positions where everything is
        NSLayoutConstraint.activate([
            propertyCellCollectionView.topAnchor.constraint(equalTo: topAnchor),
            propertyCellCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            propertyCellCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            propertyCellCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        propertyCellCollectionView.register(UIPropertiesCell.self, forCellWithReuseIdentifier: UIPropertiesCell.reuseID)
        propertyCellCollectionView.register(UIPropertiesAddCell.self, forCellWithReuseIdentifier: UIPropertiesAddCell.reuseID)
        
        //setup dataSource and delegate for collectionView requirements
        propertyCellCollectionView.dataSource = self
        propertyCellCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        properties.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == properties.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIPropertiesAddCell.reuseID, for: indexPath) as! UIPropertiesAddCell
            let editAction = UIAction() { _ in
                self.properties.append(cell.textField.text ?? "")
            }
            cell.iconColor = iconColor
            cell.textColor = textColor
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIPropertiesCell.reuseID, for: indexPath) as! UIPropertiesCell
            let deleteAction = UIAction() { _ in
                self.properties.remove(at: indexPath.item)
            }
            cell.deleteAction = deleteAction
            let editAction = UIAction() { _ in
                self.properties[indexPath.item] = cell.textField.text ?? ""
            }
            cell.editAction = editAction
            cell.property = properties[indexPath.item]
            cell.iconColor = iconColor
            cell.textColor = textColor
            cell.configure()
            return cell
        }
    }
    
    static func makeLayout(horizontalSpacing: CGFloat = 0, verticalSpacing: CGFloat = 0) -> UICollectionViewLayout {
        let flowLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .center)
        flowLayout.minimumInteritemSpacing = horizontalSpacing
        flowLayout.minimumLineSpacing = verticalSpacing
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return flowLayout
    }
}

final class UIPropertiesCell: UICollectionViewCell {
    static let reuseID = "UIPropertiesCell"
    
    var property: String = ""
    var deleteAction = UIAction { _ in }
    var editAction = UIAction { _ in }
    var textColor: UIColor = .label
    var iconColor: UIColor = .white
    
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textField)
        textField.frame = contentView.bounds
        textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure() {
        textField.text = property
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: textField.frame.height, height: textField.frame.height)
        button.tintColor = iconColor
        button.addAction(deleteAction, for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .always
        textField.textColor = textColor
        textField.addAction(editAction, for: .editingDidEnd)
    }
}

final class UIPropertiesAddCell: UICollectionViewCell {
    static let reuseID = "UIPropertiesAddCell"
    
    var editAction = UIAction { _ in }
    var textColor: UIColor = .label
    var secondaryTextColor: UIColor = .secondaryLabel
    var iconColor: UIColor = .white
    
    let textField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textField)
        textField.frame = contentView.bounds
        textField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure() {
        textField.text = ""
        var label = UILabel()
        label.textColor = secondaryTextColor
        textField.leftView = label
        textField.leftViewMode = .unlessEditing
        textField.textColor = textColor
        textField.addAction(editAction, for: .editingDidEnd)
    }
}
