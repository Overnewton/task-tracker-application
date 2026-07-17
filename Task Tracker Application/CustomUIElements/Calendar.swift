//
//  Calendar.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 14/7/2026.
//

import UIKit

///UICalendar Class
final class UICalendar: UIControl, UICollectionViewDataSource, UICollectionViewDelegate {
    //internal month value
    //sets the current month as the default display
    //0 corresponds with Jan 1967
    var displayedMonthIndex: UInt = ProgramDate.today.standardDate().month + 12*ProgramDate.today.standardDate().year {
        //reloads the view when the value is updated
        didSet { calendarCellCollectionView.reloadData() }
    }
    
    ///Set of selected dates
    var selectedDates: Set<ProgramDate> = [] {
        //reloads the view when the value is updated
        didSet { calendarCellCollectionView.reloadData() }
    }
    
    var textColor: UIColor = .label {
        didSet { calendarCellCollectionView.reloadData() }
    }
    
    var secondaryTextColor: UIColor = .secondaryLabel {
        didSet { calendarCellCollectionView.reloadData() }
    }
    
    var highlightColor: UIColor = .systemYellow.withAlphaComponent(0.3) {
        didSet { calendarCellCollectionView.reloadData() }
    }
    
    //MARK: Interaction and Rendering
    ///dates to display in calendar
    private var calendarDates: [ProgramDate] {
        generateDates(month: displayedMonthIndex)
    }
    ///which date was last clicked, use in UIActions
    private(set) var tappedDate: ProgramDate = ProgramDate.today
    
    ///update tapped date and send action when date is clicked
    private func didTap(date: ProgramDate) {
        tappedDate = date
        sendActions(for: .primaryActionTriggered)
    }
    
    //define subview for calendar cells
    private let calendarCellCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICalendar.makeLayout()
    )
    
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
        addSubview(calendarCellCollectionView)
        calendarCellCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calendarCellCollectionView.backgroundColor = backgroundColor
        
        //positions where everything is
        NSLayoutConstraint.activate([
            calendarCellCollectionView.topAnchor.constraint(equalTo: topAnchor),
            calendarCellCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendarCellCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendarCellCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        calendarCellCollectionView.register(UICalendarCell.self, forCellWithReuseIdentifier: UICalendarCell.reuseID)
        
        //setup dataSource and delegate for collectionView requirements
        calendarCellCollectionView.dataSource = self
        calendarCellCollectionView.delegate = self
    }
    
    //MARK: CollectionView
    //gives the number of elements in the calendar, should always be 6*7=42
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calendarDates.count
    }
    
    //detects clicks on the icons
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = calendarDates[indexPath.item]
        didTap(date: date)
    }
    
    //sets up rendering of each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //defines cell object
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UICalendarCell.reuseID,
            for: indexPath
        ) as! UICalendarCell
        
        //initialises cell object properties
        cell.date = calendarDates[indexPath.item]
        cell.month = displayedMonthIndex
        cell.marked = selectedDates.contains(cell.date)
        cell.labelColor = textColor
        cell.secondaryLabelColor = secondaryTextColor
        cell.highlightColor = highlightColor
        cell.configure()
        return cell
    }
    
    //defines layout of how everything is positioned
    static func makeLayout() -> UICollectionViewLayout {
        
        //define size of cells
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 7.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        //define height of rows
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 6.0))
        
        //define layout of cells
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: Array(repeating: item, count: 7))
        let section = NSCollectionLayoutSection(group: group)
        
        //return layout of cells
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //gets collection of dates to be displayed
    private func generateDates(month: UInt) -> [ProgramDate] {
        //gets first day of the month
        let firstDate: ProgramDate = ProgramDate(month: month)
        //subtracts the day of the week of the first day of the month from the first day of the month to get the first sunday before or including the start of the month
        let calendarStart: UInt = firstDate.daysSinceFirst - (firstDate.daysSinceFirst % 7)
        
        //gets the first 42 days after and including the first day in the calendar
        return (0..<42).map {
            ProgramDate(daysSinceFirst: calendarStart + $0)
        }
    }
}

///Calendar Cell Class
final class UICalendarCell: UICollectionViewCell {
    static let reuseID = "UICalendarCell"
    
    //variables
    private let label = UILabel()
    var date: ProgramDate = ProgramDate.today
    var month: UInt = 0
    var marked: Bool = false
    
    //colours
    var labelColor: UIColor = .label
    var secondaryLabelColor: UIColor = .secondaryLabel
    var highlightColor: UIColor = .systemYellow.withAlphaComponent(0.3)
    
    //init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.frame = contentView.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //configure label from provided inputs
    func configure()
    {
        label.text = "\(date.standardDate().day + 1)"
        
        label.textColor = date.isInMonth(month) ? labelColor : secondaryLabelColor
        
        if marked {
            contentView.backgroundColor = highlightColor
        } else {
            contentView.backgroundColor = .clear
        }
    }
}
