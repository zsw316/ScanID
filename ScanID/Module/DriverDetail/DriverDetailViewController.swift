//
//  DriverDetailViewController.swift
//  ScanID
//
//  Created by Ashley Han on 27/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class DriverDetailViewController: BaseViewController {

    var imageView: UIImageView!
    
    var tableView: UITableView!
    
    var entity: DriverLicenseEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.view.backgroundColor = UIColor.white
        self.initSubviews()
        self.initNavigation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSubviews() {
        let imageViewHeight: CGFloat = 250.0
        let tableViewOffset: CGFloat = 10.0
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: imageViewHeight))
        imageView.image = DriverLicenceService.getImageForDriver(entity: entity!)
        view.addSubview(imageView)
        
        tableView = UITableView(frame: CGRect(x: 0, y: imageViewHeight + tableViewOffset, width: self.view.frame.width, height: self.view.frame.height - tableViewOffset - imageViewHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func initNavigation() {
        self.title = "Identity Information"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension DriverDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell.init(style: .value1, reuseIdentifier: nil)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Family Name"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.familyName
            }
        case 1:
            cell.textLabel?.text = "First Names"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.firstNames
            }
        case 2:
            cell.textLabel?.text = "Date of Birth"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.dateOfBirth
            }
        case 3:
            cell.textLabel?.text = "Licence"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.lincese
            }
        case 4:
            cell.textLabel?.text = "Version"
            if let entity = self.entity {
                cell.detailTextLabel?.text = entity.version
            }
        case 5:
            cell.textLabel?.text = "Address"
            if let entity = self.entity {
                cell.detailTextLabel?.numberOfLines = 4
                cell.detailTextLabel?.text = entity.address
            }
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 80.0
        }
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Identity Information"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
