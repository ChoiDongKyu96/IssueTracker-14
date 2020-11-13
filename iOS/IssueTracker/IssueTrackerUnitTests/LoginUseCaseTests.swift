//
//  LoginUseCaseTests.swift
//  IssueListUseCaseTests
//
//  Created by 최동규 on 2020/11/05.
//

import XCTest
@testable import IssueTracker

final class LoginUseCaseTests: XCTestCase {
    
    struct MockSuccessNetworkService: NetworkServiceProviding {
        var userToken: String?
        
        func request(requestType: RequestType, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
            let response = LoginResponse(token: "testToken")
            let data = try? JSONEncoder().encode(response)
            completionHandler(.success(data!))
        }
    }
    
    func testLocalLoginSuccess() {
        let useCase = LoginUseCase(networkService: MockSuccessNetworkService())
        let localLoginInfo = LocalLoginInfo(email: "test", password: "test")
        useCase.login(with: localLoginInfo) { result in
            switch result {
            case let .success(response):
                XCTAssertEqual(response.token, "testToken")
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testLocalLoginFailure() {
        let useCase = LoginUseCase(networkService: MockFailureNetworkService())
        let localLoginInfo = LocalLoginInfo(email: "test", password: "test")
        useCase.login(with: localLoginInfo) { result in
            switch result {
            case let .success(data):
                XCTFail("서버에서 잘못된 데이터가 왔음에도 성공 \(data)")
            case let .failure(error):
                XCTAssertEqual(error, .networkError(message: ""))
            }
        }
    }
    
    func testAppleLoginSuccess() {
        let useCase = LoginUseCase(networkService: MockSuccessNetworkService())
        let appleLoginInfo = AppleLoginInfo(email: "test", name: "test", hashcode: "testtest")
        useCase.login(with: appleLoginInfo) { result in
            switch result {
            case let .success(response):
                XCTAssertEqual(response.token, "testToken")
            case let .failure(error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testAppleLoginFailure() {
        let useCase = LoginUseCase(networkService: MockFailureNetworkService())
        let appleLoginInfo = AppleLoginInfo(email: "test", name: "test", hashcode: "testtest")
        useCase.login(with: appleLoginInfo) { result in
            switch result {
            case let .success(data):
                XCTFail("서버에서 잘못된 데이터가 왔음에도 성공 \(data)")
            case let .failure(error):
                XCTAssertEqual(error, .networkError(message: ""))
            }
        }
    }
}
