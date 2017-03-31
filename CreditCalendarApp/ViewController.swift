//
//  ViewController.swift
//  CreditCalendarApp
//
//  Created by Ching-Lan Chen on 2017/3/30.
//  Copyright © 2017年 Credit Calendar. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    @IBOutlet var calendarView: JTAppleCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CellView")
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
        calendarView.allowsMultipleSelection = true
        calendarView.rangeSelectionWillBeUsed = true
        
        self.view.addSubview(calendarView)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        
        let myCustomCell = cell as! CellView
        myCustomCell.dayLabel.text = cellState.text
        
        if cellState.dateBelongsTo == .thisMonth{
            myCustomCell.dayLabel.textColor = UIColor(red: 236/255, green: 234/255, blue: 237/255, alpha: 1.0)
        }
        else{
            myCustomCell.dayLabel.textColor = UIColor(red: 87/255, green: 72/255, blue: 101/255, alpha: 1.0)
        }
        
        handleCellSelection(view: cell, cellState: cellState)
        
    }
    
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState)
    {
        guard let myCustomCell = view as? CellView else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius = 20
            myCustomCell.selectedView.isHidden = false
        }
            
        else {
            myCustomCell.selectedView.isHidden = true
        }
        print("Data:\(cellState.date)")
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
            
        let startDate = formatter.date(from: "2016 12 01")!  //可以制訂起始日期
        let endDate = Date()  //Date()物件應該是目前日期
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                calendar: Calendar.current,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .sunday)
        return parameters
    }
    //添加一個代理方法，用來監聽某個日期被選擇
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
    }
    // //這邊didDeselectDate打錯
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

