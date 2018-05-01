//
//  CHMLoginController.swift
//  MiniChat
//
//  Created by 陈华谋 on 30/04/2018.
//  Copyright © 2018 陈华谋. All rights reserved.
//

import UIKit


class CHMLoginController: UIViewController, UITextFieldDelegate {
    
    // MARK:- 点击操作
    /// 点击登录
    @IBAction func clickLoginButton() {
        print("\(#line)点解登录按钮\n")
    }
    
    
    /// 点击新用户
    @IBAction func clickRegisterButton() {
        navigationController?.pushViewController(CHMRegisterController(), animated: true)
    }
    
    
    // MARK:- view life cycler
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        registerBtnBottomConstraint.constant = CGFloat(UIScreen.main.bounds.height == iphoneXHeight ? KTouchBarHeight : 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubview(toBack: backgroundImageView)
        view.bringSubview(toFront: inputBackground)
        
        // 账号
        accountTextField.textColor = UIColor.white
        accountTextField.attributedPlaceholder = NSAttributedString(string: "账号", attributes: [NSForegroundColorAttributeName: UIColor.white])
        accountTextField.returnKeyType = .next
        accountTextField.delegate = self
        
        // 密码
        passwordTextField.textColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "密码", attributes: [NSForegroundColorAttributeName:UIColor.white])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        passwordTextField.delegate = self
        
        // 登录按钮
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 新用户按钮
        registerButton.setTitleColor(UIColor(red: 153, green: 153, blue: 153, alpha: 0.5), for: .normal)
        
    }
    
    // MARK:- touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- 控件
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var inputBackground: UIView!
    @IBOutlet weak var accountTextField: RCUnderlineTextField!
    @IBOutlet weak var passwordTextField: RCUnderlineTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerBtnBottomConstraint: NSLayoutConstraint!
    
}

extension CHMLoginController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1000 {
            accountTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return false
    }
}
