//
//  ViewController.swift
//  ChatChat
//
//  Created by Vansh Badkul on 19/05/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit
import GoogleSignIn
import MediaPlayer
import NVActivityIndicatorView



class ViewController: UIViewController,GIDSignInUIDelegate,NVActivityIndicatorViewable {
    
    @IBOutlet var backgroundView: UIView!
    
    var images: [UIImage] = []
    
    var image1 = UIImage(named: "firstMessage.png")
    var image2 = UIImage(named: "secondMessage.png")
    var image3 = UIImage(named: "thirdMessage.png")
    
    var moviePlayerController = MPMoviePlayerController()
    
    
    @IBOutlet var textHeading: UILabel!
    @IBOutlet var textContent: UILabel!
    
    
    var textHeadingArray = ["Leasing Managers","Leasing Managers","Leasing Managers"]
    var textContentArray = ["Bootstrapped startup which is currently market testing its business model and idea", "Unlimited Options. Chat Discussions", "Interactive conversations"]
    
    
    @IBOutlet var pageContol: UIPageControl!


    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        GIDSignIn.sharedInstance().uiDelegate = self
        

        
        let filePath = Bundle.main.path(forResource: "black", ofType: "mp4")
        self.moviePlayerController.contentURL = URL(fileURLWithPath: filePath!)
        self.moviePlayerController.prepareToPlay()
        self.moviePlayerController.view.frame = UIScreen.main.bounds
        
        self.moviePlayerController.controlStyle = .none
        self.moviePlayerController.scalingMode = MPMovieScalingMode.fill
        self.moviePlayerController.repeatMode = MPMovieRepeatMode.one
        self.backgroundView.addSubview(self.moviePlayerController.view)
        
        var leftswap = UISwipeGestureRecognizer(target: self, action: Selector("handleSwap:"))
        var rightswap = UISwipeGestureRecognizer(target: self, action: Selector("handleSwap:"))
        
        leftswap.direction = .left
        rightswap.direction = .right
        view.addGestureRecognizer(leftswap)
        view.addGestureRecognizer(rightswap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func buttonTapped(_ sender: UIButton) {
        let size = CGSize(width: 30, height: 30)
        
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: sender.tag)!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.stopAnimating()
        }
    }

    
    func handleSwap(_ sender:UISwipeGestureRecognizer){
        if(sender.direction == .left){
            pageContol.currentPage += 1
            textHeading.text = textHeadingArray[pageContol.currentPage]
            textContent.text = textContentArray[pageContol.currentPage]
            
        }
        
        if(sender.direction == .right){
            pageContol.currentPage -= 1
            textHeading.text = textHeadingArray[pageContol.currentPage]
            textContent.text = textContentArray[pageContol.currentPage]
        }
    }
    
    
    @IBAction func slideTheScreen(_ sender: AnyObject) {
        textHeading.text = textHeadingArray[pageContol.currentPage]
        textContent.text = textContentArray[pageContol.currentPage]
    }
    
    override var prefersStatusBarHidden : Bool {
        return true;
    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        
//        
//        
//        self.view.backgroundColor = UIColor(red: CGFloat(237 / 255.0), green: CGFloat(85 / 255.0), blue: CGFloat(101 / 255.0), alpha: 1)
//        
//        let cols = 1
//        let rows = 1
//        let cellWidth = Int(self.view.frame.width / CGFloat(cols))
//        let cellHeight = Int(self.view.frame.height / CGFloat(rows))
//        
//        (NVActivityIndicatorType.ballPulse.rawValue ... NVActivityIndicatorType.audioEqualizer.rawValue).forEach {
//            let x = ($0 - 1) % cols * cellWidth
//            let y = ($0 - 1) / cols * cellHeight
//            let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
//            let activityIndicatorView = NVActivityIndicatorView(frame: frame,
//                                                                type: .ballSpinFadeLoader)
//            let animationTypeLabel = UILabel(frame: frame)
//            
//            animationTypeLabel.sizeToFit()
//            animationTypeLabel.textColor = UIColor.white
//            animationTypeLabel.frame.origin.x += 5
//            animationTypeLabel.frame.origin.y += CGFloat(cellHeight) - animationTypeLabel.frame.size.height
//            
//            activityIndicatorView.padding = 350
//            if $0 == NVActivityIndicatorType.orbit.rawValue {
//                activityIndicatorView.padding = 0
//            }
//            self.view.addSubview(activityIndicatorView)
//            self.view.addSubview(animationTypeLabel)
//            activityIndicatorView.startAnimating()
//            
//            let button: UIButton = UIButton(frame: frame)
//            button.addTarget(self,
//                             action: #selector(buttonTapped(_:)),
//                             for: UIControlEvents.touchUpInside)
//            self.view.addSubview(button)
//            
//        }
//
//        
//    }

}


