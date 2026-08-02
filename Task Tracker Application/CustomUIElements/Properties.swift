//
//  Properties.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 20/7/2026.
//

import UIKit

final class UIProperties: UIControl, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //list of properties, hence an array as the ordering is the displayed ordering
    var properties: [String] = [] {
        didSet { reload() }
    }
    
    //color
    var textColor: UIColor = .label {
        didSet { reload() }
    }
    
    //color
    var secondaryTextColor: UIColor = .secondaryLabel {
        didSet { reload() }
    }
    
    //color
    var iconColor: UIColor = .white {
        didSet { reload() }
    }
    
    //color
    var cellBorderColor: UIColor = .systemBackground {
        didSet { reload() }
    }
    
    //color
    var cellBackgroundColor: UIColor = .systemBackground {
        didSet { reload() }
    }
    
    //color
    var cellCornerRadius: CGFloat = 0 {
        didSet { reload() }
    }
    
    //color
    var cellBorderWidth: CGFloat = 0 {
        didSet { reload() }
    }
    
    //reloads the display after removing all blank entries
    func reload() {
        let propertiesFiltered = properties.filter({ $0 != "" })
        //this check is important as otherwise there WILL be an infinite loop
        if properties != propertiesFiltered {
            properties = propertiesFiltered
        }
        propertyCellCollectionView.reloadData()
    }
    
    //internal collection view
    private var propertyCellCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UIProperties.makeLayout(horizontalSpacing: 10, verticalSpacing: 10))
    
    
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
    
    //CollectionView functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        properties.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //initialises the cells
        if indexPath.item == properties.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIPropertiesAddCell.reuseID, for: indexPath) as! UIPropertiesAddCell
            //action to run on finishing editing
            let editAction = UIAction() { [weak self] _ in
                self?.properties.append(cell.inputTextField.text ?? "")
                self?.sendActions(for: .primaryActionTriggered)
            }
            //changes size of cells to match size of contents
            let editingAction = UIAction() { [weak self] _ in
                cell.inputTextField.invalidateIntrinsicContentSize()
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                self?.propertyCellCollectionView.collectionViewLayout.invalidateLayout()
            }
            //displays the placeholder text when not editing
            let leftViewControlAction = UIAction() { [weak self] _ in
                cell.inputTextField.leftViewMode = .never
                cell.inputTextField.invalidateIntrinsicContentSize()
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                self?.propertyCellCollectionView.collectionViewLayout.invalidateLayout()
            }
            //set up cell
            cell.editAction = editAction
            cell.editingAction = editingAction
            cell.leftViewControlAction = leftViewControlAction
            cell.iconColor = iconColor
            cell.textColor = textColor
            cell.backgroundColor = cellBackgroundColor
            cell.layer.borderColor = cellBorderColor.cgColor
            cell.layer.cornerRadius = cellCornerRadius
            cell.layer.borderWidth = cellBorderWidth
            cell.secondaryTextColor = secondaryTextColor
            cell.configure()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UIPropertiesCell.reuseID, for: indexPath) as! UIPropertiesCell
            //action to delete the property
            let deleteAction = UIAction() { [weak self] _ in
                for propertyCell in self?.propertyCellCollectionView.visibleCells ?? [] {
                    if let c = propertyCell as? UIPropertiesCell {
                        c.inputTextField.removeTarget(nil, action: nil, for: .editingDidEnd)
                    }
                }
                self?.properties.remove(at: indexPath.item)
                self?.sendActions(for: .primaryActionTriggered)
            }
            cell.deleteAction = deleteAction
            //action to run on finishing editing
            let editAction = UIAction() { [weak self] _ in
                cell.inputTextField.invalidateIntrinsicContentSize()
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                self?.properties[indexPath.item] = cell.inputTextField.text ?? ""
                self?.sendActions(for: .primaryActionTriggered)
            }
            //changes size of cells to match size of contents
            let editingAction = UIAction() { [weak self] _ in
                cell.inputTextField.invalidateIntrinsicContentSize()
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
                self?.propertyCellCollectionView.collectionViewLayout.invalidateLayout()
            }
            //set up cell
            cell.editAction = editAction
            cell.editingAction = editingAction
            cell.property = properties[indexPath.item]
            cell.iconColor = iconColor
            cell.textColor = textColor
            cell.backgroundColor = cellBackgroundColor
            cell.layer.borderColor = cellBorderColor.cgColor
            cell.layer.cornerRadius = cellCornerRadius
            cell.layer.borderWidth = cellBorderWidth
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

final class UIPropertiesCell: UICollectionViewCell, UITextFieldDelegate {
    static let reuseID = "UIPropertiesCell"
    
    //basically just ui stuff
    var property: String = ""
    var deleteAction = UIAction { _ in }
    var editAction = UIAction { _ in }
    var editingAction = UIAction { _ in }
    var textColor: UIColor = .label
    var iconColor: UIColor = .white
    
    let inputTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(inputTextField)
        inputTextField.delegate = self
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            inputTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            inputTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            inputTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure() {
        inputTextField.text = property
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: inputTextField.frame.height, height: inputTextField.frame.height)
        button.tintColor = iconColor
        button.removeTarget(nil, action: nil, for: .touchUpInside)
        button.addAction(deleteAction, for: .touchUpInside)
        inputTextField.rightView = button
        inputTextField.rightViewMode = .always
        inputTextField.textColor = textColor
        inputTextField.removeTarget(nil, action: nil, for: .editingDidEnd)
        inputTextField.addAction(editAction, for: .editingDidEnd)
        inputTextField.removeTarget(nil, action: nil, for: .editingChanged)
        inputTextField.addAction(editingAction, for: .editingChanged)
        inputTextField.removeTarget(nil, action: nil, for: .editingDidEndOnExit)
        inputTextField.addAction(UIAction() { _ in }, for: .editingDidEndOnExit)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRanges range: [NSValue], replacementString string: String) -> Bool {
        if string == "," {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

final class UIPropertiesAddCell: UICollectionViewCell, UITextFieldDelegate {
    static let reuseID = "UIPropertiesAddCell"
    
    //basically just ui stuff
    var editAction = UIAction { _ in }
    var editingAction = UIAction { _ in }
    var leftViewControlAction = UIAction { _ in }
    var textColor: UIColor = .label
    var secondaryTextColor: UIColor = .secondaryLabel
    var iconColor: UIColor = .white
    
    let inputTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(inputTextField)
        inputTextField.delegate = self
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            inputTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            inputTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            inputTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure() {
        inputTextField.text = ""
        let label = UILabel()
        label.textColor = secondaryTextColor
        label.text = "add tags"
        inputTextField.leftView = label
        inputTextField.leftViewMode = .always
        inputTextField.textColor = textColor
        inputTextField.removeTarget(nil, action: nil, for: .editingDidEnd)
        inputTextField.addAction(editAction, for: .editingDidEnd)
        inputTextField.removeTarget(nil, action: nil, for: .editingChanged)
        inputTextField.addAction(editingAction, for: .editingChanged)
        inputTextField.removeTarget(nil, action: nil, for: .editingDidBegin)
        inputTextField.addAction(leftViewControlAction, for: .editingDidBegin)
        inputTextField.removeTarget(nil, action: nil, for: .editingDidEndOnExit)
        inputTextField.addAction(UIAction() { _ in }, for: .editingDidEndOnExit)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRanges range: [NSValue], replacementString string: String) -> Bool {
        if string == "," {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}
