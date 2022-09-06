//
//  BaseTableViewCell.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import UIKit

extension UITableViewCell {
    static func identifier() -> String {
        let myName = String(describing: self)
        return myName
    }
}

typealias ClickCompletionBlock = (BaseTableViewCell, Any?) -> Void

class BaseTableViewCell: UITableViewCell, CellSetDataMethod {
    
    var actionCompletion: ClickCompletionBlock?
    
    func setDataForFieldType(fieldType: ApplicationFields, fieldData: String?) {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
