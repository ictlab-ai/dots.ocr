FROM python:3.10-slim

WORKDIR /app

# Системные зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3-dev libffi-dev libssl-dev libjpeg-dev zlib1g-dev \
    libmagic-dev poppler-utils libgl1 libglib2.0-0 \
    tesseract-ocr libleptonica-dev \
    && rm -rf /var/lib/apt/lists/*

# pip
RUN python -m pip install --upgrade pip setuptools wheel

# CPU PyTorch
ENV FORCE_CUDA=0
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Flask
RUN pip install --no-cache-dir flask

# Копируем свой локальный пакет dots_ocr
COPY dots_ocr /app/dots

# Копируем Flask API
COPY ocr_api.py /app/

EXPOSE 5000

# Запуск Flask
CMD ["python", "ocr_api.py"]
