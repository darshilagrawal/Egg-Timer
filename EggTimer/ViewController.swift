import UIKit
import AVFoundation

class ViewController: UIViewController {
    let eggTimes = ["Soft":30,"Medium":40,"Hard":70]
    var secondsPassed=0
    var totalTime=0
    var timer=Timer()
    var firstSound: Bool = false
    var player: AVAudioPlayer?
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressEgg.layer.cornerRadius = 5
        progressEgg.clipsToBounds = true
        resetButton.isHidden = true
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = .darkText
        resetButton.layer.cornerRadius = 5
        resetButton.clipsToBounds = true
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
    }
    
    @objc func resetButtonClicked(){
        player?.stop()
        resetButton.isHidden = true
        outputScreen.text="How would you Like your Eggs"
        progressEgg.progress=0
        timer.invalidate()
        secondsPassed = 0
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
            player.numberOfLoops = -1
            resetButton.isHidden = false
            
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    @IBOutlet weak var outputScreen: UILabel!
    @IBOutlet weak var progressEgg: UIProgressView!
    
    
    @IBAction func hardnessSelector(_ sender: UIButton) {
        player?.stop()
        secondsPassed=0
        progressEgg.progress=0
        timer.invalidate()
        let hardness=sender.currentTitle!
        UIView.transition(with: sender,
                          duration: 0.6,
                          options: .transitionFlipFromLeft,
                          animations: {
        }, completion: nil)
        totalTime=eggTimes[hardness]!
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        
        if secondsPassed<totalTime {
            firstSound = false
            outputScreen.text="How would you Like your Eggs"
            secondsPassed += 1
            
            let progressTime=Float(secondsPassed)/Float(totalTime)
            //            print(progressTime)
            progressEgg.progress = progressTime
        } else {
            if firstSound == false {
                outputScreen.text="Done"
                playSound()
                firstSound = true
            }
        }
    }
}
