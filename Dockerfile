# Базовый образ Python 3.12 (не slim, чтобы dots.ocr собирался корректно)
FROM python:3.12

# Рабочая директория внутри контейнера
WORKDIR /app

# Устанавливаем системные зависимости для сборки dots.ocr и Python пакетов
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libmagic-dev \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip, setuptools и wheel
RUN python -m pip install --upgrade pip setuptools wheel

# Устанавливаем dots.ocr и Flask
RUN pip install --no-cache-dir git+https://github.com/ictlab-ai/dots.ocr.git flask

# Копируем API внутрь контейнера
COPY ocr_api.py /app/

# Запуск Flask, порт берется из переменной $PORT для Render
CMD ["python", "ocr_api.py"]
