//
//  DropDownView.swift
//  TrendTestTask
//
//  Created by Nikolay on 14/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//

import UIKit

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownOptions = [DropDownPriceModel]()
    var selectedIndex = Int()
    
    var tableView = UITableView()
    
    weak var delegate: DropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        
        tableView.register(UINib.init(nibName: "PickerCell", bundle: nil), forCellReuseIdentifier: "pickerCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickerCell", for: indexPath) as! PickerCell
        cell.amountLabel.text = dropDownOptions[indexPath.row].title
        
        if indexPath.row == selectedIndex {
            cell.checkMarkImage.image = UIImage(named: "checkmark")
        } else {
            cell.checkMarkImage.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(priceModel: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        
        tableView.reloadData()
    }
    
}
