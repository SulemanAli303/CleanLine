//
//  BookingDetailsVC.swift
//  LiveMArket
//
//  Created by Zain on 17/01/2023.
//

import UIKit
import FloatRatingView


class BookingDetailsVC: BaseViewController {
    @IBOutlet var floatRatingView: FloatRatingView!
    @IBOutlet var tbl: IntrinsicallySizedTableView!
    @IBOutlet weak var payCollection: IntrinsicCollectionView!
    
    @IBOutlet weak var paymentTypeView: UIView!
    @IBOutlet weak var paymentMethodsView: UIView!
    @IBOutlet weak var submitReviewView: UIStackView!
    @IBOutlet weak var deliveryDetailView: UIStackView!
    
    
    @IBOutlet weak var StatusView: UIView!
    @IBOutlet weak var StatusImg: UIView!
    @IBOutlet weak var StatuLbl: UILabel!
    @IBOutlet weak var paymentTypeLbl: UILabel!

    @IBOutlet weak var rattingView: UIStackView!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var verificationView: UIStackView!
    
    
    @IBOutlet weak var activity: UIActivityIndicatorView!

    @IBOutlet weak var productListLabel: UILabel!
    @IBOutlet weak var receivngOptionLabel: UILabel!
    @IBOutlet weak var requestDelegateLabel: UILabel!
    @IBOutlet weak var mediumTruckLabel: UILabel!
    @IBOutlet weak var assignRepLabel: UILabel!
    
    
    var VCtype :String?
    var step = "1"
    @IBOutlet weak var scroller: UIScrollView!
    
    
    @IBOutlet weak var btnStatus: UIButton!

    
    
    

    //var imageArray = [UIImage(named: "visaPayment"),UIImage(named: "madaPayment"),UIImage(named: "PayPal"),UIImage(named: "ApplePayment"),UIImage(named: "Stc_Payment"),UIImage(named: "tamaraPayment")]
    var imageArray = [UIImage(named: "visaPayment"),UIImage(named: "ApplePayment")]
    
    var selectedIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        viewControllerTitle = ""
        scroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)

        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
        setData()
        setPayCollectionCell()
        
        if VCtype == "paid"
        {
            paymentTypeView.isHidden = false
            paymentMethodsView.isHidden = true
            submitReviewView.isHidden = false
            deliveryDetailView.isHidden = false
        }else if VCtype == "2"
        {
            self.StatusView.backgroundColor = UIColor(hex: "#F57070")
            self.StatusImg.backgroundColor = UIColor(hex: "#F57070")
            self.StatuLbl.text = "Order Confirmed".localiz()
            paymentMethodsView.isHidden = false
        }
        else if VCtype == "3"
        {
            self.StatusView.backgroundColor = UIColor(hex: "#5795FF")
            self.StatusImg.backgroundColor = UIColor(hex: "#5795FF")
            self.StatuLbl.text = "Preparing Order".localiz()
            paymentMethodsView.isHidden = true
        }
        else if VCtype == "4"
        {
            self.StatusView.backgroundColor = UIColor(hex: "#5795FF")
            self.StatusImg.backgroundColor = UIColor(hex: "#5795FF")
            self.StatuLbl.text = "On the way".localiz()
            paymentMethodsView.isHidden = true
            submitReviewView.isHidden = false
        }
        else if VCtype == "5"
        {
            self.StatusView.backgroundColor = UIColor(hex: "#00B24D")
            self.StatusImg.isHidden = true
            activity.isHidden = true
            self.StatuLbl.text = "   Order Delivered  ".localiz()
            paymentMethodsView.isHidden = true
            submitReviewView.isHidden = false
            numberLbl.isHidden = true
            rattingView.isHidden = false
            deliveryDetailView.isHidden = false
            verificationView.isHidden = true
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabbar = tabBarController as? TabbarController
        if VCtype != "5"
        {
            tabbar?.hideTabBar()
        }else {
            tabbar?.showTabBar()
        }
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let tabbar = tabBarController as? TabbarController
        tabbar?.showTabBar()
    }

    @IBAction func statsAction(_ sender: UIButton) {
        if (VCtype == "1"){
            ShopCoordinator.goToBookingDetail(controller: self, VCtype: "2")
        }
        if (VCtype == "2"){
            Coordinator.goTThankYouPage(controller: self,vcType: "3", invoiceId: "",order_id: "",isFromFoodStore: false)
        }
        if (VCtype == "3"){
            ShopCoordinator.goToBookingDetail(controller: self, VCtype: "4")
        }
        if (VCtype == "4"){
            ShopCoordinator.goToBookingDetail(controller: self, VCtype: "5")
        }
    }
    
    @IBAction func reviewPressed(_ sender: UIButton) {
        
        ShopCoordinator.goToRateVC(controller: self)
    }
    @IBAction func payNow(_ sender: UIButton) {
        
        Coordinator.goTThankYouPage(controller: self,vcType: "3", invoiceId: "",order_id: "",isFromFoodStore: false)
    }
    func setData() {
        self.tbl.delegate = self
        self.tbl.dataSource = self
        self.tbl.separatorStyle = .none
        self.tbl.register(BookingProductCell.nib, forCellReuseIdentifier: BookingProductCell.identifier)
        tbl.reloadData()
        self.tbl.layoutIfNeeded()
    }
    func setPayCollectionCell() {
        payCollection.delegate = self
        payCollection.dataSource = self
        payCollection.register(UINib.init(nibName: "PaymentMethodsCell", bundle: nil), forCellWithReuseIdentifier: "PaymentMethodsCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.payCollection.collectionViewLayout = layout
        
    }

}
// MARK: - TableviewDelegate
extension BookingDetailsVC : UITableViewDelegate ,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notificationCell = self.tbl.dequeueReusableCell(withIdentifier: BookingProductCell.identifier, for: indexPath) as! BookingProductCell
        
        notificationCell.countView.isHidden = true
        
        notificationCell.selectionStyle = .none
        return notificationCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
extension BookingDetailsVC: UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaymentMethodsCell", for: indexPath) as? PaymentMethodsCell else
            { return UICollectionViewCell()
            }
        
        cell.image.image = imageArray[indexPath.row]
        
        if indexPath.row == self.selectedIndex {
            cell.checkBoxBtn.setImage(UIImage(named: "Group 236139"), for: .normal)
        } else {
            cell.checkBoxBtn.setImage(UIImage(named: "Ellipse 1449"), for: .normal)
        }
            return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width-40
        return CGSize(width: screenWidth/2, height:70)
                
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.selectedIndex == indexPath.row {
                  self.selectedIndex = -1
              }
              else {
                  self.selectedIndex = indexPath.row
              }
              self.payCollection.reloadData()
    }
}

