# Полноценный Python образ
FROM python:3.10

WORKDIR /app

# Системные зависимости
RUN apt-get update && apt-get install -y \
    git build-essential libmagic-dev poppler-utils libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip
RUN python -m pip install --upgrade pip setuptools wheel

# Устанавливаем PyTorch (CPU-версия)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Устанавливаем dots.ocr
RUN pip install --no-cache-dir git+https://github.com/ictlab-ai/dots.ocr.git

# Устанавливаем Flask
RUN pip install --no-cache-dir flask

# Копируем Flask API
COPY ../ocr_api.py /app/

# Запуск
CMD ["python", "ocr_api.py"]
