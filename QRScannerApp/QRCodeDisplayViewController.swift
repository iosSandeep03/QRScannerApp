//
//  QRCodeDisplayViewController.swift
//  QRScannerApp
//
//  Created by Sandeep kumar on 10/09/23.
//

import UIKit

class QRCodeDisplayViewController: UIViewController {
    @IBOutlet weak var qrCodeImageView: UIImageView!
    var qrCodeImage: UIImage?
    var outputText = ""

    @IBOutlet weak var outputLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCodeImageView.image = qrCodeImage
        outputLbl.text = outputText
    }
}

