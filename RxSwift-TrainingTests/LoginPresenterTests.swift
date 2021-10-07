import XCTest
@testable import RxSwift_Training

final class LoginPresenterTests: XCTestCase {

    private var repository: MockRepository!
    private var view: MockView!
    private var presenter: LoginPresenter!
    
    override func setUpWithError() throws {
        repository = MockRepository()
        view = MockView()
        presenter = LoginPresenter(repository: repository)
        presenter.attachView(view)
    }

    override func tearDownWithError() throws {
        repository = nil
        view = nil
        presenter = nil
    }

    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertEqual(view.image, "login")
        XCTAssertEqual(view.username, "Introduce your username")
        XCTAssertEqual(view.password, "Introduce your password")
        XCTAssertEqual(view.buttonTitle, "Sign in")
        XCTAssertNil(view.errorLabel)
        XCTAssertEqual(view.errorIsHidden, true)
    }

    func test_emptyUsername_loginAction_returns_errorIsHidden_false() {
        presenter.loginAction()
        XCTAssertEqual(view.errorLabel, "Check your credentials")
        XCTAssertEqual(view.errorIsHidden, false)
    }
    
    func test_notEmptyUsername_emptyPassword_loginAction_returns_errorIsHidden_false() {
        presenter.set(username: "abel.c")
        presenter.loginAction()
        XCTAssertEqual(view.errorLabel, "Check your credentials")
        XCTAssertEqual(view.errorIsHidden, false)
    }
    func test_notEmptyUsername_notEmptyPassword_loginAction_returns_errorIsHidden_true() {
        presenter.set(username: "abel.c")
        presenter.set(password: "xxxxx")
        presenter.loginAction()
        XCTAssertEqual(view.errorIsHidden, true)
    }
    
    func test_login_empty_does_not_called_repository() {
        presenter.loginAction()
        XCTAssertEqual(repository.callCount, 0)
    }
    
    func test_login_notEmpty_called_repository() {
        presenter.set(username: "abel.c")
        presenter.set(password: "xxxxx")
        presenter.loginAction()
        XCTAssertEqual(repository.callCount, 1)
    }
    
    func test_failed_result_shows_error() {
        repository.loginResult = .failure(MockError.mockError)
        presenter.set(username: "abel.c")
        presenter.set(password: "xxxxx")
        presenter.loginAction()
        
        XCTAssertEqual(repository.callCount, 1)
        XCTAssertEqual(view.errorLabel, "Can't not login")
        XCTAssertEqual(view.errorIsHidden, false)
    }
}

private extension LoginPresenterTests {
    final class MockView: LoginView {
        var image: String?
        var username: String?
        var password: String?
        var buttonTitle: String?
        var errorLabel: String?
        var errorIsHidden: Bool?
            
        func set(image: String) { self.image = image }
        func set(username: String) { self.username = username }
        func set(password: String) { self.password = password }
        func set(buttonTitle: String) { self.buttonTitle = buttonTitle }
        func set(errorLabel: String) { self.errorLabel = errorLabel }
        func set(errorIsHidden: Bool) { self.errorIsHidden = errorIsHidden }
    }
}
