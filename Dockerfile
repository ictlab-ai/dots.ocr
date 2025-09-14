# Полноценный Python образ
FROM python:3.10

WORKDIR /app

# Системные зависимости для сборки пакетов Python и OCR
RUN apt-get update && apt-get install -y \
    git build-essential libmagic-dev poppler-utils libgl1 libglib2.0-0 \
    python3-dev libffi-dev libssl-dev libjpeg-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip, setuptools и wheel
RUN python -m pip install --upgrade pip setuptools wheel

# Устанавливаем PyTorch (CPU-версия)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Клонируем dots.ocr и устанавливаем локально
RUN git clone https://github.com/ictlab-ai/dots.ocr.git /dots.ocr
RUN pip install --no-cache-dir /dots.ocr

# Устанавливаем Flask
RUN pip install --no-cache-dir flask

# Копируем Flask API
COPY ../ocr_api.py /app/

# Запуск
CMD ["python", "ocr_api.py"]
