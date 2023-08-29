//
//  AuthenticationService.swift
//  TodoApp
//
//  Created by Sena Nur Erdem on 2.07.2023.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
struct AuthenticationRegisterUserModel {
    let emailText: String
    let passwordText: String
    let usernameText: String
    let nameText: String
    let profileImage: UIImage
}
struct AuthenticationService {
    
    static func login(emailText: String, passwordText: String, completion: @escaping(AuthDataResult?, Error?)->Void) {
        Auth.auth().signIn(withEmail: emailText, password: passwordText, completion: completion)
    }
    
    static func createUser(user: AuthenticationRegisterUserModel, completion: @escaping(Error?)->Void) {
        guard let profileImageData = user.profileImage.jpegData(compressionQuality: 0.5) else {return}
        let fileName = NSUUID().uuidString
        let referance = Storage.storage().reference(withPath: "images/profile_images/\(fileName)")
        referance.putData(profileImageData) { metadaData, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            referance.downloadURL { url, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let profileImageUrl = url?.absoluteString else { return }
                Auth.auth().createUser(withEmail: user.emailText, password: user.passwordText) { result, error in
                    
                    guard let uid = result?.user.uid else { return }
                    let data = [
                        "email": user.emailText,
                        "username": user.usernameText,
                        "name": user.nameText,
                        "profileImageUrl": profileImageUrl,
                        "uid": uid
                    ] as [String: Any]
                    Firestore.firestore().collection("users").document(uid).setData(data,completion: completion)
                }
            }
        }
    }
}
