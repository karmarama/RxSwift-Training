import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var usernameTitle: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTitle: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    let presenter: LoginPresenterProtocol
    let bag = DisposeBag()

    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter

        super.init(nibName: String(describing: LoginViewController.self), bundle: Bundle(for: LoginViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createBindings()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    private func createBindings() {
        presenter
            .imageName
            .map { UIImage(named: $0) }
            .bind(to: imageView.rx.image)
            .disposed(by: bag)
        presenter
            .usernameTitle
            .bind(to: usernameTitle.rx.text)
            .disposed(by: bag)
        presenter
            .usernameValue
            .bind(to: usernameTextField.rx.text)
            .disposed(by: bag)
        presenter
            .passwordTitle
            .bind(to: passwordTitle.rx.text)
            .disposed(by: bag)
        presenter
            .passwordValue
            .bind(to: passwordTextField.rx.text)
            .disposed(by: bag)
        presenter
            .buttonTitle
            .bind(to: loginButton.rx.title())
            .disposed(by: bag)
        presenter
            .errorTitle
            .bind(to: errorLabel.rx.text)
            .disposed(by: bag)
        presenter
            .isErrorHidden
            .bind(to: errorLabel.rx.isHidden)
            .disposed(by: bag)
    }
    
    @IBAction func usernameEditingChanged(_ sender: Any) {
        presenter.usernameTextUpdated(text:  usernameTextField.text ?? "")
    }
    @IBAction func passrwordEditingChanged(_ sender: Any) {
        presenter.passwordTextUpdated(text: passwordTextField.text ?? "")
    }
    @IBAction func loginTouchUpInside(_ sender: Any) {
        presenter.loginAction()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
