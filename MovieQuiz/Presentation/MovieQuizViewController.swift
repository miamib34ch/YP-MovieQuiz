import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // делает статус бар светлым (у нас всегда темный фон и поэтому внезависимости от темы афйона статус бар будет светлым)
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    private var alertPresenter: AlertPresenterProtocol? // "какой-то" вызыватель алертов, который соответствует протоколу
    private var presenter: MovieQuizPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        // настройка внешнего вида
        imageView.layer.masksToBounds = true // включаем маску, которая изменяется для создания эффектов границ и углов
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        // делегируем показ алерта классу AlertPresenter
        alertPresenter = AlertPresenter(delegate: self)
        
        // делаем кнопки недоступными, поскольку в начале данные загружаются
        buttonsEnabled(isEnabled: false)
        
    }
    
    @IBAction private func yesButtonClicked() {
        presenter?.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked() {
        presenter?.noButtonClicked()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func buttonsEnabled(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func showNetworkDataError(message: String) {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        
        // создаём модель алерта с ошибкой
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз"){[weak self] in
            guard let self = self else { return }
            
            self.presenter?.restartGame()
        }
        
        alertPresenter?.show(model: model)
    }
    
    func showNetworkImageError(message: String) {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        
        // создаём модель алерта с ошибкой
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё раз"){[weak self] in
            guard let self = self else { return }
            
            // показываем индикатор
            self.showLoadingIndicator()
            // начинаем загрузку картинки заново
            self.presenter?.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(model: model)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    func show(quiz result: QuizResultsViewModel) {
        
        var finalMessage = result.text // итоговый текст алерта
        
        if let presenter = self.presenter {
            finalMessage += presenter.makeResultsMessage()
        }
        
        // создаём модель с данными прошедшой игры
        let model = AlertModel(title: result.title,
                               message: finalMessage,
                               buttonText: result.buttonText){[weak self] in
            guard let self = self else {return}
            
            self.presenter?.restartGame()
        }
        
        alertPresenter?.show(model: model)
    }
}
