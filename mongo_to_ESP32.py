from pymongo import MongoClient
import requests
import time

# =========================
# CONFIGURACIÓN MONGODB
# =========================

MONGO_URI = "mongodb://127.0.0.1:27017/"

client = MongoClient(MONGO_URI)

db = client["np_app"]
coleccion = db["users"]

# =========================
# CONFIG ESP32
# =========================http://192.168.1.241:80

ESP32_IP = "192.168.1.241"

# =========================
# LOOP PRINCIPAL
# =========================

while True:

    try:
        #usuario = coleccion.find_one() #encuentra el primero
        #usuario = coleccion.find_one({"name": "lesly"})
        usuarios = coleccion.find()

        for u in usuarios:
                print(u["name"])
        

        usuario = coleccion.find_one({"name": "mayor"})

        if usuario:

            nombre = usuario.get("name", "SinNombre")
            tipo_home = usuario.get("tipoHome", "sano")

            print("Nombre:", nombre)
            print("Perfil:", tipo_home)

            url = f"http://{ESP32_IP}/config"

            datos = {
                "name": nombre,
                "tipoHome": tipo_home
            }

            r = requests.post(
                url,
                json=datos,
                timeout=5
            )

            print("Respuesta ESP32:", r.text)

        else:
            print("No hay usuarios en MongoDB")

        time.sleep(10)

    except requests.exceptions.RequestException as e:
        print("Error conexión ESP32:", e)
        time.sleep(5)

    except Exception as e:
        print("Error general:", e)
        time.sleep(5)
