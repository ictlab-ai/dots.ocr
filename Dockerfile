FROM python:3.10-slim

# рабочая директория
WORKDIR /app

# Ставим системные зависимости (git нужен для установки dots.ocr)
RUN apt-get update && apt-get install -y git

# Устанавливаем dots.ocr из GitHub
RUN pip install --no-cache-dir git+https://github.com/ictlab-ai/dots.ocr.git

# Устанавливаем Flask
RUN pip install flask

# Копируем наш API внутрь контейнера
COPY ocr_api.py /app/

# Запускаем API
CMD ["python", "ocr_api.py"]
