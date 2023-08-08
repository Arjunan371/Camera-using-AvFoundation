import UIKit

import AVFoundation

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    var isRecording = false
    @IBOutlet weak var camPreview: UIView!
  //  var squareView = UIView()
    @IBOutlet weak var squareView: UIView!
    var timer: Timer?
    let recordLabel = UILabel()
   // let cameraButton = UIView()
    var currentTimeCounter = 0
    let captureSession = AVCaptureSession()
    
    @IBOutlet weak var innerSquareView: UIView!
    @IBOutlet weak var cameraButton: UIView!
    let movieOutput = AVCaptureMovieFileOutput()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var activeInput: AVCaptureDeviceInput!
    
    var outputURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.isUserInteractionEnabled = true
        //forConstraints()
        btnShape()
        //        movieOutput.maxRecordedDuration = CMTime(seconds: 3, preferredTimescale: 600)
        squareView.layer.cornerRadius = 25
        innerSquareView.layer.cornerRadius = 10
        innerSquareView.isHidden = true
        if setupSession() {
            setupPreview()
            startSession()
        }
        let squareViewAction = UITapGestureRecognizer(target: self, action: #selector(VideoViewController.squareViewButtonAction))
        
        squareView.addGestureRecognizer(squareViewAction)
        
        let innerSquareViewAction = UITapGestureRecognizer(target: self, action: #selector(VideoViewController.innersquareViewButtonAction))
        
        innerSquareView.addGestureRecognizer(innerSquareViewAction)
        
//        cameraButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.45, y: UIScreen.main.bounds.height * 0.7, width: 70, height: 70)
//        cameraButton.layer.cornerRadius = 35
//        cameraButton.backgroundColor = UIColor.red
//        cameraButton.layer.borderColor = UIColor.white.cgColor
//        cameraButton.layer.borderWidth = 5
//        camPreview.addSubview(cameraButton)

        recordLabel.frame = CGRect(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.03, width: 120, height: 50)
        camPreview.addSubview(recordLabel)
        recordLabel.backgroundColor = .white
        recordLabel.isHidden = true
       
    }
    
    @objc func innersquareViewButtonAction() {
        stopRecording()
        recordLabel.isHidden = false
        innerSquareView.isHidden = true
        squareView.isHidden = false
    }
    @objc func squareViewButtonAction() {
            recordLabel.isHidden = false
            startRecording()
            squareView.isHidden = true
            innerSquareView.isHidden = false
    }
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 20, y: 0, width: camPreview.frame.width, height: camPreview.frame.height * 0.9)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreview.layer.addSublayer(previewLayer)

    }
    func timeFormatted(totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //       let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d min", minutes, seconds)
    }
    //MARK: func for button shape
    func btnShape() {
//        cameraButton.frame = CGRect(x: UIScreen.main.bounds.width * 0.45, y: UIScreen.main.bounds.height * 0.7, width: 70, height: 70)
        cameraButton.layer.cornerRadius = 35
        cameraButton.layer.borderWidth = 5
        cameraButton.layer.borderColor = UIColor.black.cgColor
        
    }
    func forConstraints() {
        camPreview.addSubview(cameraButton)
        cameraButton.addSubview(squareView)
        NSLayoutConstraint.activate([
            cameraButton.widthAnchor.constraint(equalToConstant: 70),
            cameraButton.heightAnchor.constraint(equalToConstant: 70),
            cameraButton.centerXAnchor.constraint(equalTo: camPreview.centerXAnchor ),
            cameraButton.bottomAnchor.constraint(equalTo: camPreview.bottomAnchor, constant: 5),
          
            squareView.widthAnchor.constraint(equalToConstant: 60),
            squareView.heightAnchor.constraint(equalToConstant: 60),
            squareView.centerXAnchor.constraint(equalTo: cameraButton.centerXAnchor),
            squareView.bottomAnchor.constraint(equalTo: cameraButton.bottomAnchor),
            ])
    }

    //MARK:- Setup Camera
    
    func setupSession() -> Bool {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // Setup Camera
        let camera = AVCaptureDevice.default(for: AVMediaType.video)!
        
        do {
            
            let input = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        
        // Setup Microphone
        let microphone = AVCaptureDevice.default(for: AVMediaType.audio)!
        
        do {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
        
        
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        return true
    }
    
    @objc func record() {
        self.currentTimeCounter += 1
        self.recordLabel.text = self.timeFormatted(totalSeconds: self.currentTimeCounter  )
        
        
    }
    
    //MARK: Camera Session
    func startSession() {
        
        if !captureSession.isRunning {
            //          videoQueue().async {
            DispatchQueue.global().async {
                self.captureSession.startRunning()
                
            }
            
            
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
//    func currentVideoOrientation() -> AVCaptureVideoOrientation {
//        var orientation: AVCaptureVideoOrientation
//
//        switch UIDevice.current.orientation {
//        case .portrait:
//           // previewLayer.frame = UIScreen.main.bounds
//            orientation = AVCaptureVideoOrientation.portrait
//        case .landscapeRight:
//            previewLayer.frame = UIScreen.main.bounds
//            orientation = AVCaptureVideoOrientation.landscapeLeft
//        case .portraitUpsideDown:
//            previewLayer.frame = UIScreen.main.bounds
//            orientation = AVCaptureVideoOrientation.portraitUpsideDown
//        default:
//            previewLayer.frame = UIScreen.main.bounds
//            orientation = AVCaptureVideoOrientation.landscapeRight
//        }
        
//        return orientation
//    }
    

    

    //EDIT 1: I FORGOT THIS AT FIRST
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! RecordingViewController
        
        vc.videoUrl = sender as? URL
        
    }
    
    func startRecording() {
        
        if movieOutput.isRecording == false {
            currentTimeCounter = 0
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.record), userInfo: nil, repeats: true)
            
            let connection = movieOutput.connection(with: AVMediaType.video)
            
//            if (connection?.isVideoOrientationSupported)! {
//                connection?.videoOrientation = currentVideoOrientation()
//            }
            
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = activeInput.device
            
            if (device.isSmoothAutoFocusSupported) {
                
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
                
            }
            
            //EDIT2: And I forgot this
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
            
        }
        else {
            
            stopRecording()
            
        }
        
    }

    func stopRecording() {
        
        if movieOutput.isRecording == true {
            
            movieOutput.stopRecording()
            timer?.invalidate()
            timer = nil
            recordLabel.text = timeFormatted(totalSeconds: 0)
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if (error != nil) {
            
            print("Error recording movie: \(error!.localizedDescription)")
            
        } else {
            
            let videoRecorded = outputURL! as URL
            
            performSegue(withIdentifier: "showVideo", sender: videoRecorded)
            
        }
        
    }
    
}


