//
//  ApplyJobVC.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 04/09/22.
//

import UIKit
import UniformTypeIdentifiers
import CoreServices

class ApplyJobVC: BaseViewController {
    
    @IBOutlet private weak var _tableView: UITableView!
    
    var filledData = [ApplicationFields : String]()
    private var _selectedSkill = [String]() {
        didSet {
            _tableView.reloadData()
        }
    }
    
    private var _resumeFileUrl: URL? {
        didSet {
            _tableView.reloadData()
        }
    }
    
    private var _uploadFileInfo: UploadFile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Apply for Job"
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func applyForJob(sender: Any?) {
        let keys = filledData.keys
        if keys.contains(.email) , keys.contains(.firstName), keys.contains(.lastName), keys.contains(.mobileNumber) {
            WebRequests.addApplication(dataInfo: filledData, resumeInfo: _uploadFileInfo, skills: _selectedSkill) { [weak self] application, errorString in
                if let welf = self {
                    guard let _ = application else {
                        guard let errorString = errorString else {
                            AlertManager.showOKAlert(withTitle: "Error", withMessage: "Unknown error occurred", onViewController: welf)
                            return
                        }
                        AlertManager.showOKAlert(withTitle: "Error", withMessage: errorString, onViewController: welf)

                        return
                    }
                    
                    AlertManager.showOKAlert(withTitle: "Success", withMessage: "Your Applicattion added successfully", onViewController: welf, returnBlock:  { clickedIndex in
                        welf.filledData.removeAll()
                        welf._selectedSkill.removeAll()
                        welf._resumeFileUrl = nil
                        welf._uploadFileInfo = nil
                        DispatchQueue.main.async {
                            welf._tableView.reloadData()
                        }
                    })
                }
            }
        } else {
            AlertManager.showOKAlert(withTitle: "Require mandatory fields", withMessage: "Email, First Name, Last Name and mobile is mandatory to apply for this job", onViewController: self)
        }
    }
    
    private func _selectButtonPressedForType(fieldType: ApplicationFields, sender: Any?) {
        if fieldType == .skills {
            if let vc = StoryboardControllerIds.appStoryboard().instantiateViewController(withIdentifier: SkillsVC.identifier()) as? SkillsVC {
                vc.delegate = self
                vc.selectedSkills = Set(_selectedSkill)
                self.present(vc, animated: true)
            }
        } else if fieldType == .resume {
            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeRTFD), String(kUTTypeFlatRTFD), String(kUTTypeText), String(kUTTypePlainText), String(kUTTypeTXNTextAndMultimediaData)], in: .import)
           
            importMenu.delegate = self
            importMenu.allowsMultipleSelection = false
            if #available(iOS 13.0, *) {
                importMenu.shouldShowFileExtensions = true
            }
            self.present(importMenu, animated: true, completion: nil)
        }
    }

}

extension ApplyJobVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ApplicationFields.allFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fieldType = ApplicationFields.allFields[indexPath.row]
        let ct = fieldType.classType()
        let ci = ct.identifier()
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ci) as? BaseTableViewCell else {
            return UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: ci)
        }
        
        cell.setDataForFieldType(fieldType: fieldType, fieldData: self.filledData[fieldType] ?? "")
        cell.actionCompletion = {[unowned self] rcell, senderr in
            if let ip = self._tableView.indexPath(for: rcell)  {
                let ft = ApplicationFields.allFields[ip.row]
                if rcell is TextfieldCell , let senderr = senderr as? UITextField {
                    if let txt = senderr.text , txt.count > 0 , self._checkTextFieldValidations(fieldType: ft, sender: senderr, cell: rcell as! TextfieldCell) {
                        self.filledData[ft] = senderr.text ?? ""
                    } else {
                        self.filledData.removeValue(forKey: ft)
                    }
                } else {
                    self._selectButtonPressedForType(fieldType: ft, sender: senderr)
                }
            }
        }
        
        return cell
    }
    
    private func _checkTextFieldValidations(fieldType: ApplicationFields, sender: UITextField, cell: TextfieldCell) -> Bool {
        switch fieldType {
        case .firstName, .lastName:
            if let txt = sender.text , txt.count > 0 {
                if !txt.isOnlyalpha() || txt.count > 15 {
                    AlertManager.showOKAlert(withTitle: "Improper \(fieldType.headerTitle())", withMessage: "\(txt) is not proper \(fieldType.headerTitle()). Only alpha characters are allowed", onViewController: self)
                    sender.text = nil
                    return false
                }
            }
            return true
        case .mobileNumber:
            if let txt = sender.text , txt.count > 0, !txt.isValidPhone() {
                AlertManager.showOKAlert(withTitle: "Improper Phone number", withMessage: "\(txt) is not proper phone number", onViewController: self)
                sender.text = nil
                return false
            }
            return true
        case .email:
            if let txt = sender.text , txt.count > 0 {
                
                if !txt.isValidEmailID() || txt.count > 40 {
                    AlertManager.showOKAlert(withTitle: "Improper Email", withMessage: "\(txt) is not proper email", onViewController: self)
                    sender.text = nil
                    return false
                }
            }
            return true
        case .skills, .resume:
            return true
        case .linkedInURL, .githubURL, .otherURL:
            if let txt = sender.text , txt.count > 0, !txt.isValidURL() {
                AlertManager.showOKAlert(withTitle: "Improper \(fieldType.headerTitle()) URL", withMessage: "\(txt) is not proper URL", onViewController: self)
                sender.text = nil
                return false
            }
            return true
        }
    }
}

extension ApplyJobVC: SkillVCDelegate {
    func selectedSkills(skills: [String], fromVC vc: SkillsVC) {
        let skillToDisplay = skills.joined(separator: ", ")
        filledData[.skills] = skillToDisplay
        self._selectedSkill = skills
    }
    
//    func cancelSkillSelection(vc: SkillsVC) {
//        
//    }
}

extension ApplyJobVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do{
            let data = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
//            let fileExtension = url.pathExtension
            let mimetype = url.mimeType()
            
            WebRequests.uploadResumeFile(fileURL: url, fileData: data, fileName: fileName, mimeType: mimetype) {[weak self] uploadFile, errorStr in
                if let welf = self {
                    if let uploadFile = uploadFile {
                        welf.filledData[.resume] = fileName
                        welf._resumeFileUrl = url
                        welf._uploadFileInfo = uploadFile
                    } else {
                        guard let errorString = errorStr else {
                            AlertManager.showOKAlert(withTitle: "Error", withMessage: "Unknown error occurred", onViewController: welf)
                            return
                        }
                        AlertManager.showOKAlert(withTitle: "Error", withMessage: errorString, onViewController: welf)
                    }
                }
            }
        }catch{
            print(error)
        }
        
        
        controller.dismiss(animated: true, completion: nil)

    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
