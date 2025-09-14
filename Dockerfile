# Лёгкий Python образ
FROM python:3.10-slim

# Рабочая директория
WORKDIR /app

# Системные зависимости для сборки Python-пакетов и OCR
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential python3-dev libffi-dev libssl-dev libjpeg-dev zlib1g-dev \
    libmagic-dev poppler-utils libgl1 libglib2.0-0 \
    tesseract-ocr libleptonica-dev \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip, setuptools и wheel
RUN python -m pip install --upgrade pip setuptools wheel

# Переменная, чтобы сборка не искала CUDA
ENV FORCE_CUDA=0

# Устанавливаем PyTorch CPU-версию
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Клонируем dots.ocr и ставим через setup.py
RUN git clone https://github.com/ictlab-ai/dots.ocr.git /dots.ocr
RUN cd /dots.ocr && python setup.py install

# Устанавливаем Flask
RUN pip install --no-cache-dir flask

# Копируем Flask API
COPY ocr_api.py /app/

# Экспонируем условный порт (Render назначает свой через переменную PORT)
EXPOSE 5000

# Запуск Flask с универсальным портом
CMD ["sh", "-c", "python ocr_api.py"]
