from flask import Flask, request, jsonify
from pymongo import MongoClient
import requests

# =========================
# FLASK
# =========================

app = Flask(__name__)

# =========================
# MONGODB
# =========================

MONGO_URI = "mongodb://127.0.0.1:27017/"

client = MongoClient(MONGO_URI)

db = client["np_app"]
coleccion = db["users"]

# =========================
# ESP32
# =========================

ESP32_IP = "192.168.1.120"  # "192.168.1.241"

# =========================http://192.168.1.120/
# RUTA LOGIN
# =========================

@app.route("/loginUser", methods=["POST"])
def login_user():

    try:

        data = request.json

        email = data.get("email")

        print("Email recibido:", email)

        # Buscar usuario
        usuario = coleccion.find_one({
            "email": email
        })

        if not usuario:
            return jsonify({
                "ok": False,
                "message": "Usuario no encontrado"
            }), 404

        # Datos usuario
        nombre = usuario.get("name", "SinNombre")
        tipo_home = usuario.get("tipoHome", "sano")

        print("Nombre:", nombre)
        print("Perfil:", tipo_home)

        # =========================
        # ENVIAR AL ESP32
        # =========================

        url = f"http://{ESP32_IP}/config"

        datos_esp32 = {
            "name": nombre,
            "tipoHome": tipo_home
        }

        r = requests.post(
            url,
            json=datos_esp32,
            timeout=5
        )

        print("Respuesta ESP32:", r.text)

        return jsonify({
            "ok": True,
            "nombre": nombre,
            "tipoHome": tipo_home,
            "respuestaESP32": r.text
        })

    except Exception as e:

        print("Error:", e)

        return jsonify({
            "ok": False,
            "error": str(e)
        }), 500

# =========================
# MAIN
# =========================

if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000,
        debug=True
    )