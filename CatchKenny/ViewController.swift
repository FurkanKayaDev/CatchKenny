import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    var tapGestureRecognizer: UITapGestureRecognizer!
    var myImage = UIImage()
    var timer = Timer()
    var counter = 0
    var score = 0
    var x: CGFloat = 0.0
    var y: CGFloat = 0.0

    var imageView: UIImageView!
    
    // UserDefaults anahtar kelimesi
    let highScoreKey = "HighScore"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentHighScore = UserDefaults.standard.integer(forKey: highScoreKey)
        highscoreLabel.text = "High Score: \(currentHighScore)"

        counter = 10
        timeLabel.text = "Time: \(counter)"
        scoreLabel.text = "Score: 0"
        
        // geri sayım
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        generateNewXY()
        
        myImage = UIImage(named: "kenny")!
        imageView = UIImageView(image: myImage)
        imageView.frame = CGRect(x: x, y: y, width: 100, height: 150)
        view.addSubview(imageView)
        
        // image'e tıklama olayını ekliyoruz
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func timerFunction() {
        if counter <= 0 {
            let currentHighScore = UserDefaults.standard.integer(forKey: highScoreKey)
            if (score > currentHighScore) {
                UserDefaults.standard.set(score, forKey: highScoreKey)
                highscoreLabel.text = "High Score: \(String(score))"
                makeAlert(title: "Congratulations", message: "New High Score: \(score)")
            } else {
                makeAlert(title: "Time's Up", message: "Do you want to play again?")
            }
            timer.invalidate()
        }
        timeLabel.text = "Time: \(counter)"
        counter -= 1
        generateNewXY()
        updateImageViewPosition()
    }

    func generateNewXY() {
        // x için 0-250 arası, y için  150-500 arası rastgele sayı üretiyoruz
        x = CGFloat(arc4random_uniform(251))
        y = CGFloat(Int.random(in: 150...500))
    }

    func updateImageViewPosition() {
        // resmin konumunu ayarlıyorum
        imageView.frame = CGRect(x: x, y: y, width: 100, height: 150)
    }

    @objc func imageTapped() {
        // resme basıldığında score değerini artırıp, daha sonra yeni x ve y değeri üretip image'in konumunu güncelliyoruz
        if (self.counter >= 0) {
            score += 1
            scoreLabel.text = "Score: \(score)"
            generateNewXY()
            updateImageViewPosition()
        }
    }
    @IBAction func startButton(_ sender: Any) {
        if (self.counter <= 0) {
            self.timeLabel.text = "Time: 10"
            self.counter = 10
            self.score = 0
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: true)
            self.scoreLabel.text = "Score: 0"
        }
    }
    
    func makeAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (action) in
            self.startButton(self)
        }
        alert.addAction(okButton)
        alert.addAction(replayButton)
        self.present(alert, animated: true)
    }
}
