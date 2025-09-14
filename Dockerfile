# Используем лёгкий Python образ
FROM python:3.10-slim

# Рабочая директория
WORKDIR /app

# Устанавливаем системные зависимости для OCR и сборки Python-пакетов
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3-dev libffi-dev libssl-dev libjpeg-dev zlib1g-dev \
    libmagic-dev poppler-utils libgl1 libglib2.0-0 \
    tesseract-ocr libleptonica-dev \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip, setuptools и wheel
RUN python -m pip install --upgrade pip setuptools wheel

# Устанавливаем Python-зависимости: CPU-PyTorch, Flask, tqdm и другие нужные
ENV FORCE_CUDA=0
RUN pip install --no-cache-dir \
    torch torchvision torchaudio \
    flask tqdm numpy pillow

# Копируем локальный пакет dots_ocr в контейнер как dots
COPY dots_ocr /app/dots

# Копируем Flask API
COPY ocr_api.py /app/

# Экспонируем порт (Render назначает свой через переменную PORT)
EXPOSE 5000

# Запуск Flask
CMD ["python", "ocr_api.py"]
