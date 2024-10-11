# Задача

## Подготовка к выполнению практики

1. У вас должны быть установлены:
  - docker
  - docker-compose
  - git

2. Склонируйте репозиторий

`git clone git@github.com:thinknetica/ruby_debug_homework.git`

ветка `day2_homework`

3. Сборка проекта:

```bash
cd ruby_debug_homework
docker-compose build
docker-compose up -d
```

5. Выполнить миграции для тестовой БД:
```bash
docker-compose exec web bash
bundle exec rails db:create db:migrate RAILS_ENV=test
```

## Задание

Добейтесь успешного прогона всех тестов
в контейнере web с заданным SEED:

```bash
docker-compose exec web bash
bundle exec rspec spec --seed 1707
```
