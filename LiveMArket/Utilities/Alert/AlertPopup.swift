//
//  CongratulationPopup.swift
//  TCPF
//
//  Created by JJ on 30/12/22.
//

import UIKit

class AlertPopup: UIView {
    @IBAction func okayButtonAction(_ sender: Any) {
        dismiss()
        if let _ = okayAction {
            okayAction!()
        }
    }
    
    var okayAction: (()->())?
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var dialogueBoxView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    var message: String? {
        didSet {
            messageLabel.text = message ?? ""
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tag = 999
        
        let tapGeture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        overlayView.addGestureRecognizer(tapGeture)
        
        messageLabel.textColor = UIColor.black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc func backgroundTapped() {
        dismiss()
    }
    
    class func instanceFromNib() -> AlertPopup {
        return UINib(nibName: "AlertPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlertPopup
    }
    
    func show() {
        overlayView.alpha = 0
        dialogueBoxView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        if let oldAlert = keyWindow.viewWithTag(999) {
            oldAlert.removeFromSuperview()
        }
        keyWindow.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: keyWindow.rightAnchor).isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0.5
        })
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.dialogueBoxView.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
}
