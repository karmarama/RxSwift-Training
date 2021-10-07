import UIKit

protocol LoginView: AnyObject {
    func set(image: String)
    func set(username: String)
    func set(password: String)
    func set(buttonTitle: String)
    func set(errorLabel: String)
    func set(errorIsHidden: Bool)
}

final class LoginViewController: UIViewController {

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var usernameTitle: UILabel!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTitle: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var errorLabel: UILabel!
    
    let presenter: LoginPresenterProtocol

   init(presenter: LoginPresenterProtocol) {
       self.presenter = presenter
       super.init(nibName: String(describing: LoginViewController.self), bundle: Bundle(for: LoginViewController.self))
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        presenter.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func usernameEditingChanged(_ sender: Any) {
        presenter.set(username: usernameTextField.text ?? "")
    }
    @IBAction func passrwordEditingChanged(_ sender: Any) {
        presenter.set(password: passwordTextField.text ?? "")
    }
    @IBAction func loginTouchUpInside(_ sender: Any) {
        presenter.loginAction()
    }
}

extension LoginViewController: LoginView {
    func set(image: String) {
        self.image.image = UIImage(named: image)
    }
    func set(username: String) {
        usernameTitle.text = username
    }
    func set(password: String) {
        passwordTitle.text = password
    }
    func set(buttonTitle: String) {
        loginButton.setTitle(buttonTitle, for: .normal)
    }
    func set(errorLabel: String) {
        self.errorLabel.text = errorLabel
    }
    func set(errorIsHidden: Bool) {
        errorLabel.isHidden = errorIsHidden
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
