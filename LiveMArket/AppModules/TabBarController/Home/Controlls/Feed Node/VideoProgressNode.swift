//
//  VideoProgressNode.swift
//  LiveMArket
//
//  Created by Rupesh E on 25/07/23.
//

import Foundation

import UIKit
import AsyncDisplayKit
import SnapKit

protocol PostProgressDelegate : AnyObject {
    func didStartDrag()
    func didEndDrag()
    func didUpdateTimeTo(float: Float)
    func didChangeSlider(float: Float)
}


class VideoProgressNode: ASDisplayNode,UIGestureRecognizerDelegate {

    var slider: CustomVideoProgressSlider!
    var gestureView: UIView!
    weak var delegate: PostProgressDelegate?
    required override init() {
        super.init()
        //self.automaticallyManagesSubnodes = true
    }
    override func didLoad() {
        super.didLoad()
       
        slider = CustomVideoProgressSlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(onSliderValChanged), for: .valueChanged)
       // slider.frame = view.bounds
     //   slider.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(slider)
        
        slider.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-2)
        }
        slider.minimumTrackTintColor = Color.darkOrange.color().withAlphaComponent(0.8) //UIColor.appColor(.appOrengeSuttle)!.withAlphaComponent(0.8)
        //UIApplication.shared.keyWindow?.addSubview(self.slider)
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.slider)
        
        gestureView = UIView()
        self.view.addSubview(gestureView)

        gestureView.frame = view.bounds
        let gsets = UIPanGestureRecognizer(target: self, action: #selector(self.panSlider(gesture:)))
        gsets.delegate = self
        self.gestureView.addGestureRecognizer(gsets)
       // self.slider.layer.zPosition = 1;
    //    UIApplication.shared.keyWindow!.bringSubviewToFront(self.slider)
        //self.view.clipsToBounds = false
    }
    @objc func onSliderValChanged() {
 //       print("11")
//        if let touchEvent = event.allTouches?.first {
//            switch touchEvent.phase {
//            case .began: break
//                // handle drag began
//            case .moved: break
//                // handle drag moved
//            case .ended: break
//                // handle drag ended
//            default:
//                break
//            }
//        }
    }
    
    
    override func layout() {
        super.layout()
        //slider?.frame = self.view.bounds
        gestureView?.frame = self.view.bounds

    }
    
    @objc func panSlider(gesture: UIPanGestureRecognizer) {
        let yTranslation = gesture.translation(in: gesture.view).x
        let tolerance: CGFloat = 5

            if abs(yTranslation) >= tolerance {
                let newValue = slider.value + Float(yTranslation / tolerance)
                slider.setValue(newValue, animated: true)

                // Reset the overall translation within the view
                gesture.setTranslation(.zero, in: gesture.view)
            }
//        let v = gesture.velocity(in: self.view).x / 2
//        print("vv \(v)")
//        slider.setValue(slider.value + Float(v), animated: true)
        
        if gesture.state == .began{
           // print("be")
            self.delegate?.didStartDrag()
            //UIView.animate(withDuration: 1.0, animations:  {() in
                    self.slider.isHighlighted = true
                    //}, completion:{(Bool)  in
                        
            //})
            slider.isHighlighted = true
        }
        
        if gesture.state == .changed{
            self.delegate?.didChangeSlider(float: self.slider.value/100)
        }
        if gesture.state == .ended{
            print("edn")
            
            //UIView.animate(withDuration: 0.0, animations:  {() in
                self.slider.isHighlighted = false
                self.delegate?.didUpdateTimeTo(float: self.slider.value/100)
                    //}, completion:{(Bool)  in
                        
           // })
            self.delegate?.didEndDrag()

        }
    }
    
    public func setProgress(progress: Float, animated: Bool){
      //  progressView.setProgress(progress, animated: false)
 //       if !animated{
//            self.slider.layer.sublayers?.forEach { $0.removeAllAnimations() }
           // self.slider.setValue(0.0001, animated: false)
            
            //self.slider.setValue(progress, animated: false)
            //return
//        }
        //self.progressView.layer.sublayers?.forEach { $0.removeAllAnimations() }
//        UIView.animate(withDuration: 1.33) { [weak self] in
//
//            self.slider.setValue(progress * 100, animated: true)
////            if progress == 1.0 {
////                self?.progressView.setProgress(0.0, animated: false)
////            }
//        }
        
       // print("slider Progress ===== \(progress * 100)")
        
        UIView.animate(withDuration: 1.0, delay: 0.0) { [weak self] in
            self?.slider?.setValue(progress * 100, animated: true)
        } completion: { complete in

        }
        

        
    }
}
class CustomVideoProgressSlider: UISlider {
    
    var sliderLableP = UILabel()

    
    @IBInspectable var trackHeight: CGFloat = 2
    
    @IBInspectable var thumbRadius: CGFloat = 5
    
    // Custom thumb view which will be converted to UIImage
    // and set as thumb. You can customize it's colors, border, etc.
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = Color.darkOrange.color().withAlphaComponent(0.8)//thumbTintColor
        thumb.layer.borderWidth = 0.4
        thumb.layer.borderColor = UIColor.darkGray.cgColor
        return thumb
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
       
        
        
        let thumb1 = thumbImage(radius: 5)
        let thumb = thumbImage(radius: 10)
        setThumbImage(thumb1, for: .normal)
        setThumbImage(thumb, for: .highlighted)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb1 = thumbImage(radius: 35)
        let thumb = thumbImage(radius: 35)
        setThumbImage(thumb1, for: .normal)
        setThumbImage(thumb, for: .highlighted)
    }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb
        
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        thumbView.clipsToBounds = false
        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
}
class DGSliderView: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: 10.0)
        
    }
}
class SliderNode: ASDisplayNode {

    

    struct Const {
        static let height: ASDimension = .init(unit: .points, value: 10.0)
    }

    let sliderNode = ASDisplayNode.init(viewBlock: { () -> UIView in
        let view = DGSliderView.init()
        view.tintColor = .orange
        view.backgroundColor = .clear
        view.maximumTrackTintColor = .clear
        return view
    })

    let backgroundNodes: [ASDisplayNode] = (0 ..< 3).map({ _ -> ASDisplayNode in
        let node = ASDisplayNode()
        node.backgroundColor = .gray
        node.style.height = Const.height
        return node
    })

    var sliderView: UISlider? {
        return sliderNode.view as? UISlider
    }

    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
    }

    override func layout() {
        super.layout()

    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        for e in self.backgroundNodes {
            e.style.flexGrow = 1.0
        }
        let backgroundLayout = ASStackLayoutSpec(direction: .horizontal,
                                                 spacing: 2.0,
                                                 justifyContent: .start,
                                                 alignItems: .stretch,
                                                 children: self.backgroundNodes)

        return ASOverlayLayoutSpec(child: backgroundLayout, overlay: sliderNode)
    }
}
