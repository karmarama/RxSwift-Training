import XCTest
@testable import RxSwift_Training
import RxBlocking

final class LoginViewModelTests: XCTestCase {

    private var repository: MockRepository!
    private var viewModel: LoginViewModel!
    
    override func setUpWithError() throws {
        repository = MockRepository()
        viewModel = LoginViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        repository = nil
        viewModel = nil
    }

    func test_init() throws {
        XCTAssertEqual(try viewModel.username.toBlocking().first(), "login")
//        XCTAssertEqual(view.password, "Introduce your password")
//        XCTAssertEqual(view.buttonTitle, "Sign in")
//        XCTAssertNil(view.errorLabel)
//        XCTAssertEqual(view.errorIsHidden, true)
    }
//
//    func test_emptyUsername_loginAction_returns_errorIsHidden_false() {
//        presenter.loginAction()
//        XCTAssertEqual(view.errorLabel, "Check your credentials")
//        XCTAssertEqual(view.errorIsHidden, false)
//    }
//
//    func test_notEmptyUsername_emptyPassword_loginAction_returns_errorIsHidden_false() {
//        presenter.set(username: "abel.c")
//        presenter.loginAction()
//        XCTAssertEqual(view.errorLabel, "Check your credentials")
//        XCTAssertEqual(view.errorIsHidden, false)
//    }
//    func test_notEmptyUsername_notEmptyPassword_loginAction_returns_errorIsHidden_true() {
//        presenter.set(username: "abel.c")
//        presenter.set(password: "xxxxx")
//        presenter.loginAction()
//        XCTAssertEqual(view.errorIsHidden, true)
//    }
//
//    func test_login_empty_does_not_called_repository() {
//        presenter.loginAction()
//        XCTAssertEqual(repository.callCount, 0)
//    }
//
//    func test_login_notEmpty_called_repository() {
//        presenter.set(username: "abel.c")
//        presenter.set(password: "xxxxx")
//        presenter.loginAction()
//        XCTAssertEqual(repository.callCount, 1)
//    }
//
//    func test_failed_result_shows_error() {
//        repository.loginResult = .failure(MockError.mockError)
//        presenter.set(username: "abel.c")
//        presenter.set(password: "xxxxx")
//        presenter.loginAction()
//
//        XCTAssertEqual(repository.callCount, 1)
//        XCTAssertEqual(view.errorLabel, "Can't not login")
//        XCTAssertEqual(view.errorIsHidden, false)
//    }
}
