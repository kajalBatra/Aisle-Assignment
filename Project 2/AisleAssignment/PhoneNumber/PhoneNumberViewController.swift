//
//  PhoneNumberViewController.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 17/03/23.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var textFieldPhoneNo     : UITextField!
    @IBOutlet weak var textFieldCountryCode : UITextField!
    
    var viewModel = PhoneNumberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        textFieldCountryCode.becomeFirstResponder()
    }
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        viewModel.countryCode = textFieldCountryCode.text
        viewModel.phoneNumber = textFieldPhoneNo.text
        viewModel.loginWithPhoneNumber()
    }
}

// MARK: - PhoneNumberViewModelDelegate
extension PhoneNumberViewController: PhoneNumberViewModelDelegate {
    func showAlert(message: String) {
        present(AlertUtility.alertWith(error: message, handler: nil), animated: true, completion: nil)
    }
    
    func loginSuccessfull(status: Bool) {
        if status {
            let otpVC = storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
            otpVC.phoneNumber = viewModel.countryCode! + " " + viewModel.phoneNumber!
            navigationController?.pushViewController(otpVC, animated: true)
        }
        else {
            present(AlertUtility.alertWith(error: "Unable to login. Status: false", handler: nil), animated: true, completion: nil)
        }
    }
}

// MARK: - UITextFieldDelegate
extension PhoneNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {return true} // Backspace pressed
        
        if textField == textFieldCountryCode {
            return (textField.text?.count ?? 0) < 3
        }
        if textField == textFieldPhoneNo {
            return (textField.text?.count ?? 0) < 10
        }
        
        return false
    }
}
