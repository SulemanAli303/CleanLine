//
//  FoodDetailsViewController.swift
//  LiveMArket
//
//  Created by Rupesh E on 21/08/23.
//

import UIKit
import SDWebImage
import Cosmos
import ImageSlideshow

class FoodDetailsViewController: BaseViewController {
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var subNameLbl: UILabel!
    @IBOutlet weak var sliderView: ImageSlideshow!
    
    var productID :String = ""
    
    var localSource : [AlamofireSource] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        type = .transperantBack

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getFoodProductDetailsAPI()
    }
    
    var foodData:FoodProductData?{
        didSet{
            print("sdsdsd")
            viewControllerTitle = foodData?.product_details?.product_name ?? ""
            nameLbl.text = foodData?.product_details?.product_name ?? ""
            subNameLbl.text = "\(foodData?.currency_code ?? "") \(foodData?.product_details?.sale_price ?? "")"
            myImage.sd_setImage(with: URL(string: foodData?.product_details?.default_image ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder_banner"))
            self.configerSlider(imageArray: foodData?.product_details?.product_images ?? [])
        }
    }
    
    /// Image Slider
    /// - Parameter imageArray: image array
    func configerSlider(imageArray:[String]) {
        localSource.removeAll()
        for imageUrl in imageArray {
            if let url = URL(string: imageUrl){
                localSource.append(contentsOf: [AlamofireSource(url: url, placeholder: UIImage(named: ""))])
            }
        }
        sliderView.slideshowInterval = 3.0
        sliderView.zoomEnabled = false
        // sliderView.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 5))
        sliderView.contentScaleMode = UIViewContentMode.scaleAspectFill
        //sliderView.activityIndicator = DefaultActivityIndicator()
        sliderView.setImageInputs(localSource)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func getFoodProductDetailsAPI() {
        let parameters:[String:String] = [
            "access_token" : SessionManager.getAccessToken() ?? "",
            "product_id" : productID
        ]
        print(parameters)
        FoodAPIManager.foodDetailsAPI(parameters: parameters) { result in
            switch result.status{
            case "1" :
                self.foodData = result.oData
            default:
                Utilities.showWarningAlert(message: result.message ?? ""){
                    
                }
            }
        }
    }
}
