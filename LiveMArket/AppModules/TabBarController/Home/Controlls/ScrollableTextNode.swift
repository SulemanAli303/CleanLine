//
//  ScrollableTextNode.swift
//  Teyaar
//
//  Created by Mac User on 31/10/21.
//  Copyright © 2021 A2Solutions. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

struct MessageV {
    var text : String
    var translatedText : String?
}

protocol ScrollableNodeDelegate: AnyObject{
    func didTapSeeMore()
}

class ScrollableTextNode: ASDisplayNode {
    
    fileprivate let scrollNode: ASScrollNode
    public let termNode: ASTextNode
    public var currentTerm: MessageV?
    var delegate : PostNodeDelegate?
    weak var delegateScroll : ScrollableNodeDelegate?
    var translatedStatus = false
 
    
    override init() {
        
        termNode = ASTextNode()
        termNode.maximumNumberOfLines = 2
        termNode.isLayerBacked = false
        termNode.isUserInteractionEnabled = true
        let moreText = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 14)!, NSAttributedString.Key.foregroundColor: Color.darkOrange.color()]
        let moreString = NSMutableAttributedString(string: "..More", attributes:moreText)
        termNode.truncationAttributedText = moreString
        
        scrollNode = ASScrollNode()
        scrollNode.automaticallyManagesSubnodes = true
        scrollNode.automaticallyManagesContentSize = true
        scrollNode.backgroundColor = UIColor.clear
        scrollNode.style.width = ASDimensionMake(ASDimensionUnit.fraction, 1.0)
        
        
        
        super.init()
        termNode.delegate = self
        addSubnode(scrollNode)
        
        scrollNode.layoutSpecBlock = { [weak self]
            node, constrainedSize in
            
            guard let weakSelf = self else {
                
                let insets = UIEdgeInsets.init(top: 2, left: 2, bottom: 0, right: 0)
                
                let node = ASDisplayNode()
                
                let offset = ASInsetLayoutSpec(insets: insets, child: node)
                
                return offset
            }
            
            let insets = UIEdgeInsets.init(top: 2, left: 2, bottom: 0, right: 0)
            
//            let stack = ASStackLayoutSpec(direction: ASStackLayoutDirection.vertical, spacing: 0.0, justifyContent: ASStackLayoutJustifyContent.start, alignItems: ASStackLayoutAlignItems.start, children: [])
//            stack.children?.append(weakSelf.termNode)
//
            let offset = ASInsetLayoutSpec(insets: insets, child: weakSelf.termNode)
            return offset
        }
    }
    
    override func didLoad() {
        super.didLoad()
        scrollNode.view.bounces = false
        //scrollNode.view.alwaysBounceVertical = true
        scrollNode.view.alwaysBounceVertical = false
    }
    
    override func layoutDidFinish() {
        super.layoutDidFinish()
        if translatedStatus {
            termNode.attributedText = resolveTagsFromText(text: currentTerm?.translatedText ?? "")
        }else{
            termNode.attributedText = resolveTagsFromText(text: currentTerm?.text ?? "")
        }
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        if !context.isAnimated() {
            super.animateLayoutTransition(context)
            return
        }
        
        if termNode.maximumNumberOfLines == 0 {
            
//            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn) {
//                self.watchOnTVContainerNode.frame = context.finalFrame(for: self.watchOnTVContainerNode)
//            } completion: { (finished) in
//                context.completeTransition(finished)
//            }
            
            
            UIView.animate(withDuration: 3.0, delay: 1.0, options: .transitionCurlDown) {
                self.termNode.maximumNumberOfLines = 2
                self.style.maxHeight = .init()
            } completion: { (finished) in
                self.termNode.setNeedsLayout()
                self.termNode.layoutIfNeeded()
                context.completeTransition(finished)
            }
//            
//            
//            scrollableNode.termNode.setNeedsLayout()
//            scrollableNode.termNode.layoutIfNeeded()
            
        }
        
            
            
        
    }
    func setTranslatedText(translatedText: String, status: Bool){
        translatedStatus = status
        currentTerm?.translatedText = translatedText
        termNode.attributedText = resolveTagsFromText(text: translatedText)
    }
//    override func animateLayoutTransition(_ context: ASContextTransitioning) {
//        if !context.isAnimated() {
//            super.animateLayoutTransition(context)
//            return
//        }
//        context.completeTransition(true)
//    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
      //  scrollNode.style.preferredSize = constrainedSize.max
        let insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        return ASInsetLayoutSpec(insets: insets, child: scrollNode)
    }
    
    func resolveTagsFromText(text:String) -> NSAttributedString {
        
        
        let str = text.replacingOccurrences(of: "\u{fffc}", with: "")
        let trimmedString = str.trimmingCharacters(in: .whitespacesAndNewlines)
        

        let nsText:NSString =   trimmedString as NSString
        let words:[String] = nsText.components(separatedBy: " ")
        
      
        var attributes : [NSAttributedString.Key : Any] = [:]
        attributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(1.0)]
        
        let attrString = NSMutableAttributedString(string: nsText as String, attributes:attributes)
        
        for word in words {
            
            if word.contains("#") {
                if let endIndex = word.range(of: "#")?.lowerBound {
                    let final = word[endIndex...]
                    if final.count > 1 {
                        print(word[endIndex...])
                        let matchRange:NSRange = nsText.range(of: String(final))
                        let stringifiedWord:String = word as String
                        //stringifiedWord = String(stringifiedWord.dropFirst())
                        attrString.addAttribute(NSAttributedString.Key.link, value:final, range: matchRange)
                        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-Bold", size: 13) as Any, range: matchRange)
                        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: Color.darkOrange.color() , range: matchRange)
                        attrString.addAttribute(NSAttributedString.Key.underlineColor, value: Color.darkOrange.color() , range: matchRange)
                    }
                }
            }else if word.contains("http"){
                let lines = word.lines
                
                for splitWord in lines {
                    
                    if splitWord.starts(with: "http"){
                        
                        if URL(string: splitWord) != nil {
                            let matchRange = nsText.range(of: splitWord, options: String.CompareOptions.caseInsensitive)
                            attrString.addAttribute(NSAttributedString.Key.link, value:splitWord, range: matchRange)
                            attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Roboto-Bold", size: 13) as Any, range: matchRange)
                            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white , range: matchRange)
                            attrString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.white , range: matchRange)
                        }
                        
                    }
                }
            }
        }
        return attrString
    }
}
extension ScrollableTextNode : ASTextNodeDelegate{
    func textNodeTappedTruncationToken(_ textNode: ASTextNode!) {
        //self.style.maxHeight = ASDimension(unit: .points, value: 150)
        termNode.maximumNumberOfLines = 0
        let heightOfText = textNode.attributedText?.height(containerWidth: textNode.view.width)
        
        if let height = heightOfText,height  > 150{
            self.style.maxHeight = ASDimension(unit: .points, value: 150)
        }else{
            
        }
        
        termNode.setNeedsLayout()
        termNode.layoutIfNeeded()
        delegateScroll?.didTapSeeMore()
    }
    func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        guard let text = value as? String else {return}
        self.delegate?.tapOnHashTag(value: text)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let hashTagText = URL.absoluteString
        self.delegate?.tapOnHashTag(value: hashTagText)
        return false
    }
}

extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}
