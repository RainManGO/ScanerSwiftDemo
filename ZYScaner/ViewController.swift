//
//  ViewController.swift
//  ZYScaner
//
//  Created by Nvr on 2018/4/28.
//  Copyright © 2018年 ZY. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClick(_ sender: UIButton) {
        if isSimulator() {
            print("在真机进行测试")
            return
        }

        let scanVc = ZYScanViewController()
        scanVc.topTitle?.text = "二维码放入框中，自动扫描"
        scanVc.angleColor = UIColor.colorFromRGB(0xfdd000)
        scanVc.lineImage = UIImage.init(named: "qrcode_scan_light_green")
        self.navigationController?.pushViewController(scanVc, animated: false)
    }
    
    
    func isSimulator() ->Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
    
}


