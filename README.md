# IMDBFinder
Данный проект представляет собой простое приложение для поиска фильмов на сайте IMDB. Пользователь может ввести название фильма в поисковую строку и получить список фильмов, соответствующих запросу.
Используемые технологии
UIKit - фреймворк для создания пользовательских интерфейсов
MVP - шаблон проектирования для разделения логики приложения на отдельные компоненты
GCD - технология Grand Central Dispatch для управления многопоточностью
SnapKit - библиотека для упрощения работы с Auto Layout
#Установка
Для установки приложения необходимо склонировать репозиторий на свой компьютер и установить зависимости с помощью CocoaPods. Для этого нужно выполнить следующие команды в терминале:
git clone https://github.com/ma14ew/IMDBFinder.git
cd IMDBFinder
pod install
После установки зависимостей можно открыть файл проекта IMDBFinder.xcworkspace в Xcode и запустить приложение на симуляторе или на устройстве.
#Использование
При запуске приложения пользователь увидит экран с поисковой строкой. После ввода названия фильма и нажатия на "enter" приложение отправит запрос на сервер IMDB-APi и получит список фильмов, соответствующих запросу. Список фильмов будет отображен на следующем экране в виде таблицы.