//
//  SelectButtonCell.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import UIKit

class SelectButtonCell: BaseTableViewCell {
    
    @IBOutlet weak var _selectButton: ASButton!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _infoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        _titleLabel.text = ""
        _infoLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setDataForFieldType(fieldType: ApplicationFields, fieldData: String?) {
        super.setDataForFieldType(fieldType: fieldType, fieldData: fieldData)
        _titleLabel.text = fieldType.headerTitle()
        _infoLabel.text = fieldData
        _selectButton.setTitle(fieldType.placeholderTitle(), for: .normal)
    }
    
    @IBAction private func selectButtonPressed(sender: ASButton) {
        if let actionCompletion = self.actionCompletion {
            actionCompletion(self, sender)
        }
    }
}
