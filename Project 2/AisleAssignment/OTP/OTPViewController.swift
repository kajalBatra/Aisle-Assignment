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
    @IBOutlet weak var btnContinue      : UIButton!
    @IBOutlet weak var btnResend        : UIButton!
    
    var phoneNumber: String?
    var timer: Timer?
    var totalTime = 60
       
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
        startOtpTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func startOtpTimer() {
        self.totalTime = 60
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        lblTimer.text = self.timeFormatted(self.totalTime)
        lblTimer.isHidden = false
    }
    
    @objc func updateTimer() {
        self.lblTimer.text = self.timeFormatted(self.totalTime)
        if totalTime != 0 {
            totalTime -= 1
        } else if let timer = self.timer {
            btnResend.isHidden = false
            lblTimer.isHidden = true
            timer.invalidate()
            self.timer = nil
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
           let seconds: Int = totalSeconds % 60
           let minutes: Int = (totalSeconds / 60) % 60
           return String(format: "%02d:%02d", minutes, seconds)
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
                    let tabBarController = self?.storyboard?.instantiateViewController(identifier: "TabbarContoller") as? UITabBarController
                    tabBarController?.selectedIndex = 1
                    UserDefaults.standard.set(token, forKey: "authtoken")
                    
                    (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = tabBarController
                    (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
                }
                else {
                    self?.present(AlertUtility.alertWith(error: "Something went wrong. Please try again"), animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func btnContinueTapped(_ sender: Any) {
        guard isOTPValid else {
            present(AlertUtility.alertWith(error: "Please enter valid OTP"), animated: true, completion: nil)
            return
        }
        verifyOTP(textFieldOTP.text ?? "")
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResendTapped(_ sender: Any) {
        btnResend.isHidden = true
        startOtpTimer()
    }
}

// MARK: - TextField
extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {return true} // Backspace pressed
        return (textField.text?.count ?? 0) < 4
    }
}
