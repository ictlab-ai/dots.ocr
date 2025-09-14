FROM python:3.10-slim

WORKDIR /app

# Системные зависимости
RUN apt-get update && apt-get install -y \
    git build-essential libmagic-dev poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Обновляем pip
RUN python -m pip install --upgrade pip setuptools wheel

# Ставим PyTorch (CPU-версия)
RUN pip install --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Теперь можно ставить dots.ocr
RUN pip install --no-cache-dir git+https://github.com/ictlab-ai/dots.ocr.git

# Ставим Flask
RUN pip install --no-cache-dir flask

# Копируем API
COPY ../ocr_api.py /app/

# Запуск
CMD ["python", "ocr_api.py"]
