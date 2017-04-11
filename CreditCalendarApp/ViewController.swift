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

    @IBOutlet var calendarView: JTAppleCalendarView!  // 建立日曆視圖控件和類文件的屬性之間的連結  // 從Main.storyboard來的
    // Important: JTAppleCalendar is a UICollectionView subclass. Therefore, cells are being re-used when the calendar is scrolled.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        calendarView.dataSource = self  // 日曆視圖的數據源
        calendarView.delegate = self  // 日曆視圖的代理對象，兩者都是當前的視圖控制器對象
        calendarView.registerCellViewXib(file: "CellView")  // 要使用自定義的日曆視圖，需要註冊日曆中的日期數字單元格的故事板文件
        calendarView.cellInset = CGPoint(x: 0, y: 0)  // 設置日期數字單元格的間距
        
        calendarView.allowsMultipleSelection = true  // 設置在日曆中允許'選擇'多個日期
        calendarView.rangeSelectionWillBeUsed = true  // 允許進行日期區域的選擇
        
        self.view.addSubview(calendarView)  // 將日曆視圖添加到當前視圖控制器的根視圖中
    }
    
    // delegate protocol method to allow us to see the beautiful date cells we have designed earlier.
    // 添加一個代理方法，用來監聽日曆中的數據單元格即將顯示的事件
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        
        let myCustomCell = cell as! CellView  // 獲得即將顯示的單元格對象，並轉換成自定義的單元格類
        myCustomCell.dayLabel.text = cellState.text  // 然後設置單元格類中的標籤的文字內容
        
        if cellState.dateBelongsTo == .thisMonth{  // 當日曆顯示的日期為當月份時，設置數字標籤的字體顏色為淺灰色
            myCustomCell.dayLabel.textColor = UIColor(red: 236/255, green: 234/255, blue: 237/255, alpha: 1.0)
        }
        else{  // 當日曆顯示的日期不是當月份時，設置數字標籤的字體顏色為另外種顏色
            myCustomCell.dayLabel.textColor = UIColor(red: 87/255, green: 72/255, blue: 101/255, alpha: 1.0)
        }
        
        handleCellSelection(view: cell, cellState: cellState)  // 接著處理日期數字單元格被選擇的事件
        
    }
    
    // 添加一個方法，用來響應日期數字單元格被選擇的事件
    // 如果沒有這方法，選擇後滑動到下頁面，會是random的日期被選擇，因為JTAppleCalendar is a UICollectionView subclass，cell會被重複使用
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState)
    {
        // 首先獲得當前被選擇的日期數字單元格
        guard let myCustomCell = view as? CellView else {
            return
        }
        
        // 當單元格被選擇時，設置單元格的選擇標識視圖的圓角半徑為20，並設置視圖的顯示狀態為真
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius = 20
            myCustomCell.selectedView.isHidden = false
        }
        
        // 當單元格不處於選擇狀態時，隱藏該單元格的標識視圖
        else {
            myCustomCell.selectedView.isHidden = true
        }
        print("Data:\(cellState.date)")  // 同時在控制台輸出當前的日期
    }
    
    // The data-source protocol has only one function which needs to return a value of type ConfigurationParameters. This value requires 7 sub-values.
    // 添加一個代理方法，用來配置日曆的相關參數  // 可以另創一個.swift，用成extension
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()  // 初始化一個日期格式對象
        formatter.dateFormat = "yyyy MM dd"  // 設置日期的格式
        
        // 初始化兩個日期對象
        let startDate = formatter.date(from: "2016 12 01")!  //日曆的起始日期
        let endDate = Date()  //Date()物件應該是目前日期
        
        // 初始化一個配置參數對象
        let parameters = ConfigurationParameters(startDate: startDate,  // 日曆起始日期
                                                endDate: endDate,  // 結束日期
                                                numberOfRows: 6,  // 日曆行數
                                                calendar: Calendar.current,  // 日曆類別
                                                generateInDates: .forAllMonths,  // 過去日期
                                                generateOutDates: .tillEndOfGrid,  // 將來日期的展示方式
                                                firstDayOfWeek: .sunday)  // 每週的第一天
        return parameters  // 返回配置參數對象
    }
    
    // 添加一個代理方法，用來監聽某個日期被選擇時的事件
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
    }
    // 再添加個代理方法，用來監聽日期被取消選擇時的事件  //這邊didDeselectDate打錯
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

