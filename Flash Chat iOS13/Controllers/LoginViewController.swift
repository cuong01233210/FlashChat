
import UIKit
import FirebaseAuth
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //UINavigationBar.appearance().barTintColor = UIColor(named: K.BrandColors.blue)
        //từ bản ios mới thì trò chỉnh bar tint của navigation controller sẽ phế
        // do đó cần dùng mấy dòng code dưới đây để gán màu cho từng bar tint
        // note: nhớ connect bar tint của mỗi vỉewcontroller nhé
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.orange
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              
                if let e = error
                  {
                    self?.errorLabel.text = e.localizedDescription
                   // print(e.localizedDescription)
                }
                  else
                  {
                      //Navigate to the chat viewcontroller
                      self?.performSegue(withIdentifier: K.loginSegue, sender: self)
                  }
            }
        }
        
    }
    
}
