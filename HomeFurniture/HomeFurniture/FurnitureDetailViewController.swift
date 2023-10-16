
import UIKit

class FurnitureDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var furniture: Furniture?
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var furnitureTitleLabel: UILabel!
    @IBOutlet var furnitureDescriptionLabel: UILabel!
    
    init?(coder: NSCoder, furniture: Furniture?) {
        self.furniture = furniture
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            photoImageView.image = nil
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            ac.addAction(UIAlertAction(title: "Pick Photo", style: .default) { action in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true)
            })
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction(title: "Camera", style: .default) { action in
                picker.sourceType = .camera
                self.present(picker, animated: true)
            })
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        furniture?.imageData = image.jpegData(compressionQuality: 0.9)
        picker.dismiss(animated: true, completion: updateView)
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
        guard let img = photoImageView.image else { return }
        let ac = UIActivityViewController(activityItems: [img], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = sender as! UIButton
        present(ac, animated: true)
    }
    
}
