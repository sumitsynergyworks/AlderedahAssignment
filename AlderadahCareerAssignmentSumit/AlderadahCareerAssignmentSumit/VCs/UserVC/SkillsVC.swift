//
//  SkillsVC.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 05/09/22.
//

import UIKit

protocol SkillVCDelegate {
    func selectedSkills(skills: [String], fromVC vc: SkillsVC)
    func cancelSkillSelection(vc: SkillsVC)
}

extension SkillVCDelegate {
    func cancelSkillSelection(vc: SkillsVC) {
        
    }
}

class SkillsVC: BaseViewController {
    @IBOutlet private weak var _tableView: UITableView!

    var selectedSkills: Set = Set<String>()
    
    var delegate: SkillVCDelegate?
    
    private var _allSkills: Set = Set<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _resetSillsAndReloadTable()
        
        // Do any additional setup after loading the view.
    }
    
    private func _resetSillsAndReloadTable() {
        let allPredefinedSkills = Skills.allSkills
        
        for i in selectedSkills {
            _allSkills.insert(i)
        }
        
        for i in allPredefinedSkills {
            _allSkills.insert(i.rawValue)
        }
        
        DispatchQueue.main.async {
            self._tableView.reloadData()
        }
    }
    
    private func _addSkillInSelectedSet(skill: String) {
        selectedSkills.insert(skill)
        _resetSillsAndReloadTable()
    }
    
    private func _removeSkillFromSelectedSet(skill: String) {
        if selectedSkills.contains(skill) {
            selectedSkills.remove(skill)
            _resetSillsAndReloadTable()
        }
    }
    
    @IBAction private func doneButtonPressed(sender: AnyObject?) {
        if let delegate = delegate {
            delegate.selectedSkills(skills: Array(selectedSkills), fromVC: self)
        }
        dismiss(animated: true)
    }
    
    @IBAction private func cancelButtonPressed(sender: AnyObject?) {
        if let delegate = delegate {
            delegate.cancelSkillSelection(vc: self)
        }
        dismiss(animated: true)
    }
}

extension SkillsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _allSkills.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        }
        
        cell?.accessoryType = .none

        if (indexPath.row < _allSkills.count) {
            let skil = Array(_allSkills)[indexPath.row]
            
            cell?.textLabel?.text = skil
            
            if selectedSkills.contains(skil) {
                cell?.accessoryType = .checkmark
            }
        } else {
            cell?.textLabel?.text = "Other"
        }
        
        cell?.tintColor = UIColor.ThemeBlueColor()
        
        return cell!
    }
}

extension SkillsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row < _allSkills.count) {
            let skil = Array(_allSkills)[indexPath.row]

            if selectedSkills.contains(skil) {
                _removeSkillFromSelectedSet(skill: skil)
            } else {
                _addSkillInSelectedSet(skill: skil)
            }
        } else {
            let alertController = UIAlertController(title: "Add Skill", message: "", preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Enter Name"
                }
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: {[unowned self] alert -> Void in
                let firstTextField = alertController.textFields![0] as UITextField
                if let skil = firstTextField.text , !skil.isEmpty {
                    self._addSkillInSelectedSet(skill: skil)
                }
            })
            let cancelAction = UIAlertAction(title: StringConstants.CANCEL, style: .destructive, handler: {(action : UIAlertAction!) -> Void in })
                
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
                
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
