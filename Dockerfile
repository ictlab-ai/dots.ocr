FROM python:3.10-slim

WORKDIR /app

# Системные зависимости
RUN apt-get update && apt-get install -y git

# Устанавливаем dots.ocr
RUN pip install --no-cache-dir git+https://github.com/ictlab-ai/dots.ocr.git

# Устанавливаем Flask
RUN pip install --no-cache-dir flask

# Копируем наш API
COPY ocr_api.py /app/

# Запускаем API
CMD ["python", "ocr_api.py"]
