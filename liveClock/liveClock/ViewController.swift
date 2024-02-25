import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var actionButton: UIButton!
    
    var timer: Timer?
    var countdownTimer: Timer?
    var secondsRemaining: Int = 0
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLiveClock()
        setupBackground()
        datePicker.datePickerMode = .countDownTimer
        actionButton.setTitle("Start Timer", for: .normal)
    }
    
    func setupLiveClock() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
            self?.clockLabel.text = formatter.string(from: Date())
            self?.setupBackground()
        }
    }
    
    func setupBackground() {
        let hour = Calendar.current.component(.hour, from: Date())
        let backgroundImageName = hour < 12 ? "morningImage" : "eveningImage"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: backgroundImageName)!)
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if actionButton.titleLabel?.text == "Start Timer" {
            startTimer()
        } else {
            stopMusic()
        }
    }
    
    func startTimer() {
            print("Starting timer...")
            secondsRemaining = Int(datePicker.countDownDuration)

        secondsRemaining = Int(datePicker.countDownDuration)
        updateCountdownLabel()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.secondsRemaining -= 1
            self?.updateCountdownLabel()
            if self?.secondsRemaining == 0 {
                self?.countdownTimer?.invalidate()
                self?.playMusic()
            }
        }
        actionButton.setTitle("Stop Music", for: .normal)
    }
    
    func updateCountdownLabel() {
        let hours = secondsRemaining / 3600
        let minutes = (secondsRemaining % 3600) / 60
        let seconds = secondsRemaining % 60
        countdownLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "yourMusicFileName", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Couldn't load the music file.")
        }
        actionButton.setTitle("Stop Music", for: .normal)
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        actionButton.setTitle("Start Timer", for: .normal)
    }
}
