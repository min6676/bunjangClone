//
//  LoginDataManager.swift
//  BunjangClone
//
//  Created by 김민순 on 2021/03/18.
//

import Alamofire
import KeychainSwift

class AutoLoginDataManager {
    func autoLogin(sceneDelegate: SceneDelegate) {
        let myKey = KeychainSwift().get("jwtToken")
        let headers: HTTPHeaders = ["x-access-token" : myKey ?? ""]
        AF.request("\(Constant.BASE_URL)/autologin", method: .post, headers: headers).validate().responseDecodable(of: AutoLoginResponse.self) { response in
            switch response.result {
            case .success(let response):
                let message = response.message
                if response.isSuccess {
                    // 자동 로그인 성공
//                    print(message)
//                    print(response.jwt)
                    print(message)
                    sceneDelegate.goToMain()
                } else {
                    switch response.code {
                    // JWT 토큰 미입력
                    case 2000:
                        print(message)
                        sceneDelegate.goToLogin()
                    // JWT 토큰 검증 실패
                    case 3000:
                        print(message)
                        sceneDelegate.goToLogin()
                    // 데이터베이스 에러
                    default:
                        print(message)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("서버와의 연결이 원할하지 않습니다.")
                sceneDelegate.goToLogin()
                if KeychainSwift().get("jwtToken") != nil {
                    KeychainSwift().delete("jwtToken")
                }
            }
        }
    }
}
