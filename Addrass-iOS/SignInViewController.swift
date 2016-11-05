//
//  SignInViewController.swift
//  Addrass-iOS
//
//  Created by Yauheni Chasavitsin on 06/11/16.
//  Copyright © 2016 bsu. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftGifOrigin

class SignInViewController: UIViewController {
    
    var iconImageView: UIImageView?
    var tagTextField: UITextField?
    var againButton: UIButton?
    
    var currentRequest: DataRequest?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Login"
        self.view.backgroundColor = UIColor.green
        
        self.iconImageView = UIImageView()
        self.iconImageView?.backgroundColor = UIColor.clear
        self.iconImageView?.contentMode = .scaleAspectFit
        self.view.addSubview(self.iconImageView!)
        
        self.iconImageView?.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10.0)
            make.left.right.equalTo(self.view).inset(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))
            make.width.equalTo(self.iconImageView!.snp.height)
        }
        
        self.againButton = UIButton(type: .roundedRect)
        self.againButton?.setTitle("Again", for: .normal)
        self.againButton?.addTarget(self, action: #selector(setImage), for: .touchUpInside)
        self.againButton?.setContentHuggingPriority(500, for: .horizontal)
        self.view.addSubview(self.againButton!)
        
        self.againButton?.snp.makeConstraints { (make) in
            make.right.equalTo(self.iconImageView!)
            make.top.equalTo(self.iconImageView!.snp.bottom).offset(10.0)
        }
        
        self.tagTextField = UITextField()
        self.tagTextField?.placeholder = "Enter tag"
        self.tagTextField?.borderStyle = .roundedRect
        self.tagTextField?.backgroundColor = UIColor.white
        self.tagTextField?.setContentHuggingPriority(400, for: .horizontal)
        self.view.addSubview(self.tagTextField!)
        
        self.tagTextField?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.iconImageView!)
            make.top.equalTo(self.againButton!)
            make.right.equalTo(self.againButton!.snp.left).offset(-10.0)
        })
        
    }
    
    
    func setImage(sender: UIButton?) {
        self.iconImageView!.image = nil
        
        if let imageRequest = self.currentRequest {
            imageRequest.cancel()
            self.currentRequest = nil
        }
        
        var tagText: String!
        
        if let trueText = self.tagTextField?.text {
            tagText = trueText
        } else {
            tagText = "404"
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.currentRequest = Alamofire.request(
            "http://api.giphy.com/v1/gifs/random", parameters: [
                "api_key": "dc6zaTOxFJmzC",
                "tag": tagText
            ]).responseJSON { (response) in
                let responseDict = response.result.value as! Dictionary<String, AnyObject>
                let imageURL = responseDict["data"]!["image_url"] as! String
                Alamofire.request(imageURL).responseData(completionHandler: { (response) in
                    self.iconImageView!.image = UIImage.gif(data: response.data!)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
        }
    }


}
