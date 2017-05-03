//
//  OrderController.swift
//  AllDayJava
//
//  Created by Sylvain on 02/05/2017.
//  Copyright © 2017 S.G. inTech. All rights reserved.
//

import UIKit
import LocalAuthentication

class OrderController: UITableViewController
{
    var catalog = Catalog()
    var order: Order = Order()
    
    var formatter: NumberFormatter = OrderController.createFormatter()
    var amountFormatter: NumberFormatter = OrderController.createAmountFormatter()
    
    var total = 0.0
    
    // MARK: UI Outlets
    
    @IBOutlet var keyboardAccessory: UIView!

    @IBOutlet weak var expressoBtn:   UIButton!
    @IBOutlet weak var americanoBtn:  UIButton!
    @IBOutlet weak var cappuccinoBtn: UIButton!
    
    @IBOutlet weak var cookieQtyFld: UITextField!
    @IBOutlet weak var cookieQtySpin: UIStepper!
    
    @IBOutlet weak var muffinQtyFld: UITextField!
    @IBOutlet weak var muffinQtySpin: UIStepper!
    
    @IBOutlet weak var sconeQtyFld:  UITextField!
    @IBOutlet weak var sconeQtySpin: UIStepper!
    
    @IBOutlet weak var totalLbl: UILabel!
    
    // MARK: UI Actions
    
    @IBAction func toggleExpresso(_ sender: Any) {
        expressoBtn.isSelected = !expressoBtn.isSelected
        americanoBtn.isSelected = false
        cappuccinoBtn.isSelected = false
        
        updateTotalAmount()
    }
    
    @IBAction func toggleAmericano(_ sender: Any) {
        expressoBtn.isSelected = false
        americanoBtn.isSelected = !americanoBtn.isSelected
        cappuccinoBtn.isSelected = false
        
        updateTotalAmount()
    }
    
    @IBAction func toggleCappuccino(_ sender: Any) {
        expressoBtn.isSelected = false
        americanoBtn.isSelected = false
        cappuccinoBtn.isSelected = !cappuccinoBtn.isSelected
        
        updateTotalAmount()
    }
    
    @IBAction func updatedQtyValue(_ sender: UITextField) {
        let value = Double(parseValue(sender.text))
        
        // Just reset field to min or max, if needed. Not so subtle :-)
        sender.text = formatter.string(from: NSNumber(value: value))
        
        switch sender {
        case cookieQtyFld:
            cookieQtySpin.value = value
            
        case muffinQtyFld:
            muffinQtySpin.value = value
            
        case sconeQtyFld:
            sconeQtySpin.value = value
            
        default:
            break
        }
        
        updateTotalAmount()
    }
    
    @IBAction func updatedValue(_ sender: UIStepper) {
        let value = NSNumber(value: sender.value)
        let text = formatter.string(from: value)
        
        switch sender {
        case cookieQtySpin:
            cookieQtyFld.text = text
            
        case muffinQtySpin:
            muffinQtyFld.text = text
            
        case sconeQtySpin:
            sconeQtyFld.text = text
            
        default:
            break
        }
        
        updateTotalAmount()
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        cookieQtyFld.resignFirstResponder()
        muffinQtyFld.resignFirstResponder()
        sconeQtyFld.resignFirstResponder()
    }
    
    var cancelOrderController: UIAlertController?
    
    @IBAction func askToClearOrder(_ sender: UIButton) {
        if nil == cancelOrderController {
            cancelOrderController = createCancelController()
        }
        
        if let alert = cancelOrderController {
            present(alert, animated: true, completion: {() in })
        }
    }
    
    @IBAction func askConfirmOrder(_ sender: Any) {
        let myContext = LAContext()
        
        let formatterAmount = amountFormatter.string(from: NSNumber(value: total)) ?? "0.00€"
        let myLocalizedReasonString = "Souhaitez-vous confirmer cette commande pour un total de \(formatterAmount) ?"
        
        var authError: NSError? = nil
        
        if myContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                       error: &authError)
        {
            myContext.evaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                localizedReason: myLocalizedReasonString
            ) { (success, evaluateError) in
                if (success) {
                    // User authenticated successfully, take appropriate action
                    NSLog("Biometric succeed...")
                } else {
                    // User did not authenticate successfully, look at error and take appropriate action
                    NSLog("Biometric failed...")
                }
            }
        }
        else {
            // Could not evaluate policy; look at authError and present an appropriate message to user
            NSLog("Biometric not available...")
        }
    }

    // - MARK: Lifecycle
    
    override func viewDidLoad() {
        cookieQtyFld.inputAccessoryView = keyboardAccessory
        muffinQtyFld.inputAccessoryView = keyboardAccessory
        sconeQtyFld.inputAccessoryView  = keyboardAccessory
        
        updateTotalAmount()
    }
    
    // MARK: Internal utilities
    
    func clearOrder() {
        // Reset coffe
        expressoBtn.isSelected = false
        americanoBtn.isSelected = false
        cappuccinoBtn.isSelected = false
        
        // Reset baking
        cookieQtyFld.text = "0"
        muffinQtyFld.text = "0"
        sconeQtyFld.text  = "0"
        
        cookieQtySpin.value = 0.0
        muffinQtySpin.value = 0.0
        sconeQtySpin.value  = 0.0
    }
    
    
    func updateTotalAmount() {
        total = 0.0
        
        if expressoBtn.isSelected {
            total = 2.0
        }
        if americanoBtn.isSelected {
            total = 3.0
        }
        if cappuccinoBtn.isSelected {
            total = 4.2
        }

        total += 2.2 * cookieQtySpin.value
        total += 3.5 * muffinQtySpin.value
        total += 4.1 * sconeQtySpin.value
        
        totalLbl.text = amountFormatter.string(from: NSNumber(value: total))
    }
    
    
    
    // MARK: - Utility methods
    
    func parseValue(_ text: String?) -> Int {
        let number = formatter.number(from: text ?? "0") ?? 0
        
        var value = number.intValue
        
        if value < 0 {
            value = 0
        }
        else if value > 10 {
            value = 10
        }
        
        return value
    }
    
    
    func createCancelController() -> UIAlertController {
        let controller = UIAlertController(
            title: "Effcer cette commande ?",
            message: "Souhaitez-vous vraiment annuler la commande en cours ?",
            preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Conserver", style: .cancel, handler: { (alert) in })
        
        let confirmAction = UIAlertAction(title: "Annuler la commande",
                                          style: .destructive,
                                          handler: { (alert) in self.clearOrder() })
        
        controller.addAction(cancelAction)
        controller.addAction(confirmAction)

        return controller
    }
    
    static func createFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .none
        
        return formatter
    }


    static func createAmountFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currencyAccounting
        
        return formatter
    }
}
