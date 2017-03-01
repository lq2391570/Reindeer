//
//  TextFieldCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/9.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
class TextFieldCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet var jvTextField: JVFloatLabeledTextField!
    //textField代理闭包
    var textFieldDelegateColsure :((UITextField) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        jvTextField.floatingLabelFont = UIFont.systemFont(ofSize: 16)
        jvTextField.delegate = self
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textFieldDelegateColsure != nil) {
            textFieldDelegateColsure!(textField)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        if (textFieldDelegateColsure != nil) {
            textFieldDelegateColsure!(textField)
        }
        
        
    }
    
}
