# Лёгкий Python образ
FROM python:3.10-slim

WORKDIR /app

# Системные зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    git build-essential python3-dev libffi-dev libssl-dev libjpeg-dev zlib1g-dev \
    libmagic-dev poppler-utils libgl1 libglib2.0-0 \
    tesseract-ocr libleptonica-dev \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip, setuptools и wheel
RUN python -m pip install --upgrade pip setuptools wheel

# CPU PyTorch
ENV FORCE_CUDA=0
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Копируем dots.ocr напрямую
RUN git clone https://github.com/ictlab-ai/dots.ocr.git /tmp/dots.ocr
COPY /tmp/dots.ocr/dots /app/dots

# Flask
RUN pip install --no-cache-dir flask

# Копируем API
COPY ocr_api.py /app/

EXPOSE 5000
CMD ["sh", "-c", "python ocr_api.py"]
