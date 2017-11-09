//
//  AnimationViewController.swift
//  Test
//
//  Created by CSX on 2017/11/7.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

import UIKit

enum btnTag:NSInteger {
    case animationTags = 10
}

class AnimationViewController: UIViewController {
    static var interestRate : Int = 0
    static var beziLayer = CAShapeLayer()
    
    var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "动画效果处理"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        createViewForUI()
    }

    func createViewForUI() {
        
        imageView.frame = CGRect(x:150,y:250,width:200,height:300)
        var images = [UIImage]()
        for index in 0..<81 {
            images.append(UIImage.init(named: String.init(format: "drink_%.2d.jpg", index))!)
        }
        imageView.image = UIImage.init(named: "drink_00.jpg")
        imageView.animationImages = images
        imageView.animationDuration = 6
        imageView.animationRepeatCount = 1
        self.view.addSubview(imageView)
        
        
        
        let titleArr = NSArray.init(objects: "粒子动画","贝塞尔曲线动画","UIView动画","帧动画")
        for index in 0..<titleArr.count {
            let btn = UIButton.init(type: UIButtonType.system)
            btn.setTitle(titleArr[index] as? String, for: UIControlState.normal)
            btn.frame = CGRect(x:10,y:70+60*index,width:100,height:50)
            btn.setTitleColor(UIColor.cyan, for: UIControlState.normal)
            btn.tag = btnTag.animationTags.rawValue+index
            btn.setBackgroundImage(ImageClass.imageWithColor(color: UIColor.lightGray), for: UIControlState.normal)
            btn.addTarget(self, action: #selector(animation(sender:)), for: UIControlEvents.touchUpInside)
            self.view.addSubview(btn)
        }
        
        
    }
    
    @objc func animation(sender: UIButton){
        switch sender.tag-btnTag.animationTags.rawValue {
        case 0:
            do{
                print("粒子动画")
                ParticleAnimation()
            }
        case 1:
            do{
                print("贝塞尔曲线动画")
                BezierCurveAninmation(sender: sender)
            }
        case 2:
            do{
                print("UIView动画")
                UIViewAnimation(sender:sender)
            }
        case 3:
            do{
                print("帧动画")
                FrameAnimation(sender: sender)
                imageView.startAnimating()
            }
        default:
            break
        }
    }
    
    func ParticleAnimation() {
        let rect = CGRect(x: 0.0, y: -70.0, width: view.bounds.width,
                          height: 50.0)
        let emitter = CAEmitterLayer()
        emitter.frame = rect
        view.layer.addSublayer(emitter)
        emitter.emitterShape = kCAEmitterLayerRectangle        
        //kCAEmitterLayerPoint
        //kCAEmitterLayerLine
        //kCAEmitterLayerRectangle
        
        emitter.emitterPosition = CGPoint(x:rect.width/2, y:rect.height/2)
        emitter.emitterSize = rect.size
        
        let emitterCell = CAEmitterCell()
        emitterCell.contents = UIImage(named: "0757565255b62fc")?.scaleImageToWidth(30).cgImage
        emitterCell.birthRate = 120  //每秒产生120个粒子
        emitterCell.lifetime = 3    //存活1秒
        emitterCell.lifetimeRange = 3.0
        
        emitter.emitterCells = [emitterCell]  //这里可以设置多种粒子 我们以一种为粒子
        emitterCell.yAcceleration = 70.0  //给Y方向一个加速度
        emitterCell.xAcceleration = 20.0 //x方向一个加速度
        emitterCell.velocity = 20.0 //初始速度
        emitterCell.emissionLongitude = CGFloat(-Double.pi) //向左
        emitterCell.velocityRange = 200.0   //随机速度 -200+20 --- 200+20
        emitterCell.emissionRange = CGFloat(Double.pi/2) //随机方向 -pi/2 --- pi/2
        //emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0,
        //   alpha: 1.0).CGColor //指定颜色
        emitterCell.redRange = 0.3
        emitterCell.greenRange = 0.3
        emitterCell.blueRange = 0.3  //三个随机颜色
        emitterCell.spin = 5  //增殖细胞定义的粒子自旋。默认为1（不自旋），数字越大自旋越快！
        emitterCell.scale = 0.8
        emitterCell.scaleRange = 0.8  //0 - 1.6
        emitterCell.scaleSpeed = -0.15  //逐渐变小
        
        emitterCell.alphaRange = 0.75   //随机透明度
        emitterCell.alphaSpeed = -0.15  //逐渐消失
        
    }
    
    func BezierCurveAninmation(sender:UIButton) {
        
//        获取测试的路线
        let path = funcationOfBezi(number: AnimationViewController.interestRate)
        
        let layer = CAShapeLayer()
        self.view.layer .addSublayer(layer)
        AnimationViewController.beziLayer.path = path.cgPath
        AnimationViewController.beziLayer.fillColor = UIColor.clear.cgColor
        AnimationViewController.beziLayer.strokeColor = UIColor.red.cgColor
        layer.addSublayer(AnimationViewController.beziLayer)
        animation1(layer: layer)
  
        AnimationViewController.interestRate = AnimationViewController.interestRate+1
        if AnimationViewController.interestRate>4 {
            AnimationViewController.interestRate = 0
        }
    }
    
    func UIViewAnimation(sender:UIButton) {
        let frameOld = sender.frame
        [UIView .animate(withDuration: 1, delay: 1, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            sender.frame = CGRect(x:200,y:500,width:100,height:50)
        }, completion: { (isCompress) in
            [UIView .animate(withDuration: 1, delay: 1, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
                sender.frame = frameOld
            }, completion: { (isSuccess) in
                print("动画结束")
            })]
        })]
    }
    
    
    func FrameAnimation(sender:UIButton) {
        
    }
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK:-----贝塞尔曲线方法处理
    func funcationOfBezi(number:Int) -> UIBezierPath{
        switch number {
        case 0:
            do{
//                返回一个正方形的贝塞尔曲线路径
                let path = UIBezierPath(rect: CGRect(x:110, y:100, width:150, height:100))
                return path
            }
        case 1:
            do{
//               返回一个两边都被切好的半圆的贝塞尔曲线路径
                let path = UIBezierPath(roundedRect: CGRect(x:110, y:100, width:150, height:100), cornerRadius: 50)
                return path
            }
        case 2:
            do{
//                返回一个圆形的路径
                let radius: CGFloat = 60.0
                let startAngle: CGFloat = 0.0
                let endAngle: CGFloat = CGFloat(Double.pi * 2)
                let path = UIBezierPath(arcCenter: view.center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                return path
            }
        case 3:
            do{
                let startPoint = CGPoint(x:50, y:300)
                let endPoint = CGPoint(x:300, y:300)
                let controlPoint = CGPoint(x:170, y:200)
                
                let layer1 = CALayer()
                layer1.frame = CGRect(x:startPoint.x, y:startPoint.y, width:5, height:5)
                layer1.backgroundColor = UIColor.red.cgColor
                
                let layer2 = CALayer()
                layer2.frame = CGRect(x:endPoint.x, y:endPoint.y, width:5, height:5)
                layer2.backgroundColor = UIColor.red.cgColor
                
                let layer3 = CALayer()
                layer3.frame = CGRect(x:controlPoint.x, y:controlPoint.y, width:5, height:5)
                layer3.backgroundColor = UIColor.red.cgColor
                
                let path = UIBezierPath()
            
                path.move(to: startPoint)
//                path.addLine(to: <#T##CGPoint#>)
                path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
                
                return path
            }
        case 4:
            do{
                let startPoint = CGPoint(x:50, y:300)
                let endPoint = CGPoint(x:300, y:300)
                let controlPointOne = CGPoint(x:50+62, y:200)
                let controlPointTwo = CGPoint(x:50+62+125, y:400)
                
                let layer1 = CALayer()
                layer1.frame = CGRect(x:startPoint.x, y:startPoint.y, width:5, height:5)
                layer1.backgroundColor = UIColor.red.cgColor
                
                let layer2 = CALayer()
                layer2.frame = CGRect(x:endPoint.x, y:endPoint.y, width:5, height:5)
                layer2.backgroundColor = UIColor.red.cgColor
                
                let layer3 = CALayer()
                layer3.frame = CGRect(x:controlPointOne.x, y:controlPointOne.y, width:5, height:5)
                layer3.backgroundColor = UIColor.red.cgColor
                
                let layer4 = CALayer()
                layer4.frame = CGRect(x:controlPointTwo.x, y:controlPointTwo.y, width:5, height:5)
                layer4.backgroundColor = UIColor.red.cgColor
                
                let path = UIBezierPath()
                //                let layer = CAShapeLayer()
                
                path.move(to: startPoint)
                path.addCurve(to: endPoint, controlPoint1: controlPointOne, controlPoint2: controlPointTwo)
                
                return path
            }
        default:
            do{
                let path = UIBezierPath()
                return path
            }
        }
    }
//     CAShapeLayer
    private func animation1(layer:CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        layer.add(animation, forKey: "")
    }
    
    private func animation2(layer:CAShapeLayer) {
        layer.strokeStart = 0.5
        layer.strokeEnd = 0.5
        
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = 0.5
        animation.toValue = 0
        animation.duration = 2
        
        let animation2 = CABasicAnimation(keyPath: "strokeEnd")
        animation2.fromValue = 0.5
        animation2.toValue = 1
        animation2.duration = 2
        
        layer.add(animation, forKey: "")
        layer.add(animation2, forKey: "")
    }
    
    private func animation3(layer:CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.fromValue = 1
        animation.toValue = 10
        animation.duration = 2
        layer.add(animation, forKey: "")
    }
    
    
    
}
