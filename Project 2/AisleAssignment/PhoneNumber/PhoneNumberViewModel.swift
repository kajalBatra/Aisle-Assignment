//
//  PhoneNumberViewModel.swift
//  AisleAssignment
//
//  Created by Kajal Batra on 18/03/23.
//

import Foundation

protocol PhoneNumberViewModelDelegate: AnyObject {
    func showAlert(message: String)
    func loginSuccessfull(status: Bool)
}

class PhoneNumberViewModel: NSObject {
    var countryCode: String?
    var phoneNumber: String?
    
    weak var delegate: PhoneNumberViewModelDelegate?
    
    private var isCountryCodeValid: Bool {
        if (countryCode ?? "").isEmpty {
            delegate?.showAlert(message: "Please enter country code")
            return false
        }
        return true
    }
    
    private var isNumberValid: Bool {
        if (phoneNumber ?? "").isEmpty {
            delegate?.showAlert(message: "Please enter phone number")
            return false
        }
        return true
    }
    
    func loginWithPhoneNumber() {
        guard isCountryCodeValid && isNumberValid else {
            return
        }
        
        let param: [String:Any] = ["number": (countryCode ?? "") + (phoneNumber ?? "")]
        APIService.shared.request(type: PhoneNumberModel.self, url: .phone_number, httpMethod: .post, param: param) { [weak self] response, error in
            DispatchQueue.main.async {
                
                if let err = error {
                    self?.delegate?.showAlert(message: err.localizedDescription)
                }
                else if let res = response {
                    self?.delegate?.loginSuccessfull(status: res.status ?? false)
                }
                else {
                    self?.delegate?.showAlert(message: "Something went wrong")
                }
            }
        }
    }
}
