//
//  SpinnerView.swift
//  streamAndSave
//
//  Created by Molly Tian on 12/27/16.
//  Copyright © 2016 Molly Tian. All rights reserved.
//

import UIKit

class SpinnerView: UIView {

    //MARK: - Accessors

    lazy var spinner: UIActivityIndicatorView = {
       
        var spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        spinner.startAnimating()
        
        return spinner
    }()
    
    //MARK - Init
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubview(spinner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
}
