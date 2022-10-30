import UIKit

final class MovieQuizViewController: UIViewController {
    
    // делает статус бар светлым (у нас всегда темный фон и поэтому внезависимости от темы афйона статус бар будет светлым)
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // настройка внешнего вида
        imageView.layer.masksToBounds = true // включаем маску, которая изменяется для создания эффектов границ и углов
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        // показываем первый вопрос
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }
    
    @IBAction private func yesButtonClicked() {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked() {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        //подсчёт очков
        if isCorrect {
            correctAnswers += 1
        }
        
        // ограничиваем работу кнопок на время загрузки данных
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        // показываем рамку правильного или неправильного ответов
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        // через секунду показываем следующий вопрос и разрешаем работу кнопок
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers) из 10",
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)") // высчитываем номер вопроса
    }
}
