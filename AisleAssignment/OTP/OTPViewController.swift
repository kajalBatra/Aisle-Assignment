//
//  OTPViewController.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 17/03/23.
//

import UIKit

class OTPViewController: UIViewController {
    
    @IBOutlet weak var lblPhoneNo       : UILabel!
    @IBOutlet weak var textFieldOTP     : UITextField!
    @IBOutlet weak var lblTimer         : UILabel!
    
    var phoneNumber: String?
    
    var isOTPValid: Bool {
        if let otp = textFieldOTP.text {
            if otp.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return false
            }
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPhoneNo.text = phoneNumber
        textFieldOTP.becomeFirstResponder()
    }
    
    func verifyOTP(_ otp: String) {
        let param: [String:Any] = [
            "number"    : phoneNumber?.replacingOccurrences(of: " ", with: "") ?? "",
            "otp"       : otp
        ]
        
        APIService.shared.request(type: OTPModel.self, url: .verify_otp, httpMethod: .post, param: param) {
            [weak self] response, error in
            DispatchQueue.main.async {
                if let err = error {
                    self?.present(AlertUtility.alertWith(error: err.localizedDescription), animated: true, completion: nil)
                }
                else if let token = response?.token {
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "NotesListViewController") as! NotesListViewController
                    vc.token = token
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self?.present(AlertUtility.alertWith(error: "Something went wrong. Please try again"), animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        guard isOTPValid else {
            present(AlertUtility.alertWith(error: "Please enter valid OTP"), animated: true, completion: nil)
            return
        }
        verifyOTP(textFieldOTP.text ?? "")
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextField
extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {return true} // Backspace pressed
        return (textField.text?.count ?? 0) < 4
    }
}
