//
//  ZYScanViewController.swift
//  ZYScaner
//
//  Created by Nvr on 2018/5/8.
//  Copyright © 2018年 ZY. All rights reserved.
//

import UIKit

class ZYScanViewController: LBXScanViewController {
    
    /**
     @brief  扫码区域上方提示文字
     */
    var topTitle:UILabel?
    
    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash:Bool = false
    
    /**
     @brief  描边颜色
     */
    var angleColor:UIColor = UIColor.blue
    
    /**
     @brief  动画照片
     */
    var lineImage:UIImage?
    
    // MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
    
    //底部显示的功能项
    var bottomItemsView:UIView?
    
    //相册
    var btnPhoto:UIButton = UIButton()
    
    //闪光灯
    var btnFlash:UIButton = UIButton()
    
    //MARK: -系统回调方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        drawBottomItems()
    }
    
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        
        let result:LBXScanResult = arrayResult[0]
        dealWithScanCode(result)
        
    }
    
    //MARK: -----相册选择图片识别二维码 （条形码没有找到系统方法）
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        
        var image:UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if (image == nil )
        {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        if(image == nil)
        {
            return
        }
        
        if(image != nil)
        {
            
            let arrayResult = LBXScanWrapper.recognizeQRImage(image: image!)
            if arrayResult.count > 0
            {
                let result = arrayResult[0];
                
                dealWithScanCode(result)
                
                return
            }
        }
    }
    
    
}

//MARK: -UI

extension ZYScanViewController {
    
    func setting(){
        self.title = NSLocalizedString("qr_scan", comment: "")
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)
        //框向上移动10个像素
        scanStyle?.centerUpOffset += 10
        scanStyle = getStyle()
    }
    
    //扫码框样式
    
    func getStyle() -> LBXScanViewStyle {
        
        var lbxStyle = LBXScanViewStyle()
        lbxStyle.centerUpOffset = 44
        lbxStyle.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        lbxStyle.photoframeLineW = 3
        lbxStyle.photoframeAngleW = 30
        lbxStyle.photoframeAngleH = 30
        lbxStyle.isNeedShowRetangle = false
        lbxStyle.colorAngle = angleColor
        lbxStyle.anmiationStyle = LBXScanViewAnimationStyle.LineMove
        
        lbxStyle.animationImage = lineImage
        lbxStyle.color_NotRecoginitonArea = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        return lbxStyle
    }
    
    
    func drawBottomItems()
    {
        if (bottomItemsView != nil) {
            
            return;
        }
        
        let yMax = self.view.frame.maxY - self.view.frame.minY
        
        bottomItemsView = UIView(frame:CGRect(x: 0.0, y: yMax-100,width: self.view.frame.size.width, height: 100 ) )
        
        
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        self.view .addSubview(bottomItemsView!)
        
        
        let size = CGSize(width: 65, height: 87);
        
        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width/3, y: bottomItemsView!.frame.height/2)
        btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        btnFlash.addTarget(self, action: #selector(ZYScanViewController.openOrCloseFlash), for: UIControlEvents.touchUpInside)
        
        
        self.btnPhoto = UIButton()
        btnPhoto.bounds = btnFlash.bounds
        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width/3*2, y: bottomItemsView!.frame.height/2)
        btnPhoto.setImage(UIImage(named: "qrcode_scan_btn_photo_nor"), for: UIControlState.normal)
        btnPhoto.setImage(UIImage(named: "qrcode_scan_btn_photo_down"), for: UIControlState.highlighted)
        btnPhoto.addTarget(self, action: #selector(ZYScanViewController.openLocalPhotoAlbum), for: UIControlEvents.touchUpInside)
        
        
        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnPhoto)
        
        self.view .addSubview(bottomItemsView!)
        
    }
}

//MARK: -点击事件

extension ZYScanViewController{
    
    //打开相册
    @objc func openLocalPhotoAlbum()
    {
        LBXPermissions.authorizePhotoWith { [weak self] (granted) in
            
            if granted
            {
                if let strongSelf = self
                {
                    let picker = UIImagePickerController()
                    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                    picker.delegate = self;
                    picker.allowsEditing = true
                    strongSelf.present(picker, animated: true, completion: nil)
                }
            }
            else
            {
                LBXPermissions.jumpToSystemPrivacySetting()
            }
        }
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash()
    {
        scanObj?.changeTorch();
        
        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_down"), for:UIControlState.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        }
    }
    
}


//MARK: - loadData
extension ZYScanViewController {
    
    //MARK : - 获得结果之后处理
    func dealWithScanCode(_ scanInfo:LBXScanResult?) {
        
    }
}


extension UIColor {
    class func colorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


