//
//  FeedsViewModel.swift
//  LiveMArket
//
//  Created by Greeniitc on 02/06/23.
//

import UIKit

protocol ObservableProtocol : AnyObject {
    var observers : [ObserverProtocol] { get set }

    func addObserver(_ observer: ObserverProtocol)
    func removeObserver(_ observer: ObserverProtocol)
    func notifyObservers(_ observers: [ObserverProtocol])
}
protocol ObserverProtocol {

    var id : Int! { get set }
    func onSocketConnect(_ status: Bool)
    func newPost(_ post: [FeedPost_Base])
}

class FeedsViewModel: NSObject {
    func newPost(_ post: [FeedPost_Base]) {
        
    }
    

    var id : Int!
    func onSocketConnect(_ status: Bool) {
        // we added / remove item to cart
        print("new numbers \(status)")
    }
}
class Observable<T> : ObservableProtocol {

    var value : T? {
        didSet {
            self.notifyObservers(self.observers)
        }
    }
    typealias CompletionHandler = ((T) -> Void)
    internal var observers : [ObserverProtocol] = []

    init(value: T?) {
        self.value = value
    }

    func addObserver(_ observer: ObserverProtocol) {
        guard self.observers.contains(where: { $0.id == observer.id }) == false else {
            return
        }
        self.observers.append(observer)
    }

    func removeObserver(_ observer: ObserverProtocol) {
        guard let index = self.observers.firstIndex(where: { $0.id == observer.id }) else {
            return
        }
        self.observers.remove(at: index)

    }

    func notifyObservers(_ observers: [ObserverProtocol]) {
        observers.forEach({ $0.onSocketConnect(true)})
    }

    func notifySocketConnect(){
        print("SOCKET NOTIFIY \(self.observers)")
        self.notifyObservers(self.observers)
    }
    
    func notifyObserversNewPost(_ observers: [ObserverProtocol],_ post: [FeedPost_Base]) {
        observers.forEach({ $0.newPost(post)})
    }
    func notifyNewPost(post: [FeedPost_Base]) {
        self.notifyObserversNewPost(self.observers, post)
    }
    
    deinit {
        observers.removeAll()
    }
}
