import Foundation
import RxSwift

protocol LoginPresenterDelegate: AnyObject {
    func loginSuccess()
}

protocol LoginPresenterProtocol {
    // inputs:
    func loginAction()
    func usernameTextUpdated(text: String)
    func passwordTextUpdated(text: String)

    // outputs:
    var imageName: PublishSubject<String> { get }
    var usernameTitle: PublishSubject<String> { get }
    var usernameValue: PublishSubject<String> { get }
    var passwordTitle: PublishSubject<String> { get }
    var passwordValue: PublishSubject<String> { get }
    var buttonTitle: PublishSubject<String> { get }
    var errorTitle: PublishSubject<String> { get }
    var isErrorHidden: PublishSubject<Bool> { get }

    // delegate
    var delegate: LoginPresenterDelegate? { get set }
}

final class LoginPresenter: LoginPresenterProtocol {
    let imageName: PublishSubject<String>
    let usernameTitle: PublishSubject<String>
    let usernameValue: PublishSubject<String>
    let passwordTitle: PublishSubject<String>
    let passwordValue: PublishSubject<String>
    let buttonTitle: PublishSubject<String>
    let errorTitle: PublishSubject<String>
    let isErrorHidden: PublishSubject<Bool>

    weak var delegate: LoginPresenterDelegate?

    private let loginActionRelay = PublishSubject<Void>()
    private let username = PublishSubject<String>()
    private let password = PublishSubject<String>()
    private let bag = DisposeBag()

    private let repository: RepositoryType
    
    init(repository: RepositoryType) {
        self.repository = repository

        // Won't change:
        imageName = PublishSubject<String>()
        imageName.onNext("login")
        usernameTitle = PublishSubject<String>()
        usernameTitle.onNext("Introduce your username")
        passwordTitle = PublishSubject<String>()
        passwordTitle.onNext("Introduce your password")
        buttonTitle = PublishSubject<String>()
        buttonTitle.onNext("Sign in")

        // Will change, with default value:
        isErrorHidden = PublishSubject<Bool>()
        isErrorHidden.onNext(true)

        // Will change, no value
        usernameValue = PublishSubject<String>()
        passwordValue = PublishSubject<String>()
        errorTitle = PublishSubject<String>()

        loginActionRelay
            .withLatestFrom(Observable.combineLatest(username, password))
            .subscribe { event in
                guard case let .next(latest) = event else { return }
                let (username, password) = latest

                print(username)
                print(password)

                // validate inputs
                if username.isEmpty || password.isEmpty {
                    self.errorTitle.onNext("Check your credentials")
                    self.isErrorHidden.onNext(false)
                } else {
                    // loading
                    self.isErrorHidden.onNext(true)

                    repository.login(username: username, password: password) { result in
                        // stop loading
                        switch result {
                        case .success:
                            self.delegate?.loginSuccess()
                            break
                        case .failure:
                            self.errorTitle.onNext("Can't not login")
                            self.isErrorHidden.onNext(false)
                        }
                    }
                }
            }
            .disposed(by: bag)
    }

    func usernameTextUpdated(text: String) {
        username.onNext(text)
    }

    func passwordTextUpdated(text: String) {
        password.onNext(text)
    }

    func loginAction() {
        loginActionRelay.onNext(())
    }
}
