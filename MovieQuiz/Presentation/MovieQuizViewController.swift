import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // делает статус бар светлым (у нас всегда темный фон и поэтому внезависимости от темы афйона статус бар будет светлым)
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    private var currentQuestionIndex: Int = 0 //номер текущего вопроса
    private var correctAnswers: Int = 0 //количество правильных ответов
    private let questionsAmount: Int = 10 //лимит вопросов в игре
    private var currentQuestion: QuizQuestion? //текущий вопрос
    
    private var statisticMessage: String = ""
    
    private var questionFactory: QuestionFactoryProtocol? //"какая-то" фабрика вопросов, которая соответствует протоколу
    private var alertPresenter: AlertPresenterProtocol? //"какой-то" вызыватель алертов, который соответствует протоколу
    private var statisticService: StatisticService? //"какая-то" статистика, которая соответствует протоколу
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // подтягиваем наши рекорды
        statisticService = StatisticServiceImplementation()
        
        // настройка внешнего вида
        imageView.layer.masksToBounds = true // включаем маску, которая изменяется для создания эффектов границ и углов
        imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        // делегируем создание вопросов классу QuestionFactory
        questionFactory = QuestionFactory(delegate: self)
        
        // делегируем показ алерта классу AlertPresenter
        alertPresenter = AlertPresenter(delegate: self)
        
        // показываем первый вопрос
        questionFactory?.requestNextQuestion()
    }
    
    @IBAction private func yesButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked() {
        guard let currentQuestion = currentQuestion else {
            return
        }
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
        if currentQuestionIndex == questionsAmount - 1 {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers) из \(questionsAmount)",
                buttonText: "Сыграть ещё раз")
            statisticService?.store(correct: correctAnswers, total: questionsAmount) //сохраняем статистику
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion() 
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        //создаём сообщение со статистикой
        if let statisticService = statisticService {
            let count = "Количество сыгранных квизов: \(statisticService.gamesCount)"
            let record = "Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) \(statisticService.bestGame.date)"
            let accuracy = "Средняя точность \(String(format: "%.2f", statisticService.totalAccuracy/Double(statisticService.gamesCount)*100))%"
            statisticMessage = count + "\n" + record + "\n" + accuracy
        }
        else {
        }
        
        var finalMessage = result.text
        
        if statisticMessage != "" {
            finalMessage += "\n"
            finalMessage += statisticMessage
        }
        
        //создаём модель с данными прошедшой игры
        let model = AlertModel(title: result.title,
                               message: finalMessage,
                               buttonText: result.buttonText){[weak self] in
            guard let self = self else {return}
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(model: model)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(), // распаковываем картинку
            question: model.text, // берём текст вопроса
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)") // высчитываем номер вопроса
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.show(quiz: viewModel)
        }
    }
}
