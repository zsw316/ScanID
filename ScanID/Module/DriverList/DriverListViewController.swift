//
//  DriverListViewController.swift
//  ScanID
//
//  Created by Ashley Han on 26/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class DriverListViewController: BaseViewController {

    fileprivate var tableView: UITableView!
    
    fileprivate var driverLicenceEntities: [DriverLicenseEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigation()
        self.initSubviews()
        self.getData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - initNavigation
    fileprivate func initNavigation()
    {
        self.title = "Drivers"
        self.initScanButton()
    }
    
    private func initScanButton()
    {
        let scanButton: UIButton = UIButton(type: .custom)
        scanButton.setImage(UIImage.init(named: "scan"), for: .normal)
        scanButton.sizeToFit()
        scanButton.addTarget(self, action: #selector(DriverListViewController.didTapScanButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: scanButton)
    }
    
    func didTapScanButton()
    {
        let scannerViewController: ScannerViewController = ScannerViewController()
        let navigationController: BaseNavigationController = BaseNavigationController(rootViewController: scannerViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - init subviews
    private func initSubviews() {
        // tableView
        tableView = UITableView(frame: CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height), style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }

    private func getData() {
        if let allEntities = DriverLicenceService.getAllDriverlicences() {
            self.driverLicenceEntities = allEntities
            self.tableView.reloadData()
        }
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

extension DriverListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverLicenceEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let entity: DriverLicenseEntity = self.driverLicenceEntities[indexPath.row]
        cell.textLabel?.text = "\(entity.firstNames)  \(entity.familyName)"
        cell.detailTextLabel?.text = entity.lincese
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity: DriverLicenseEntity = self.driverLicenceEntities[indexPath.row]
        let detailController: DriverDetailViewController = DriverDetailViewController()
        detailController.entity = entity
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}
