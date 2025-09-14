# Используем полный образ Python 3.12
FROM python:3.12

WORKDIR /app

# Системные зависимости для сборки dots.ocr
RUN apt-get update && apt-get install -y \
    git build-essential libmagic-dev poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip, setuptools и wheel
RUN python -m pip install --upgrade pip setuptools wheel

# Устанавливаем dots.ocr и Flask
RUN pip install --no-cache-dir git+https://github.com/ictlab-ai/dots.ocr.git
RUN pip install --no-cache-dir flask

# Копируем API внутрь контейнера
COPY ocr_api.py /app/

# Запуск Flask
CMD ["python", "ocr_api.py"]
