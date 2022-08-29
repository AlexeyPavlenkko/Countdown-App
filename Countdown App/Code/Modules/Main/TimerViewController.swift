//
//  TimerViewController.swift
//  Countdown App
//
//  Created by Алексей Павленко on 29.08.2022.
//

import UIKit

class TimerViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerContainerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var pauseResumeView: UIView!
    @IBOutlet weak var resetView: UIView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Variables
    public var cdtaskViewModel: CDTaskViewModel!
    
    private var totalSeconds = 0 {
        didSet {
            self.timerSeconds = totalSeconds
        }
    }
    
    private var timerSeconds = 0
    
    private let timerTrackLayer = CAShapeLayer()
    private let timerCircleFillLayer = CAShapeLayer()
    
    private var timerState: CountDownState = .suspended
    private var countdownTimer = Timer()

    private lazy var timerEndAnimation: CABasicAnimation = {
       let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 0
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = true
        return strokeEnd
    }()
    
    private lazy var timerResetAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 1
        strokeEnd.duration = 1
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = false
        return strokeEnd
    }()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.setupLayers()
        }
    }
    
    //MARK: - Actions & objc methods
    @IBAction private func closeButtonTapped(_ sender: UIButton) {
        self.timerTrackLayer.removeFromSuperlayer()
        self.timerCircleFillLayer.removeFromSuperlayer()
        self.countdownTimer.invalidate()
        guard let newCDTaskVC = self.presentingViewController as? NewCDTaskViewController else {return}
        newCDTaskVC.dismiss(animated: true)
        newCDTaskVC.resetTask()
    }
    
    @IBAction private func startButtonPressed(_ sender: UIButton) {
        guard timerState == .suspended else { return }
        self.timerEndAnimation.duration = Double(self.timerSeconds)
        
        self.animatePauseButton(symbolName: "pause.fill")
        //self.animatePlayPauseResetViews(timerIsPlaying: true)
        self.setupPlayPauseResetViews(timerIsPlaying: true)
        
        self.startTimer()
    }
    
    @IBAction private func pauseResumeButtonPressed(_ sender: UIButton) {
        switch timerState {
        case .running:
            self.timerState = .paused
            self.timerCircleFillLayer.strokeEnd = CGFloat(timerSeconds) / CGFloat(totalSeconds)
            self.countdownTimer.invalidate()
            self.timerCircleFillLayer.removeAllAnimations()
            self.animatePauseButton(symbolName: "play.fill")
            
        case .paused:
            self.timerState = .running
            self.timerEndAnimation.duration = Double(timerSeconds) + 1
            self.startTimer()
            self.animatePauseButton(symbolName: "pause.fill")
        default: break
        }
    }
    
    @IBAction private func resetButtonPressed(_ sender: Any) {
        self.resetTimer()
    }
    
    //MARK: - Methods
    override class func description() -> String {
        return "TimerViewController"
    }
    
    private func initialSetup() {
        let cdtask = self.cdtaskViewModel.getTask()
        self.totalSeconds = cdtask.seconds
        self.taskTitleLabel.text = cdtask.name
        self.descriptionLabel.text = cdtask.description
        self.imageView.image = UIImage(systemName: cdtask.taskType.symbolName)
        
        self.setupCornerRadiuses()
        self.setupViews()
        self.initialTransform()
        self.updateLabels()
        self.addCircles()
    }
    
    private func setupViews() {
        [pauseResumeView, resetView].forEach { $0?.isHidden = true }
        
        [playView, pauseResumeView, resetView].forEach { $0?.layer.cornerRadius = 15 }
    }
    
    private func initialTransform() {
        timerView.transform = timerView.transform.rotated(by: 270.degreeToRadians())
        timerLabel.transform = timerLabel.transform.rotated(by: 90.degreeToRadians())
        timerContainerView.transform = timerContainerView.transform.rotated(by: 90.degreeToRadians())
    }
    
    private func setupCornerRadiuses() {
        self.imageContainerView.layer.cornerRadius = self.imageContainerView.frame.width / 2
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
        self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
    }
    
    private func setupLayers() {
        let radius = self.timerView.frame.width < self.timerView.frame.height ? self.timerView.frame.width / 2 : self.timerView.frame.height / 2
        let arcCenter = CGPoint(x: timerView.frame.height / 2, y: timerView.frame.width / 2)
        let arcPath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: 0, endAngle: 360.degreeToRadians(), clockwise: true)
        
        self.timerTrackLayer.path = arcPath.cgPath
        self.timerTrackLayer.strokeColor = UIColor.lightBlueColor.cgColor
        self.timerTrackLayer.lineWidth = 20
        self.timerTrackLayer.fillColor = UIColor.clear.cgColor
        self.timerTrackLayer.lineCap = .round
        
        self.timerCircleFillLayer.path = arcPath.cgPath
        self.timerCircleFillLayer.strokeColor = UIColor.whiteColor.cgColor
        self.timerCircleFillLayer.lineWidth = 21
        self.timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        self.timerCircleFillLayer.lineCap = .round
        self.timerCircleFillLayer.strokeEnd = 1
        
        self.timerView.layer.addSublayer(timerTrackLayer)
        self.timerView.layer.addSublayer(timerCircleFillLayer)
    }
    
    private func startTimer() {
        self.updateLabels()
        
        self.countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.timerSeconds -= 1
            self.updateLabels()
            if self.timerSeconds == 0 {
                self.resetTimer()
            }
        })
        
        self.timerState = .running
        self.timerCircleFillLayer.add(self.timerEndAnimation, forKey: "timerEnd")
    }
    
    private func updateLabels() {
        let seconds = self.timerSeconds % 60
        let minutes = (self.timerSeconds / 60) % 60
        let hours   = self.timerSeconds / 3600
        
        if hours > 0 {
            self.timerLabel.text = "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes > 0 && seconds == 0 {
            self.timerLabel.text = "\(minutes)m "
        }else if minutes > 0 {
            self.timerLabel.text = "\(minutes)m \(seconds)s"
        } else if seconds > 0 {
            self.timerLabel.text = "\(seconds)s"
        }
    }
    
    private func resetTimer() {
        self.countdownTimer.invalidate()
        self.timerCircleFillLayer.removeAllAnimations()
        self.timerSeconds = self.totalSeconds
        self.updateLabels()
        self.timerState = .suspended
        self.timerCircleFillLayer.add(timerResetAnimation, forKey: "reset")
        self.setupPlayPauseResetViews(timerIsPlaying: false)
    }
    
    private func animatePauseButton(symbolName: String) {
        self.pauseResumeButton.setImage(UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold, scale: .default)), for: .normal)
    }
    
    private func setupPlayPauseResetViews(timerIsPlaying: Bool) {
        self.playView.isHidden = timerIsPlaying ? true : false
        self.pauseResumeView.isHidden = timerIsPlaying ? false : true
        self.resetView.isHidden = timerIsPlaying ? false : true
    }
    
    private func addCircles() {
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: 50, y: self.view.frame.height - 20), radius: 130, startAngle: 0, endAngle: 360.degreeToRadians(), clockwise: true).cgPath
        circleLayer.fillColor = UIColor.superLightBlueColor.cgColor
        circleLayer.opacity = 0.20
        
        let circleLayer2 = CAShapeLayer()
        circleLayer2.path = UIBezierPath(arcCenter: CGPoint(x: self.view.frame.width, y: 50), radius: 110, startAngle: 0, endAngle: 360.degreeToRadians(), clockwise: true).cgPath
        circleLayer2.fillColor = UIColor.superLightBlueColor.cgColor
        circleLayer2.opacity = 0.20
        
        self.view.layer.insertSublayer(circleLayer, below: self.view.layer)
        self.view.layer.insertSublayer(circleLayer2, below: self.view.layer)
        
        self.view.bringSubviewToFront(closeButton)
        self.view.bringSubviewToFront(descriptionLabel)
        self.view.bringSubviewToFront(taskTitleLabel)
        self.view.bringSubviewToFront(pauseResumeView)
        self.view.bringSubviewToFront(playView)
    }
}
