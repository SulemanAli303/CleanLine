//
//  TimeSlotCell.swift

//
//  Created by apple on 21/10/2022.
//
import UIKit

struct TimeSlot{
    let time : String?
}

class TimeSlotCell: TableCell {
    
    var timeSlotList = [TimeSlot(time: "08:00"),
                        TimeSlot(time: "08:30"),
                        TimeSlot(time: "09:00"),
                        TimeSlot(time: "09:30"),
                        TimeSlot(time: "10:00"),
                        TimeSlot(time: "10:30"),
                        TimeSlot(time: "11:00"),
                        TimeSlot(time: "11:30"),
                        TimeSlot(time: "12:00"),
                        TimeSlot(time: "12:30"),
                        TimeSlot(time: "12:00"),
                        TimeSlot(time: "13:30")
    ]
    
    @IBOutlet weak var timeSlotCollectionView: UICollectionView!
    var cellData: TimeSlotCellData {get {return data as! TimeSlotCellData}}
    override func setupUI() {
        super.setupUI()
        self.timeSlotCollectionView.register(UINib.init(nibName: "SlotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SlotCollectionViewCell")
        self.timeSlotCollectionView.reloadData()
 
    }
    
   
    @IBAction func continueBtn(_ sender: Any) {
        //self.cellData.viewModel.continueButtonAction()
    }
    
    override func setupTheme() {
        super.setupTheme()
    }
}

class TimeSlotCellData: TableCellData {
    
    var selectedIndex: Int? = nil

    
    var viewModel: DateAndCalanderVM {get {return model as! DateAndCalanderVM}}
    init() {
        super.init(nibId: "TimeSlotCell")
    }
}
extension TimeSlotCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timeSlotList.count
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SlotCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlotCollectionViewCell", for: indexPath) as! SlotCollectionViewCell
        cell.collectionViewLb.text = timeSlotList[indexPath.row].time
        if let index = cellData.selectedIndex {
            if indexPath.row == index {
                cell.collectionViewBgImg.layer.cornerRadius = 10
                cell.collectionViewBgImg.image = UIImage.init(named: "Rectangle 17300")
                cell.collectionViewBgImg.isHidden = false
                cell.collectionViewLb.textColor = .white
            } else {
                cell.collectionViewBgImg.layer.cornerRadius = 0
                cell.collectionViewBgImg.image = UIImage.init(named: "Rectangle 17297")
                cell.collectionViewBgImg.isHidden = false
                cell.collectionViewLb.textColor = UIColor(hex: "2C4E9A")
            }
        } else {
            cell.collectionViewBgImg.layer.cornerRadius = 0
            cell.collectionViewBgImg.image = UIImage.init(named: "Rectangle 17297")
            cell.collectionViewBgImg.isHidden = false
            cell.collectionViewLb.textColor = UIColor(hex: "2C4E9A")
        }
            return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellData.selectedIndex = indexPath.row
        cellData.viewModel.selectedTime = timeSlotList[indexPath.row].time
        self.timeSlotCollectionView.reloadData()
    }
}
extension TimeSlotCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 40
        var width = UIScreen.main.bounds.width - (32 + 32)
        width = width / 3
        return CGSize(width: width, height: height)
    }
    

}
