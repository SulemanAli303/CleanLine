//
//  PostListViewController+PostMute.swift
//  LiveMArket
//
//  Created by Rupesh E on 12/07/23.
//

import Foundation
import UIKit

extension PostListViewController {
    
    var contentOffset: CGPoint? {
        get{
            return _collectionNode.contentOffset
        }
    }
    
    private var visibleSize: CGSize? {
        get {
            return _collectionNode.bounds.size
        }
    }
    
    private var visibleIndexPath: IndexPath? {
        get {
            var visibleRect = CGRect()
            visibleRect.origin = self.contentOffset ?? CGPoint.zero
            visibleRect.size = self.visibleSize ?? CGSize.zero
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            return _collectionNode.indexPathForItem(at: visiblePoint)
        }
    }
    
    internal var visibleNode: FeedNode? {
        get{
            guard let visibleIndexPath = visibleIndexPath else {
                return nil
            }
            let node = self._collectionNode.nodeForItem(at: visibleIndexPath) as? FeedNode
            node?.isMuted = Constants.shared.videoMuted
            return node
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollFunction(scrollView)
        }
        let bottomOffset = scrollView.contentSize.height - scrollView.bounds.size.height - scrollView.contentOffset.y

        // Define a threshold value to determine when the scrolling has reached the end.
        let threshold: CGFloat = 100.0 // You can adjust this value according to your needs.

        if bottomOffset <= threshold {
            // Scrolling has reached the end. You can perform any necessary actions here.
            print("Reached the end of collection node scrolling.")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollFunction(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollFunction(scrollView)
    }
    
    internal func scrollFunction(_ scrollView: UIScrollView){
        scrollOperation?.cancel()
        let operation = DelayedBlockOperation(deadline: .now() + 0.1, queue: .main) {
            guard let indexPath = self.visibleIndexPath, indexPath.item != self.currentIndex else {return}
            guard let node = self._collectionNode.nodeForItem(at: indexPath) as? FeedNode else {return}
            node.isMuted = Constants.shared.videoMuted
             //self.muteStatus
            self.currentIndex = indexPath.item
            print("SETCURRENTINDEX \(self.currentIndex)")
            VideoPlayerManager.shared.playVideo(in: node)
        }
        scrollOperation = operation
        operation.start()
             
    }
    
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if !isStoriesHidden && scrollView == _collectionNode.view{
//            _collectionNode.view.isScrollEnabled = false
//            UIApplication.shared.beginIgnoringInteractionEvents()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//                UIApplication.shared.endIgnoringInteractionEvents()
//            })
//            isStoriesHidden = true
//        }
//    }
}
