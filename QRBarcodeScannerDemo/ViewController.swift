//
//  ViewController.swift
//  QRBarcodeScannerDemo
//
//  Created by Sergio Flores Ramirez on 20/11/20.
//

import UIKit
import Resolver
import RxSwift

class ViewController: UIViewController {
    
    @Injected var viewModel: ViewModel
    // MARK: -Outlets
    
    @IBOutlet weak var qrTableView: UITableView!
    @IBOutlet weak var bcTableView: UITableView!
    let disposeBag = DisposeBag()
    @IBAction func openQRBCScannerAction() {
        openQRBCScanner()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        viewModelBinding()
    }
    
    // MARK: - Functions
    private func openQRBCScanner() {
        let qrbcScannerVC = QRBCScannerViewController()
        navigationController?.pushViewController(qrbcScannerVC, animated: true)
    }
    
    private func setupUI() {
        qrTableView.tableFooterView = UIView()
        bcTableView.tableFooterView = UIView()
    }
    
    private func viewModelBinding() {
        viewModel.bindingQrDataTable.subscribe(onNext: { res in
            print(res)
        }).disposed(by: disposeBag)
        
        viewModel.bindingBcDataTable.bind(to: bcTableView.rx.items(cellIdentifier: "BCTableViewCell", cellType: BCTableViewCell.self)) { _, data, cell in
            cell.bcDataLabel.text = data
        }.disposed(by: disposeBag)
        
        viewModel.bindingQrDataTable.bind(to: qrTableView.rx.items(cellIdentifier: "QRTableViewCell", cellType: QRTableViewCell.self)) {_, data, cell in
            cell.qrDataLabel.text = data
        }.disposed(by: disposeBag)
    }


}

