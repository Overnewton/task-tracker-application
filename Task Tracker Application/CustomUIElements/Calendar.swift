//
//  Calendar.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 14/7/2026.
//

import UIKit

final class UICalendar: UIControl {
    var displayedMonth: UInt = 0 {
        didSet { reload() }
    }
    
    var month: UInt {
        //January corresponds with 0
        displayedMonth % 12
    }
    
    var year: UInt {
        //The year 1967 corresponds with 0
        displayedMonth / 12
    }
    
    var selectedDates: Set<ProgramDate> = [] {
        didSet { updateSelectionUI() }
    }
    
    var highlightedDates: Set<ProgramDate> = [] {
        didSet { reload() }
    }
    
    var allowsMultipleSelection: Bool = true
    var allowsToggleSelection: Bool = true
    
    //MARK: Interaction and Rendering
    
    private(set) var tappedDate: ProgramDate?
    
    private func didTap(date: ProgramDate) {
        tappedDate = date
        sendActions(for: .valueChanged)
    }
    
    //MARK: Internals
    private var monthDates: [ProgramDate] = []
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICalendar.makeLayout()
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func generateMonthDates(month: UInt) -> [ProgramDate] {
        var dates: [ProgramDate] = []
        let first = ProgramDate(month: month)
        let firstWeekday = ProgramDate.daysOfTheWeek(first.daysSinceFirst)
        
        
        let weekdayIndex = Int(first.daysSinceFirst % 7)
        
        if weekdayIndex > 0 {
            for i in 1...weekdayIndex {
                let d = ProgramDate(daysSinceFirst: first.daysSinceFirst - UInt(weekdayIndex - i + 1))
                dates.append(d)
            }
        }
        
        let nextMonth = ProgramDate(day: 1, month: month + 1, year: year)
        let monthLength = nextMonth.daysSinceFirst - first.daysSinceFirst
        
        for day in 0..<monthLength {
            dates.append(ProgramDate(daysSinceFirst: first.daysSinceFirst + UInt(day)))
        }
        
        while dates.count < 42 {
            let last = dates.last!
            dates.append(last.nextDay())
        }
        
        return dates
    }
}

final class UICalendarCell: UICollectionViewCell {
    static let reuseID = "UICalendarCell"

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.frame = contentView.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(date: ProgramDate,
                   isInMonth: Bool,
                   isSelected: Bool,
                   isHighlighted: Bool)
    {
        let std = date.standardDate()
        label.text = "\(std.day)"

        label.textColor = isInMonth ? .label : .secondaryLabel

        if isSelected {
            contentView.backgroundColor = .systemBlue
            label.textColor = .white
        } else if isHighlighted {
            contentView.backgroundColor = .systemYellow.withAlphaComponent(0.3)
        } else {
            contentView.backgroundColor = .clear
        }
    }
}
