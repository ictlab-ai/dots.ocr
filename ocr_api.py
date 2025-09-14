import os
from flask import Flask, request, jsonify
import dots.ocr as dots

app = Flask(__name__)

# Токен для авторизации (защита API)
API_TOKEN = os.environ.get("OCR_API_TOKEN")  # берем из переменных окружения Render

@app.route("/ocr", methods=["POST"])
def ocr():
    # Проверяем токен, если он задан
    if API_TOKEN:
        token = request.headers.get("X-API-Token", "")
        if token != API_TOKEN:
            return jsonify({"error": "unauthorized"}), 401

    # Проверяем, что файл загружен
    if "file" not in request.files:
        return jsonify({"error": "no file uploaded"}), 400

    f = request.files["file"]
    try:
        # Считываем текст с картинки через dots.ocr
        text = dots.read(f.stream)
        return jsonify({"text": text})
    except Exception as e:
        return jsonify({"error": "ocr_failed", "details": str(e)}), 500

if __name__ == "__main__":
    # Render автоматически задает порт через переменную окружения $PORT
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
