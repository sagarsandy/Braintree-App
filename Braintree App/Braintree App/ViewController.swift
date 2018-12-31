//
//  ViewController.swift
//  Braintree App
//
//  Created by Sagar Sandy on 31/12/18.
//  Copyright © 2018 Sagar Sandy. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    // IB Action for pay now button pressed
    @IBAction func payNowButtonPressed(_ sender: Any) {
        
        // This sandbox tokenization key is created in briantree sandbox account under settings and api keys
        let tokenizationKey = "sandbox_6pr6945c_59wn4ftsfbhj2qj2"
        
        showDropIn(clientTokenOrTokenizationKey: tokenizationKey)
        
    }
    
    // Braintree default method to show drop in ui
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                
                self.postNonceToServer(paymentMethodNonce: (result.paymentMethod?.nonce)!, amount: "20.00")
                
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    // Braintree default method to send payment request to server
    func postNonceToServer(paymentMethodNonce: String, amount : String) {
        // Update URL with your server
        let paymentURL = URL(string: "https://server-ip-address/tokens.php")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)&amount=\(amount)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            
                if let data = data {
                    // Payment response from server
                    let dataString = String(data: data, encoding: .utf8)
                    print(dataString!)
                }
            
            }.resume()
    }

}

