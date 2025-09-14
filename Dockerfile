FROM python:3.10

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git build-essential libmagic-dev poppler-utils \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir git+https://github.com/ictlab-ai/dots.ocr.git
RUN pip install --no-cache-dir flask

COPY ocr_api.py /app/

CMD ["python", "ocr_api.py"]
