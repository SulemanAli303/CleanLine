//
//  CommentListCell.swift
//  LiveMArket
//
//  Created by Zain on 03/02/2023.
//

import UIKit

protocol CommentProtocol{
    func replyPressed(replyID:String,userName:String)
    func likeApiCall(commentID:String)
    func profileNavigation(userID:String)
}
protocol ChildCommentProtocol{
    func replyAction(userName:String)
    func chiledLikeApiCall(commentID:String)
    func chiledProfileNavigation(userID:String)
}

class CommentListCell: UITableViewCell, ChildCommentProtocol{
    
    func chiledProfileNavigation(userID: String) {
        self.delegate?.profileNavigation(userID: userID)
    }
    
    func chiledLikeApiCall(commentID: String) {
        self.delegate?.likeApiCall(commentID: commentID)
    }
    
    func replyAction(userName: String) {
        self.delegate?.replyPressed(replyID: parentCommentID, userName: userName)
    }
    
    
    @IBOutlet weak var imageBGView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var childTableviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var childCommentTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var expendLbl: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    var pageCount = 1
    var pageLimit = 10
    var hasFetchedAll = false
    
    var delegate:CommentProtocol?
    var replyCommentArray:[CommentCollection] = []
    var parentCommentID:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        childCommentTableView.delegate = self
        childCommentTableView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var canYouDoReply: Bool? {
        didSet {
            if canYouDoReply == false {
                replyButton.isHidden = true
            }
        }
    }
    
    var commentData:CommentCollection?{
        didSet{
            setGradientBackground()
            nameLabel.text = commentData?.commentedUserName ?? ""
            expendLbl.text = commentData?.comment ?? ""
            timeLabel.text = Helper.convertTimestampFromString(timeStamp: commentData?.commentAt ?? "", short: false)
            
            userImageView.sd_setImage(with: URL(string: commentData?.commentedUserImageurl ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            replyCommentArray = commentData?.childComments ?? []
            self.childTableviewHeightConstraint.constant = CGFloat(self.replyCommentArray.count * 110)
            
            likeCountLabel.isHidden = true //Adnan-12/03/24
            likeImageView.isHidden = true //Adnan-12/03/24
            //likeCountLabel.text = "\(commentData?.likeCount ?? "0") likes"
            
//            if commentData?.isLiked == "1"{
//                likeImageView.image = UIImage(named: "likeFilled")
//            }else{
//                likeImageView.image = UIImage(named: "unlikeBorder")
//            }
            parentCommentID = commentData?.commentId ?? ""
            
            self.layoutIfNeeded()
            DispatchQueue.main.async {
                self.childCommentTableView.reloadData()
            }
        }
    }
    
    @IBAction func profileAction(_ sender: Any) {
        //self.delegate?.profileNavigation(userID: commentData?.commentedUserId ?? "") //Adnan-14-03-24
    }
    
    @IBAction func replyPressed(_ sender: UIButton) {
        self.delegate?.replyPressed(replyID: commentData?.commentId ?? "",userName: commentData?.commentedUserName ?? "")
    }
    @IBAction func likeBtnAction(_ sender: UIButton) {
        self.delegate?.likeApiCall(commentID: commentData?.commentId ?? "")
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.imageBGView.bounds
        gradientLayer.cornerRadius = self.imageBGView.bounds.width/2
        
        self.imageBGView.layer.insertSublayer(gradientLayer, at:0)
    }
    
}

extension CommentListCell: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyCommentArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChildCommentListCell", for: indexPath) as! ChildCommentListCell
        cell.commentData = replyCommentArray[indexPath.row]
        cell.canYouDoReplyInChild = self.canYouDoReply
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard indexPath.row == tableView.numberOfRows(inSection: 0) - 1 else { return }
        if  hasFetchedAll { return }
        pageCount += 1
        //getAllComments()
    }
    
}


class ChildCommentListCell: UITableViewCell {
    
    @IBOutlet weak var imageBGView: UIImageView!
    @IBOutlet weak var chiledLikeCount: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var expendLbl: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var childReplyButton: UIButton!
    var delegate:ChildCommentProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    @IBAction func profileAction(_ sender: Any) {
        //self.delegate?.chiledProfileNavigation(userID: commentData?.commentedUserId ?? "") //Adnan-14-03-24
    }
    @IBAction func replyButtonAction(_ sender: UIButton) {
        self.delegate?.replyAction(userName: commentData?.commentedUserName ?? "")
    }
    @IBAction func ChildlikeBtnAction(_ sender: UIButton) {
        self.delegate?.chiledLikeApiCall(commentID: commentData?.commentId ?? "")
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.imageBGView.bounds
        gradientLayer.cornerRadius = self.imageBGView.bounds.width/2
        
        self.imageBGView.layer.insertSublayer(gradientLayer, at:0)
    }
    func highlightHashtags(in text: String) -> NSAttributedString {
        let pattern = "@\\w+" // Regular expression pattern to match hashtags
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        // Create a mutable attributed string with the original text
        let captionText = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "#9B9B9B")]
        let attributedText = NSMutableAttributedString(string: text,attributes: captionText)
        
        // Find all matches in the text
        let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        // Apply highlighting to the matches
        let defaultFont = UIFont.systemFont(ofSize: 16)
        for match in matches {
            
            let defaultFont = UIFont(name: "Roboto-Medium", size: 12)!
            let defaultColor = Color.darkOrange.color()
            let fullRange = Range(match.range, in: text)!
            attributedText.addAttribute(.font, value: defaultFont, range: NSRange(fullRange, in: text))
            attributedText.addAttribute(.foregroundColor, value: defaultColor, range: NSRange(fullRange, in: text))
        }
        
        return attributedText
    }
    
    var canYouDoReplyInChild: Bool? {
        didSet {
            if canYouDoReplyInChild == false {
                childReplyButton.isHidden = true
            }
        }
    }
    
    var commentData:CommentCollection?{
        didSet{
            nameLabel.text = commentData?.commentedUserName ?? ""
            let attributedText = highlightHashtags(in: commentData?.comment ?? "")
            expendLbl.attributedText = attributedText
            let splits = (commentData?.comment ?? "").components(separatedBy: "@")
            print(splits)
            timeLabel.text = Helper.convertTimestampFromString(timeStamp: commentData?.commentAt ?? "", short: false)
            userImageView.sd_setImage(with: URL(string: commentData?.commentedUserImageurl ?? ""), placeholderImage: UIImage(named: "placeholder_profile"))
            
            chiledLikeCount.isHidden = true //Adnan-14/03/24
            likeImageView.isHidden = true //Adnan-14/03/24
            
            //chiledLikeCount.text = "\(commentData?.likeCount ?? "0") likes"
            
//            if commentData?.isLiked == "1"{
//                likeImageView.image = UIImage(named: "likeFilled")
//            }else{
//                likeImageView.image = UIImage(named: "unlikeBorder")
//            }
            setGradientBackground()
        }
    }
}
