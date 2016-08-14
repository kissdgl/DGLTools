//
//  LRTableView.swift
//  07-美团搭建(基本设置)
//
//  Created by 丁贵林 on 16/8/14.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

import UIKit

//MARK: - LRTableViewDatasource
@objc protocol LRTableViewDataSource : class {
    func numberOfRowsInLRTableView(lrTableView: LRTableView) -> Int
    func titleForRowsInLRTableView(lrTableView : LRTableView, leftRow : Int) -> String
    func subdataForRowsInLRTableView(lrTableView : LRTableView, leftRow : Int) -> [String]?
    optional func iconNameForRowsInLRTableView(lrTableView : LRTableView, leftRow : Int) -> String
    optional func highIconNameForRowsInLRTableView(lrTableView : LRTableView, leftRow : Int) -> String
}

//MARK: - LRTableViewDelegate
@objc protocol LRTableViewDelegate : class {
    optional func didSelectedLeftRowInLRTableView(lrTableView : LRTableView, leftRow : Int)
    optional func didSelectedRightRowInLRTableView(lrTableView : LRTableView, leftRow : Int, rightRow : Int)
}

public class LRTableView: UIView {

    //MARK: - 数据源
    weak var dataSource : LRTableViewDataSource?
    weak var delegate : LRTableViewDelegate?
    var subData : [String]?
    var leftCurrentIndex : Int = 0
    
    
    //MARK: - 懒加载属性
    public lazy var leftTableView : UITableView = UITableView()
    public lazy var rightTableView : UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(leftTableView)
        addSubview(rightTableView)
        
        leftTableView.separatorStyle = .None
        rightTableView.separatorStyle = .None
        
        leftTableView.dataSource = self
        rightTableView.dataSource = self
        leftTableView.delegate = self
        rightTableView.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LRTableView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        leftTableView.frame = CGRectMake(0, 0, bounds.width * 0.5, bounds.height)
        rightTableView.frame = CGRectMake(bounds.width * 0.5, 0, bounds.width * 0.5, bounds.height)
        
    }
}


//MARK: - UITableViewDataSource
extension LRTableView : UITableViewDataSource {
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == leftTableView {
            return dataSource?.numberOfRowsInLRTableView(self) ?? 0
        } else {
            return subData?.count ?? 0
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell?
        
        if tableView == leftTableView {
            
            cell = LeftViewCell.leftViewCell(tableView)
            
            //设置数据
            cell?.textLabel?.text = dataSource?.titleForRowsInLRTableView(self, leftRow: indexPath.row)
            if let iconName = dataSource?.iconNameForRowsInLRTableView?(self, leftRow: indexPath.row) {
                cell?.imageView?.image = UIImage(named: iconName)
            }
            if let highIconName = dataSource?.highIconNameForRowsInLRTableView?(self, leftRow: indexPath.row) {
                cell?.imageView?.highlightedImage = UIImage(named: highIconName)
            }
            
        } else {
            
            cell = RightViewCell.rightViewCell(tableView)
            cell?.textLabel?.text = subData![indexPath.row]
        }
        
        return cell!
    }
    
}

//MARK: - UITableViewDelegate
extension LRTableView : UITableViewDelegate {
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == leftTableView {
            subData = dataSource?.subdataForRowsInLRTableView(self, leftRow: indexPath.row)
            rightTableView.reloadData()
            
            //记录左侧选中的下标值
            leftCurrentIndex = indexPath.row
            delegate?.didSelectedLeftRowInLRTableView?(self, leftRow: indexPath.row)
        } else {
            delegate?.didSelectedRightRowInLRTableView?(self, leftRow: leftCurrentIndex, rightRow: indexPath.row)
        }
        
    }
}













//MARK: - LeftViewCell
class LeftViewCell : UITableViewCell {
    
}

extension LeftViewCell {
    
    private class func leftViewCell(tableView : UITableView) -> LeftViewCell? {
        
        let LeftCellID = "LeftCellID"
        var cell = tableView.dequeueReusableCellWithIdentifier(LeftCellID) as? LeftViewCell
        
        if cell == nil {
            cell = LeftViewCell(style: .Default, reuseIdentifier: LeftCellID)
            
            //设置背景
            cell?.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_leftpart"))
            cell?.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_left_selected"))
        }
        return cell
    }
    
}


//MARK: - RightViewCell
class RightViewCell : UITableViewCell {
    
}

extension RightViewCell {
    
    private class func rightViewCell(tableView : UITableView) -> RightViewCell? {
        
        let RightCellID = "RightCellID"
        var cell = tableView.dequeueReusableCellWithIdentifier(RightCellID) as? RightViewCell
        
        if cell == nil {
            cell = RightViewCell(style: .Default, reuseIdentifier: RightCellID)
            
            //设置背景
            cell?.backgroundView = UIImageView(image: UIImage(named: "bg_dropdown_rightpart"))
            cell?.selectedBackgroundView = UIImageView(image: UIImage(named: "bg_dropdown_right_selected"))
        }
        return cell
    }
    
}

