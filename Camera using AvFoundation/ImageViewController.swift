
import UIKit

class ImageViewController: UIViewController {
    var Image: UIImage?
    @IBOutlet weak var imagePhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePhoto.image = Image
    }
    
}
