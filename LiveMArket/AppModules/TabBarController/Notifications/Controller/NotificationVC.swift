
//
//  Notifications.swift
//  Nutrio
//
//  Created by Zain on 10/03/2022.
//



import UIKit
import FirebaseDatabase

class NotificationVC: BaseViewController, Refreshable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBAction func clearAllAction() {
        showClearNotificationsAlert()
    }
    
    var refreshControl: UIRefreshControl?
    
    @IBOutlet weak var clearAllStackView: UIView!
    let refNotifications = Database.database().reference().child("Nottifications")
    var notificationArray: [NotificationModel] = []
    
    var hasFetchedOnce = false
    var lastKey: String?
    var hasFetchedAll = false
    var isFetching = false
    
    var userData: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = .notifications
        viewControllerTitle = "Notifications"
        NotificationCenter.default.addObserver(self, selector: #selector(orderStatusChanged), name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
        
        // tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        
        userData = SessionManager.getUserData()
        installRefreshControl()
        
        
    }
    override func clearAll() {
        showClearNotificationsAlert()
    }
    func setNotification() {
        // tableView.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: "NotificationsCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
        self.tableView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refreshNotifications()
        setNotification()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "OrderStatusChanged"), object: nil)
    }
    
    func handleRefresh(_ sender: UITableView) {
        refreshControl?.endRefreshing()
        refreshNotifications()
    }
    @objc func orderStatusChanged() {
        fetchNotifications()
    }
    
    func refreshNotifications() {
        lastKey = nil
        notificationArray.removeAll()
        tableView.reloadData()
        fetchNotifications()
    }
    
    @objc func fetchNotifications() {
        Utilities.showIndicatorView()
        
        isFetching = true
        
        tableView.reloadData()
        
        guard let userId = userData?.firebase_user_key, userId != "" else {
            Utilities.hideIndicatorView()
            self.tableView.reloadData()
            return
            
        }
        
        var query = DatabaseQuery()
        if let last = lastKey {
            query = refNotifications.child(userId).queryOrderedByKey().queryEnding(atValue: last).queryLimited(toLast: 11)
        } else {
            query = refNotifications.child(userId).queryOrderedByKey().queryLimited(toLast: 11)
        }
        
        query.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let `self` = self else { return }
            Utilities.hideIndicatorView()
            guard snapshot.exists(), let notifications = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Child does not exist")
                self.hasFetchedOnce = true
                self.isFetching = false
                self.tableView.reloadData()
                return
            }
            
            if snapshot.childrenCount < 11 {
                self.hasFetchedAll = true
            }
            
            var tempNotifications: [NotificationModel] = []
            
            for item in notifications {
                guard let value = item.value as? [String: Any] else { continue }
                do {
                    let json = try JSONSerialization.data(withJSONObject: value)
                    let notification = try JSONDecoder().decode(NotificationModel.self, from: json)
                    notification.key = item.key
                    tempNotifications.insert(notification, at: 0)
                } catch {
                    
                }
            }
            
            self.hasFetchedOnce = true
            self.isFetching = false
            
            self.lastKey = tempNotifications.last?.key
            
            if !self.hasFetchedAll {
                tempNotifications.removeLast()
            }
            
            self.notificationArray.append(contentsOf: tempNotifications)
            self.tableView.reloadData()
            
        })
    }
    
    func showClearNotificationsAlert() {
        Utilities.showQuestionAlert(message: "Are you sure want to clear all notifications?") { [weak self] in
            self?.clearNotifications()
        }
    }
    
    func clearNotifications() {
        guard let userId = userData?.firebase_user_key else { return }
        self.refNotifications.child(userId).setValue(nil)
        notificationArray.removeAll()
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
    }
    
    func removeNotification(index: Int) {
        guard let userId = userData?.firebase_user_key else { return }
        guard let notificationId = notificationArray[index].key else { return }
        refNotifications.child(userId).child(notificationId).removeValue()
        notificationArray.remove(at: index)
        if notificationArray.count == 0 {
            //   clearAllStackView.isHidden = true
        }
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    
    
}
extension NotificationVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard notificationArray.count != 0 else {
            if isFetching {
                tableView.backgroundView = nil
            } else {
                //self.viewEmpty.isHidden = false
                
                tableView.setEmptyView(title: "", message: "You have no Notifications", image: UIImage(named: "undraw_push_notifications_re_t84m 1"))
                
            }
            self.navigationItem.rightBarButtonItem?.customView?.alpha = 0.0
            return 0
        }
        tableView.backgroundView = nil
        self.navigationItem.rightBarButtonItem?.customView?.alpha = 1.0
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard notificationArray.indices.contains(indexPath.row) else { return UITableViewCell() }
        let notification = notificationArray[indexPath.row]
        let notificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
        notificationCell.notification = notification
        notificationCell.removeAction = { [weak self] selectedCell in
            guard let `self` = self else { return }
            if let indexPath = tableView.indexPath(for: selectedCell) {
                self.removeNotification(index: indexPath.row)
            }
        }
        
        if let read = notification.read, read == "0", let key = notification.key, let userId = userData?.firebase_user_key {
            refNotifications.child(userId).child(key).child("read").setValue("1")
            refNotifications.child(userId).child(key).child("showPopup").setValue("0")
           
        }
        notificationCell.selectionStyle = .none
        return notificationCell
    }
}

