

import UIKit
import FirebaseAuth
import FirebaseFirestore
class ChatViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    var messages : [Message] = []
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
        
        // vẫn chưa hiểu sao lại có title nma lắp cái này thì sẽ có dòng chữ flashchat ở đầu chatviewcontroller
        title = K.appName
        // bỏ cái nút back để comeback bước trước đi
        navigationItem.hidesBackButton = true
        // cái dòng này là cần để delegate cho chủ thể hành động là self(chính là ChatViewController)
        tableView.dataSource = self
        // Đăng ký cái NIB với tableView (nói chung là kết nối messageCell)
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    func loadMessages()
    {
        //messages = []
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            self.messages = []
            // khi có phần tử mới được thêm vào bộ sưu tập, ta làm rỗng message và add phần tử đó vào messages
            // do hàm addSnapshotListener lắng nghe thay đổi của bộ data, khi 1 phần tử mới được thêm vào data, nó sẽ trigger( thực hiện hành động) với tất cả dòng code trong closure
            if let e = error
            {
                print("There was an issue retrieving data from Firestore \(e)")
            }
            else
            {
                //querySnapshot?.documents[0].data()[K.FStore.senderField]
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments
                    {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String ,let messageBody = data[K.FStore.bodyField] as? String
                        {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                        
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
    //in this line we're creating which row we want to scroll to
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
        // đoạn code đầu để lấy data đã lưu trên firestore
        // và data lấy được ở dạng dic
        // ex ["sender": 1@2.com, "date": 1662542477.231974, "body": hi]
        // do kiểu data ban đầu ở cái chỗ sender là any (nhạc nào cũng nhảy)
        // h ta muốn chuyển về String thì dùng as để down casting
        //hàm tableView.reloadData() để truy cập vào data và rà lại lần nữa, kiểu như chat thì bấm nút liên tục chứ đâu chỉ làm mỗi nháy viewdidload là xong đâu
        // khi mình biến đổi viewcontroller mà nằm trong closure thì nên dùng hàm DispatchQueue.main.async
        // addSnapshotListener: ấn nút thì nó sẽ load tiếp data
        // getDocuments : data vẫn được đẩy vào nma ko load và hiển thị tiếp data khi ấn nút
    }
    
    // khi người dùng ấn nút gửi
    @IBAction func sendPressed(_ sender: UIButton) {
       // print("has kicked")
        // hàm Auth.auth().currentUser?.email lưu in4 lên trên FireStore
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
                    db.collection(K.FStore.collectionName).addDocument(data: [
                        K.FStore.senderField: messageSender,
                        K.FStore.bodyField: messageBody,
                        K.FStore.dateField: Date().timeIntervalSince1970
    // Date().timeIntervalSince1970 để có được số giây tính từ năm 1970
    // tại sao lấy time nhắn làm gì
    // để tính còn sắp xếp các data theo time gửi thay vì a -> z
    // order(by: K.FStore.dateField) bổ sung và đuôi hàm trên
                    ]) { (error) in
                        //print("has checked")
                        if let e = error {
                            print("There was an issue saving data to firestore, \(e)")
                        } else {
                            // print("Successfully saved data.")
                            // khi mình biến đổi viewcontroller mà nằm trong closure thì nên dùng hàm DispatchQueue.main.async
                            DispatchQueue.main.async {
                                // dùng dòng code này để làm ô nhập tin nhắn rỗng
                                 self.messageTextfield.text = ""
                            }
                        }
                    }
                }
    }
    // code để chạy nút log out thoát ctrinh
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
      
    }
    
}

extension ChatViewController : UITableViewDataSource
{
    // cú pháp triệu hồi số cell (ô) // return kích cỡ mảng là vì lý do đó
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    // hàm trả về giá trị cho mỗi hàng (cái mà mỗi hàng hiển thị)
    // hảm hỏi mình với mỗi hàng ngang (ô) thì mình sẽ hiển thị cái gì
    // do đó cần phải tạo ra 1 cell và return về tableView
    // bản nâng cấp có as! MessageCell là để kết nối với cái tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    // mục tiêu là thiết kế sao cho ô chat đẹp hơn
    // lúc này cũng thay đổi thành cell.label (trước đó là cell.textLabel?.text )
    // sau bước này vào Main (màn hình chính và xoá cái prototypeCell cũ lúc đầu tạo (nó cũng tên là ReuseableCell - tên tuỳ mình đặt thôi) bởi giờ mình ko còn dùng nó nữa (mình dùng cái mới do mình tạo ra rồi còn đâu)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        // nếu đây là tin nhắn từ current user
        // nếu đây là tin nhắn do mình gửi , cái tài khoản đang đăng nhập == tài khoản đọc đc
        if message.sender == Auth.auth().currentUser?.email
        {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        // nếu đây là tin nhắn của người khác gửi
        else
        {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
    
}







