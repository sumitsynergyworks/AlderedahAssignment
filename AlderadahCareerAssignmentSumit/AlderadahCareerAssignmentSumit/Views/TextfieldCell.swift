//
//  TextfieldCell.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import UIKit


protocol TextFeildCellDelegate {
    func textFieldEndEditingWithText(textField: UITextField, text: String)
}

class TextfieldCell: BaseTableViewCell {
    
    @IBOutlet weak var _textField: UITextField!
    @IBOutlet weak var _titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        _titleLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setDataForFieldType(fieldType: ApplicationFields, fieldData: String?) {
        super.setDataForFieldType(fieldType: fieldType, fieldData: fieldData)
        _titleLabel.text = fieldType.headerTitle()
        _textField.text = fieldData
        _textField.placeholder = fieldType.placeholderTitle()
        _textField.keyboardType = fieldType.keyboardType()
    }
}

extension TextfieldCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let actionCompletion = self.actionCompletion {
            actionCompletion(self, textField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
