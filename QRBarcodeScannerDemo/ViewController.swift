//
//  ViewController.swift
//  QRBarcodeScannerDemo
//
//  Created by Sergio Flores Ramirez on 20/11/20.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: -Outlets
    @IBAction func openQRBCScannerAction() {
        openQRBCScanner()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Functions
    private func openQRBCScanner() {
        let qrbcScannerVC = QRBCScannerViewController()
        navigationController?.pushViewController(qrbcScannerVC, animated: true)
    }


}

