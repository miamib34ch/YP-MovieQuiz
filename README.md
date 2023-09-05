# **MovieQuiz**

## **Ссылки**

- [Макет Figma](https://www.figma.com/file/l0IMG3Eys35fUrbvArtwsR/YP-Quiz?node-id=34%3A243)  
- [API IMDb](https://imdb-api.com/api#Top250Movies-header)  
- [Шрифты](https://code.s3.yandex.net/Mobile/iOS/Fonts/MovieQuizFonts.zip)  
- [Скринкаст готового приложения]()  

## **Описание приложения**

- Одностраничное приложение с квизами о фильмах из топ-250 рейтинга и самых популярных фильмов IMDb. Пользователь приложения последовательно отвечает на вопросы о рейтинге фильма. По итогам каждого раунда игры показывается статистика о количестве правильных ответов и лучших результатах пользователя. Цель игры — правильно ответить на все 10 вопросов раунда.

## **Функциональные требования**

- При запуске приложения показывается сплеш-скрин;
- После запуска приложения показывается экран вопроса с текстом вопроса, картинкой и двумя вариантами ответа, “Да” и “Нет”, только один из них правильный;
- Вопрос квиза составляется относительно IMDb рейтинга фильма по 10-балльной шкале, например: "Рейтинг этого фильма больше 6?";
- Можно нажать на один из вариантов ответа на вопрос и получить отклик о том, правильный он или нет, при этом рамка фотографии поменяет цвет на соответствующий;
- После выбора ответа на вопрос через 1 секунду автоматически появляется следующий вопрос;
- После завершения раунда из 10 вопросов появляется алерт со статистикой пользователя и возможностью сыграть ещё раз;
- Статистика содержит: результат текущего раунда (количество правильных ответов из 10 вопросов), количество сыгранных квизов, рекорд (лучший результат раунда за сессию, дата и время этого раунда), статистику сыгранных квизов в процентном соотношении (среднюю точность);
- Пользователь может запустить новый раунд, нажав в алерте на кнопку "Сыграть еще раз";
- При невозможности загрузить данные пользователь видит алерт с сообщением о том, что что-то пошло не так, а также кнопкой, по нажатию на которую можно повторить сетевой запрос.

## **Технические требования**

- Приложение должно поддерживать устройства iPhone с iOS 13, предусмотрен только портретный режим.
- Элементы интерфейса адаптируются под разрешения экранов больших iPhone (13, 13 Pro Max) — верстка под SE и iPad не предусмотрена.
- Экраны соответствует макету — использованы верные шрифты нужных размеров, все надписи находятся на нужном месте, расположение всех элементов, размеры кнопок и отступы — точно такие же, как в макете.

## **Инструкция по запуску**
Для запуска потребуется [Xcode](https://developer.apple.com/xcode/)
1. Скачайте архив *ветки* или *релиз* из github:  
   1.1 Скачивание *ветки*:  
   <img width="1438" alt="image" src="https://github.com/miamib34ch/YP-MovieQuiz/assets/77894393/0ca98413-cd28-4068-973e-512d1502b80c">  
   1.2 Скачивание *релиза*:  
   <img width="1438" alt="image" src="https://github.com/miamib34ch/YP-MovieQuiz/assets/77894393/3f9d6a96-04b4-4fd9-9ba5-14aed1314fe2">  
   <img width="1438" alt="image" src="https://github.com/miamib34ch/YP-MovieQuiz/assets/77894393/d014997b-ab45-4f0a-85fb-95b130b1c9ca">  
2. Распакуйте архив и запустите проект:  
   2.1 Зайдите в распакованную папку:  
   <img width="914" alt="image" src="https://github.com/miamib34ch/YP-MovieQuiz/assets/77894393/3e1c54d0-27c0-4cee-82da-fbec4321733d">  
   2.2 Откройте файл *MovieQuiz.xcodeproj*:  
   <img width="914" alt="image" src="https://github.com/miamib34ch/YP-MovieQuiz/assets/77894393/db97b795-38c9-491b-be49-d878a12fa46f">  
   2.3 Появится окно, в котором нужно нажать *Trust and Open*:  
   <img width="255" alt="image" src="https://github.com/miamib34ch/YP-MovieQuiz/assets/77894393/c1682ba9-a047-46be-ba18-a851a0767dd0">  
3. В Xcode запустите приложение на симуляторе или на реальном устройстве.
