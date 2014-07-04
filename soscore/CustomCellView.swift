//
//  CustomCellView.swift
//  soscore
//
//  Created by Rohit Jenveja on 6/22/14.
//  Copyright (c) 2014 Rohit Jenveja. All rights reserved.
//

import Foundation
import UIKit





class CustomCellView : UITableViewCell, UITextFieldDelegate {

    @IBOutlet var view : UIView
    @IBOutlet var textField : UITextField
    
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {

        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        
        
       // self.textField.delegate = self;
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
}
