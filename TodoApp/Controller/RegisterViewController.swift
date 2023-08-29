//
//  RegisterViewController.swift
//  TodoApp
//
//  Created by Sena Nur Erdem on 28.06.2023.
//

import UIKit
class RegisterViewController: UIViewController {
    // MARK: - Properties
    private var profileImagE:UIImage?
    private var viewModel = RegisterViewModel()
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        return button
    }()
    private lazy var emailContainerView: UIView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        return containerView
    }()
    private lazy var nameContainerView: UIView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "person")!, textField: nameTextField)
        return containerView
    }()
    private lazy var usernameContainerView: UIView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "person")!, textField: usernameTextField)
        return containerView
    }()
    private lazy var passwordContainerView: UIView = {
        let containerView = AuthenticationInputView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
        return containerView
    }()
    private let emailTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Email")
        return textField
    }()
    private let nameTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Name")
        return textField
    }()
    private let usernameTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Username")
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = CustomTextField(placeHolder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    private lazy var registerButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.layer.cornerRadius = 7
        button .isEnabled = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        return button
    }()
    private var stackView = UIStackView()
    private lazy var switchToLoginPage: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "If you are member, Login Page", attributes: [.foregroundColor:UIColor.white, .font: UIFont.boldSystemFont(ofSize: 14)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleGoLogin), for: .touchUpInside)
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}
// MARK: - Selectors
extension RegisterViewController {
    @objc private func handleRegisterButton(_ sender: UIButton) {
        guard let emailText = emailTextField.text else { return }
        guard let passwordText = passwordTextField.text else { return }
        guard let nameText = nameTextField.text else { return }
        guard let usernameText = usernameTextField.text else { return }
        guard let profileImagE = self.profileImagE else { return }
        showHud(show: true)
        let user = AuthenticationRegisterUserModel(emailText: emailText, passwordText: passwordText, usernameText: usernameText, nameText: nameText, profileImage: profileImagE)
        AuthenticationService.createUser(user: user) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showHud(show: false)
                return
            }
        }
        self.showHud(show: false)
        self.dismiss(animated: true)
        
    }
    @objc private func handlePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    @objc private func handleTextField(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.emailText = sender.text
        }
        else if sender == passwordTextField {
            viewModel.passwordText = sender.text
        }
        else if sender == nameTextField {
            viewModel.nameText = sender.text
        }
        else if sender == usernameTextField {
            viewModel.usernameText = sender.text
        }
        registerButtonStatus()
    }
    @objc private func handleGoLogin(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func handleKeyboardWillShow() {
        self.view.frame.origin.y = -110
    }
    @objc private func handleKeyboardWillHide() {
        self.view.frame.origin.y = 0
    }
}
// MARK: - Helpers
extension RegisterViewController {
    private func registerButtonStatus() {
        if viewModel.status{
            registerButton.isEnabled = true
            registerButton.backgroundColor = .green
        }
        else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .red
        }
    }
    private func style() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        backgroundGradientColor()
        view.backgroundColor = .red
        self.navigationController?.navigationBar.isHidden = true
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        stackView = UIStackView(arrangedSubviews: [emailContainerView,nameContainerView,usernameContainerView,passwordContainerView, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        switchToLoginPage.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(handleTextField), for: .editingChanged)
    }
    private func layout() {
        view.addSubview(cameraButton)
        view.addSubview(stackView)
        view.addSubview(switchToLoginPage)
        NSLayoutConstraint.activate([
            cameraButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cameraButton.widthAnchor.constraint(equalToConstant: 150),
            cameraButton.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 32), stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32), view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 32),
            
            switchToLoginPage.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            switchToLoginPage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            view.trailingAnchor.constraint(equalTo: switchToLoginPage.trailingAnchor, constant: 32)
            
        ])
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.profileImagE = image
        cameraButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 150 / 2
        cameraButton.contentMode = .scaleAspectFill
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 3
        self.dismiss(animated: true)
        
    }
}
