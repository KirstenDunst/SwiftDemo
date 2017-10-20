//
//  ImageClass.swift
//  Test
//
//  Created by CSX on 2017/10/19.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

import UIKit

class ImageClass: NSObject {

    //    绘制颜色转换成图片的格式的方法
    class func imageWithColor(color:UIColor) -> UIImage {
        let  rect =  CGRect(x:0.0,y:0.0,width:1.0,height:1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
