//
//  ViewController.swift
//  liveClock
//
//  Created by user250193 on 2/4/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var actionButton: UIButton!

    var liveTimer: Timer?
    var countdownTimer: Timer?
    var endTime: Date?
    var countdownDuration: TimeInterval? // Correctly declare the countdownDuration variable
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        startLiveClock()
        configureDatePicker()
        prepareAudioPlayer()
        actionButton.setTitle("Start Timer", for: .normal)
    }

    func startLiveClock() {
        liveTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateClockLabel()
        }
    }

    func updateClockLabel() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        clockLabel.text = formatter.string(from: now)

        // Change background based on AM or PM
        let hour = Calendar.current.component(.hour, from: now)
        let backgroundName = hour < 12 ? "morningImage" : "eveningImage"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: backgroundName)!)
    }

    func configureDatePicker() {
        datePicker.datePickerMode = .countDownTimer
    }

    func prepareAudioPlayer() {
        guard let soundURL = Bundle.main.url(forResource: "yourMusicFileName", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print("Unable to initialize audio player: \(error)")
        }
    }

    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if countdownTimer == nil {
            startCountdownTimer()
        } else {
            stopMusicAndResetTimer()
        }
    }

    func startCountdownTimer() {
        let countdownDuration = datePicker.countDownDuration
        endTime = Date().addingTimeInterval(countdownDuration)
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdownLabel()
        }

        actionButton.setTitle("Timer Running", for: .normal)
        datePicker.isHidden = true
    }

    func updateCountdownLabel() {
        guard let endTime = endTime else { return }
        let remainingTime = endTime.timeIntervalSinceNow
        if remainingTime <= 0 {
            countdownTimer?.invalidate()
            countdownTimer = nil
            countdownLabel.text = "00:00:00"
            playMusic()
            actionButton.setTitle("Stop Music", for: .normal)
        } else {
            let hours = Int(remainingTime) / 3600
            let minutes = Int(remainingTime) / 60 % 60
            let seconds = Int(remainingTime) % 60
            countdownLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
    }

    func playMusic() {
        audioPlayer?.play()
    }

    func stopMusicAndResetTimer() {
        if audioPlayer?.isPlaying ?? false {
            audioPlayer?.stop()
        }

        actionButton.setTitle("Start Timer", for: .normal)
        datePicker.isHidden = false
        countdownLabel.text = "00:00:00"
    }
}
