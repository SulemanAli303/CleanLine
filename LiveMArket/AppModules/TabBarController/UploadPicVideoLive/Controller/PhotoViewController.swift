

import UIKit

class PhotoViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var backgroundImage: UIImage
    
    init(image: UIImage) {
        self.backgroundImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFit
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(UIImage(named: "close"), for: UIControl.State())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let cancelButton1 = UIButton(frame: CGRect(x: 10.0, y: 60.0, width: 30.0, height: 30.0))
        cancelButton1.setImage(UIImage(named: "close"), for: UIControl.State())
        cancelButton1.addTarget(self, action: #selector(added), for: .touchUpInside)
        view.addSubview(cancelButton1)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    @objc func added() {
        Coordinator.goToSubmitPictureVideo(controller: self, isTakePicture: true, isLive: false)
    }
}
