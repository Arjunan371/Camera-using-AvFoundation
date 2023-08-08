
import UIKit
import AVFoundation

class ViewController: UIViewController,AVCapturePhotoCaptureDelegate {
 var isRecording = false
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var playPause: UIButton!
    var videoOutput: AVCaptureFileOutput!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
  
    override func viewDidLoad() {
        super.viewDidLoad()
     //   photoImage.layer.cornerRadius = 30
      //  setUpCamera()
        photoImage.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(tapGestureRecognizer)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpCamera()
    }
    func setUpCamera() {
        // Setup your camera here...
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        // select the input device
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        else {
            print("Unable to access back camera!")
            return
        }
        // prepare the input
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            //Step 9  configure the input
            stillImageOutput = AVCapturePhotoOutput()
            // attach the input and output
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    //kkk
    @IBAction func takeVideo(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "video") as! VideoViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        // step 14 taking the picture
        photoImage.isHidden = false
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // configure the live preview
    func setupLivePreview() {
        
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//
//        videoPreviewLayer.videoGravity = .resizeAspectFill
//        videoPreviewLayer.connection?.videoOrientation = .portrait
//      //  videoPreviewLayer.connection?.videoOrientation = .landscapeLeft
//
//        previewView.layer.addSublayer(videoPreviewLayer)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = previewView.bounds
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewView.layer.addSublayer(videoPreviewLayer)
        //Step12
        // Start the Session on the background thread
        DispatchQueue.global().async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
            // Size the Preview Layer to fit the Preview View
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
           }
        }
    }
    // step 15 process the captured photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
        else { return }
        
        let image = UIImage(data: imageData)
        
        photoImage.image = image
    }
    
    // step16 Clean up when the user leaves!
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.captureSession.stopRunning()
//    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "story") as! ImageViewController
        vc.Image = photoImage.image
        navigationController?.pushViewController(vc, animated: true)
    }
}

    