extension NotificationVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notificationArray[indexPath.row]
        if notification.type == "live_story" {
            Coordinator.goToPostComment(controller: self)
            return
        }
        if notification.type == "user_follow" {
            guard let userID = notification.follow_id else { return }
            Coordinator.goToIndvidualSellerFlow(controller: self, step: userID)
        }
        switch notification.notificationType?.lowercased() {
        case "new_table_booking_placed_store","table_booking_accepted_store","table_booking_rejected_store","table_booking_completed_store":
            Coordinator.goToTableRequest(controller: self,bookID: notification.orderId ?? "",isFromReceved: true,isFromPopup: false)
        case "new_table_booking_placed_user","table_booking_accepted_user","table_booking_rejected_user","table_booking_completed_user":
            Coordinator.goToTableRequest(controller: self,bookID: notification.orderId ?? "",isFromReceved: false,isFromPopup: false)
        case "food_order_accepted","food_order_ready_for_delivery","food_order_dispatched","food_order_delivered","food_order_cancelled","food_order_returned","food_order_rejected","food_order_payment_completed","food_driver_order_delivered","food_driver_new_order":
            
            if notification.notificationType == "food_order_delivered"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: notification.invoiceId, isSeller: false, isThankYouPage: false,isFromNotify: true)
                        }else{
                            SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: notification.invoiceId, isSeller: false, isThankYouPage: false)
                        }
                    }
                })
            }else{
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: notification.invoiceId, isSeller: false, isThankYouPage: false)
            }
            
            
        case "food_new_order","food_store_order_payment_completed","food_store_order_delivered","food_store_order_cancelled","food_store_order_returned","food_store_driver_accepted","food_store_driver_dispatched":
            
            if notification.notificationType == "food_store_order_delivered"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: notification.orderId, isSeller: true, isThankYouPage: false,isFromNotify: true)
                        }else{
                            SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: notification.orderId, isSeller: true, isThankYouPage: false)
                        }
                    }
                })
            }else{
                SellerOrderCoordinator.goToFoodOrderDetail(controller: self, orderId: notification.orderId, isSeller: true, isThankYouPage: false)
            }
            
        case "food_driver_order_accepted","food_driver_order_dispatched":
            //guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
            VC.order_ID = notification.orderId ?? ""
            self.navigationController?.pushViewController(VC, animated: true)
        case "order_placed","order_accepted", "order_ready_for_delivery", "order_dispatched","order_delivered","order_cancelled", "order_returned", "order_rejected","order_payment_completed":
            //guard let orderId = notification.userInfo?["orderId"] as? String else { return }
            if notification.notificationType == "order_delivered"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: notification.orderId,isSeller: false, isThankYouPage: false,isFromNotify: true)
                        }else{
                            SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: notification.orderId,isSeller: false, isThankYouPage: false)
                        }
                    }
                })
            }else{
                SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: notification.orderId,isSeller: false, isThankYouPage: false)
            }
            //SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: notification.orderId,isSeller: false, isThankYouPage: false)
        case "new_order", "store_order_payment_completed", "store_order_delivered","store_order_cancelled","store_order_returned","store_order_accepted_driver","store_order_dispatched":
            
            if notification.notificationType == "store_order_delivered" || notification.notificationType == "store_order_dispatched"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: notification.orderId,isSeller: true, isThankYouPage: false,isFromNotify: true)
                        }else{
                            SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: notification.orderId,isSeller: true, isThankYouPage: false)
                        }
                    }
                })
            }else{
                SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: notification.orderId,isSeller: true, isThankYouPage: false)
            }
        case "driver_new_order", "driver_order_delivered":
            let  VC = AppStoryboard.DriverOrderDetails.instance.instantiateViewController(withIdentifier: "DriverOrderDetailsViewController") as! DriverOrderDetailsViewController
            VC.order_ID = notification.orderId ?? ""
            self.navigationController?.pushViewController(VC, animated: true)
            
        case "deligate_new_order", "deligate_request_accepted", "deligate_waiting_for_payment","deligate_payment_completed","deligate_service_on_the_way", "deligate_service_completed":
            
            if notification.notificationType == "deligate_service_completed"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: notification.orderId,isFromNotify: true)
                        }else{
                            Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: notification.orderId)
                        }
                    }
                })
            }else{
                Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: notification.orderId)
            }
            
            
          //  SellerOrderCoordinator.goToSellerBookingDetail(controller: self,orderId: notification.orderId,isSeller: true, isThankYouPage: false)
        case "new_service_request_placed","quote_added_by_seller","quote_accepted_user","on_the_way_user","work_started_user","work_completed_user","payment_completed_user","service_request_rejected_by_seller","work_finished_user":
            if notification.notificationType == "work_finished_user"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            Coordinator.goToServiceRequestDetails(controller: self,serviceID:notification.orderId,isFromNotify: true )
                        }else{
                            Coordinator.goToServiceRequestDetails(controller: self,serviceID:notification.orderId )
                        }
                    }
                })
            }else{
                Coordinator.goToServiceRequestDetails(controller: self,serviceID:notification.orderId )
            }
            
            
        case "payment_completed","new_service_request","service_request_rejected","quote_added","quote_accepted","on_the_way","work_started","work_completed","work_finished":
            
            if notification.notificationType == "work_finished"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            Coordinator.goToServicProviderDetail(controller: self, step: "", serviceId: notification.orderId, isFromThank: true,isFromNotify: true)
                        }else{
                            Coordinator.goToServicProviderDetail(controller: self, step: "", serviceId: notification.orderId, isFromThank: true)
                        }
                    }
                })
            }else{
                Coordinator.goToServicProviderDetail(controller: self, step: "", serviceId: notification.orderId, isFromThank: true)
            }
        case "user_new_chalet_booking","user_confirmed_chalet_booking","user_wait_for_schedule_chalet_booking","user_reserved_chalet_booking","user_completed_chalet_booking","user_rejected_chalet_booking","user_reviews_submitted" :
            
            if notification.notificationType == "user_completed_chalet_booking"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            Coordinator.goToChaletRequestDetails(controller: self,step: "1",chaletID: notification.orderId,isFromNotify: true)
                        }else{
                            Coordinator.goToChaletRequestDetails(controller: self,step: "1",chaletID: notification.orderId)
                        }
                    }
                })
            }else{
                Coordinator.goToChaletRequestDetails(controller: self,step: "1",chaletID: notification.orderId)
            }
            
        case "new_chalet_booking",
            "confirmed_chalet_booking",
            "wait_for_schedule_chalet_booking",
            "reserved_chalet_booking",
            "completed_chalet_booking",
            "rejected_chalet_booking"    :
            
            if notification.notificationType == "completed_chalet_booking"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            Coordinator.goToChaletsReservationRequest(controller: self, VCtype: "",chaletID: notification.orderId,isFromNotify: true)
                        }else{
                            Coordinator.goToChaletsReservationRequest(controller: self, VCtype: "",chaletID: notification.orderId)
                        }
                    }
                })
            }else{
                Coordinator.goToChaletsReservationRequest(controller: self, VCtype: "",chaletID: notification.orderId)
            }
            
        case "gym_subscription_completed_user","gym_subscription_user":
            
            if notification.notificationType == "gym_subscription_completed_user"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
                            VC.subscriptionID = notification.orderId ?? ""
                            VC.isFromReceivedSubscription = false
                            VC.isFromNotification = true
                            self.navigationController?.pushViewController(VC, animated: true)
                        }else{
                            let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
                            VC.subscriptionID = notification.orderId ?? ""
                            VC.isFromReceivedSubscription = false
                            self.navigationController?.pushViewController(VC, animated: true)
                        }
                    }
                })
            }else{
                let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
                VC.subscriptionID = notification.orderId ?? ""
                VC.isFromReceivedSubscription = false
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
            
        
        case "gym_subscription_completed","new_gym_subscription":
            
            if notification.notificationType == "gym_subscription_completed"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
                            VC.subscriptionID = notification.orderId ?? ""
                            VC.isFromReceivedSubscription = true
                            VC.isFromNotification = true
                            self.navigationController?.pushViewController(VC, animated: true)
                        }else{
                            let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
                            VC.subscriptionID = notification.orderId ?? ""
                            VC.isFromReceivedSubscription = true
                            self.navigationController?.pushViewController(VC, animated: true)
                        }
                    }
                })
            }else{
                let  VC = AppStoryboard.GymBooking.instance.instantiateViewController(withIdentifier: "GymRequstDetails") as! GymRequstDetails
                VC.subscriptionID = notification.orderId ?? ""
                VC.isFromReceivedSubscription = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
            
        case "deligate_new_order_driver",
            "deligate_request_accepted_driver",
            "deligate_payment_completed_driver",
            "deligate_service_on_the_way_driver",
            "deligate_service_completed_driver" :
            
            if notification.notificationType == "deligate_service_completed_driver" {
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: notification.orderId,isDriver: true,isFromNotify: true)
                        }else{
                            Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: notification.orderId,isDriver: true)
                        }
                    }
                })
            }else{
                Coordinator.goToServiceDelegateRequestDetails(controller: self,step: "1",serviceID: notification.orderId,isDriver: true)
            }
            
        case "new_hotel_booking",
            "confirmed_hotel_booking",
            "wait_for_schedule_hotel_booking",
            "reserved_hotel_booking",
            "completed_hotel_booking",
            "rejected_hotel_booking",
            "cancelled_hotel_booking":
        
            if notification.notificationType == "completed_hotel_booking"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: true,booking_ID: notification.orderId ?? "" )
                        }else{
                            Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: true,booking_ID: notification.orderId ?? "" )
                        }
                    }
                })
            }else{
                Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: true,booking_ID: notification.orderId ?? "" )
            }
            
        case "user_new_hotel_booking",
            "user_confirmed_hotel_booking",
            "user_wait_for_schedule_hotel_booking",
            "user_reserved_hotel_booking",
            "user_completed_hotel_booking",
            "user_rejected_hotel_booking",
            "user_cancelled_hotel_booking":
        
            if notification.notificationType == "user_completed_hotel_booking"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: false,booking_ID: notification.orderId ?? "",isFromNotify: true )
                        }else{
                            Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: false,booking_ID: notification.orderId ?? "" )
                        }
                    }
                })
            }else{
                Coordinator.goToHotelBookingDetail(controller: self,isFromReceive: false,booking_ID: notification.orderId ?? "" )
            }
           
        
        case "user_new_playground_booking",
            "user_confirmed_playground_booking",
            "user_wait_for_schedule_playground_booking",
            "user_reserved_playground_booking",
            "user_completed_playground_booking",
            "user_rejected_playground_booking",
            "user_cancelled_playground_booking":
        
            if notification.notificationType == "user_completed_playground_booking"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: false,booking_ID: notification.orderId ?? "",isFromNotify: true)
                        }else{
                            PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: false,booking_ID: notification.orderId ?? "")
                        }
                    }
                })
            }else{
                PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: false,booking_ID: notification.orderId ?? "")
            }
            
            
        case "new_playground_booking",
            "confirmed_playground_booking",
            "wait_for_schedule_playground_booking",
            "reserved_playground_booking",
            "completed_playground_booking",
            "rejected_playground_booking",
            "cancelled_playground_booking":
        
            if notification.notificationType == "completed_playground_booking"{
                let refUserData = refNotifications.child(userData?.firebase_user_key ?? "").child(notificationArray[indexPath.row].key ?? "").child("showPopup")
                refUserData.observeSingleEvent(of: .value, with: { snapshot in
                    if let value = snapshot.value as? String{
                        if snapshot.value as? String == "0"{
                            refUserData.setValue("1")
                            PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: true,booking_ID: notification.orderId ?? "",isFromNotify: true)
                        }else{
                            PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: true,booking_ID: notification.orderId ?? "")
                        }
                    }
                })
            }else{
                PlayGroundCoordinator.goToBookingDetail(controller: self,isFromReceive: true,booking_ID: notification.orderId ?? "")
            }
            
            
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
        if !hasFetchedAll && !isFetching {
            fetchNotifications()
        }
    }
}
