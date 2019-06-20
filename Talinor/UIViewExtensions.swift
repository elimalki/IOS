//
//  UIKitExtension.swift
//  Talinor
//
//  Created by Vlad Kovalyov on 02/01/2019.
//  Copyright © 2019 Organization. All rights reserved.
//

import UIKit

private let loadViewTag = 777
private let spinerViewTag = 111

enum ShadowDirrection{
    case top
    case left
    case right
    case bottom
    
    case topLeft
    case topRight
    
    case bottomLeft
    case bottomRight
    
    case leftBottomRight
    case leftTopRight
    
    case leftRight
    case topBottom
}

enum innerShadowSide{
    case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
}

extension UIView{
    func toAlpha(_ newAlpha: CGFloat, duration: CGFloat = 0.4, complete: (()->Void)? = nil){
        UIView.animate(withDuration: TimeInterval(duration),
                       animations: {[unowned self] in self.alpha = newAlpha },
                       completion: { (_) in complete?() })
        
    }
    
    func showLoadView(with text: String? = nil, blur: Bool = true, style: UIActivityIndicatorView.Style = .whiteLarge){
        
        let loadView = UIView()
        let progressView = UIActivityIndicatorView.init(style: style)
        let label = UILabel()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let backgroundView = blur ? UIVisualEffectView(effect: blurEffect) : UIView()
        
        progressView.color = #colorLiteral(red: 0.52134341, green: 0.4080860615, blue: 0.7559894919, alpha: 1)
        
        backgroundView.backgroundColor = .clear
        backgroundView.autoresizingMask = [.flexibleWidth]
        
        progressView.startAnimating()
        loadView.tag = loadViewTag
        label.text = text
        
        addSubview(loadView)
        loadView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loadView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        loadView.addSubview(progressView)
        loadView.addSubview(label)
        
        progressView.snp.makeConstraints { (make) in
            make.bottom.equalTo(label.snp.top)
            make.centerX.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        
        bringSubviewToFront(loadView)
        
        layoutIfNeeded()
        loadView.layoutIfNeeded()
    }
    
    func hideLoadView(){
        self.subviews.forEach{view in
            if view.tag == loadViewTag {
                view.removeFromSuperview()
            }
        }
    }
    
    func addBlur(toAlpha: CGFloat = 0, duration: CGFloat = 0){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let backgroundView = UIVisualEffectView(effect: blurEffect)
        
        backgroundView.tag = 9909
        backgroundView.backgroundColor = .clear
        backgroundView.autoresizingMask = [.flexibleWidth]
        
        if toAlpha > 0{
            //backgroundView.alpha = 0
            //backgroundView.toAlpha(toAlpha, duration: duration)
        }
        
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        layoutIfNeeded()
    }
    
    func removeBlur(duration: TimeInterval = 0, handler: (()->Void)? = nil){
        if duration == 0{
            subviews.forEach{ if $0.tag == 9909{ $0.removeFromSuperview() } }
        } else {
            guard let view = (subviews.first{ $0.tag == 9909}) else { return }
            
            view.toAlpha(0, duration: CGFloat(duration)){
                handler?()
            }
        }
    }
    
    func addBlackout(with color: UIColor = UIColor.black.withAlphaComponent(0.3), duration: TimeInterval = 0){
        
        guard !(subviews.contains{ $0.tag == 8934}) else { return }
        
        let backgroundView = UIView()
        
        backgroundView.tag = 8934
        backgroundView.backgroundColor = color
        
        addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if duration == 0{
            layoutIfNeeded()
        } else {
            layoutIfNeeded(duration: duration)
        }
    }
    
    func removeBlackout(){
        subviews.forEach{ if $0.tag == 8934{ $0.removeFromSuperview() } }
    }
    
    func shake(plusX: CGFloat = 0, plusY: CGFloat = 10, duration: Double = 0.3) {
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: center.x, y: center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: center.x - plusX, y: center.y - plusY))
        shakeAnimation.duration = duration
        shakeAnimation.repeatCount = 3
        shakeAnimation.autoreverses = true
        
