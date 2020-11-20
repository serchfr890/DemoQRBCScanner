//
//  ViewModel.swift
//  QRBarcodeScannerDemo
//
//  Created by Sergio Flores Ramirez on 20/11/20.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    let qrCodeScannedFromScannerCamera = PublishSubject<String>()
    let bcCodeScannerFromScannerCamera = PublishSubject<String>()
    var bindingQrDataTable = BehaviorSubject<[String]>(value: [])
    var bindingBcDataTable = BehaviorSubject<[String]>(value: [])
    let disposeBag = DisposeBag()
    var qrCodesScanned: [String] = []
    var bcCodesScanned: [String] = []
    init() {
        // Gets QR Data and print it to table
        qrCodeScannedFromScannerCamera.subscribe(onNext: { [weak self] codeScanned in
            if !codeScanned.isEmpty {
                self?.qrCodesScanned.append(codeScanned)
            }
            self?.bindingQrDataTable.onNext(self?.qrCodesScanned ?? ["a","b","c"])
        }).disposed(by: disposeBag)
        
        // Gets Bar Code data and print it to table
        bcCodeScannerFromScannerCamera.subscribe(onNext: { [weak self] bcCodeScanned in
            if !bcCodeScanned.isEmpty {
                self?.bcCodesScanned.append(bcCodeScanned)
            }
            self?.bindingBcDataTable.onNext(self?.bcCodesScanned ?? ["a", "b", "c"] )
        }).disposed(by: disposeBag)
    }
    
}
