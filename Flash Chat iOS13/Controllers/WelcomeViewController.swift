

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = K.appName
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
    
    


}

































// cách này là cách ko chơi support thư viện cocad pod bên ngoài
/*
 titleLabel.text = ""
 let titleText = "⚡️FlashChat"
 var charIndex = 0.0
 for letter in titleText
 {
     Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
         self.titleLabel.text?.append(letter)
     }
     charIndex += 1
    // sử dụng hàm này để update từng chữ 1 sau 0.1 s
     // repeats = false vì chỉ muốn chạy dòng chữ này 1 lần ko muốn lặp lại
     // lúc đầu
     /*
     Timer.scheduledTimer(withTimeInterval: <#T##TimeInterval#>, repeats: <#T##Bool#>, block: <#T##(Timer) -> Void#>)
     */
     // ta bôi xanh vào (Timer) -> void rồi ấn enter nó sẽ tự chuyển sang dạng closure cho mình (closure là dạng lấy hàm làm đầu vào cho hàm)
     // nguyên nhân cần thêm 0.1 * charIndex vì nếu chỉ để 0.1 không thì tất cả các kí tự sẽ đều xuất hiện vào thời điểm 0.1 (scheduled : lịch trình, Interval : khoảng time giữa 2 sự kiện)
     // nói chung bình thường chạy bên ngoài ko sao nma vào for nó neff do đó cần áp công thức vào để chữa vì khó tả quá
 }

 */