        layer.add(shakeAnimation, forKey: "position")
    }
    
    func animateRotationCorner(duration: CFTimeInterval = 0.2, repeatingCount: Float = Float.infinity) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = duration
        rotation.repeatCount = repeatingCount
        layer.add(rotation, forKey: "Spin")
    }
    
    func scaleAnimate(repeatCount: Float = 1000){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 1.0
        pulse.toValue = 1.04
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.7
        animationGroup.repeatCount = repeatCount
        animationGroup.animations = [pulse]
        
        layer.add(animationGroup, forKey: "pulse")
    }
    
    func layoutIfNeeded(duration: TimeInterval, complete: (()->Void)? = nil){
        UIView.animate(withDuration: duration,
                       animations: {[unowned self] in
                        self.layoutIfNeeded()
            },
                       completion:  {_ in
                        complete?()
        })
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...){
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func dropShadow(direction: ShadowDirrection = .bottom, color: UIColor, opacity: Float = 0.5, radius: CGFloat = 1, scale: Bool = true) {
        var offSet: CGSize = CGSize.zero
        
        switch direction {
        case .top: offSet = CGSize(width: 0, height: -1)
        case .left: offSet = CGSize(width: -1, height: 0)
        case .right: offSet = CGSize(width: 1, height: 0)
        case .bottom: offSet = CGSize(width: 0, height: 1)
            
        case .topLeft: offSet = CGSize(width: -1, height: -1)
        case .topRight: offSet = CGSize(width: 1, height: 1)
            
        case .bottomLeft: offSet = CGSize(width: -1, height: 1)
        case .bottomRight: offSet = CGSize(width: 1, height: 1)
            
        case .leftBottomRight: offSet = CGSize(width: -1, height: 1)//
        case .leftTopRight: offSet = CGSize(width: -1, height: 1)//
            
        case .leftRight: offSet = CGSize(width: -1, height: 1)//
        case .topBottom: offSet = CGSize(width: -1, height: 1)//
        }
        
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
        
        // layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        // layer.shouldRasterize = true
        // layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func hideShadow(){
        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 0
    }
    
    func showSpinner(spinnerStyle: UIActivityIndicatorView.Style = .white){
        
        guard ( subviews.first{ $0.tag == spinerViewTag } ) == nil else { return }
        
        let loadIndicator = UIActivityIndicatorView.init(style: spinnerStyle)
        loadIndicator.tag = spinerViewTag
        loadIndicator.startAnimating()
        
        (self as? UIButton)?.setTitle((self as? UIButton)?.currentTitle, for: .reserved)
        (self as? UIButton)?.setTitle(nil, for: .normal)
        
        (self as? UIButton)?.setImage((self as? UIButton)?.currentImage, for: .reserved)
        (self as? UIButton)?.setImage(nil, for: .normal)
        
        addSubview(loadIndicator)
        loadIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        isUserInteractionEnabled = false
        layoutIfNeeded()
    }
    
    func hideSpinner(){
        guard let spinerView = ( subviews.first{ $0.tag == spinerViewTag } ) else { return }
        
        isUserInteractionEnabled = true
        spinerView.toAlpha(0){
            spinerView.removeFromSuperview()
        }
        
        (self as? UIButton)?.setTitle((self as? UIButton)?.title(for: .reserved), for: .normal)
        (self as? UIButton)?.setTitle(nil, for: .reserved)
        
        (self as? UIButton)?.setImage((self as? UIButton)?.image(for: .reserved), for: .normal)
        (self as? UIButton)?.setImage(nil, for: .reserved)
        layoutIfNeeded()
    }
    
    // define function to add inner shadow
    func addInnerShadow(onSide: innerShadowSide, shadowColor: UIColor, shadowSize: CGFloat, cornerRadius: CGFloat = 0.0, shadowOpacity: Float) {
        if (layer.sublayers?.contains{ $0.name == "innerShadow"}) == true{
            layer.sublayers?.forEach{ if $0.name == "innerShadow" { $0.removeFromSuperlayer(); return }}
        }
        
        // define and set a shaow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = CAShapeLayerFillRule.evenOdd
        shadowLayer.name = "innerShadow"
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide
            {
            case .all:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            case .left:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .right:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .top:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case.bottom:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndLeft:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndRight:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndLeft:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndRight:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .exceptLeft:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptRight:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptTop:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            case .exceptBottom:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
        
        // hide outside drawing area
        clipsToBounds = true
        
        layer.layoutIfNeeded()
    }
}

protocol UIViewElementsActions{
    func addElementsToSuperView()
    func removeElementsFromSuperView()
}
