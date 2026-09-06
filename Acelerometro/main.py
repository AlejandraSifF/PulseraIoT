from acelerometro import Acelerometro
import time


mpu = Acelerometro()


print("TecnoLYB - Sensor MPU6050 iniciado")


while True:

    ax, ay, az = mpu.obtener_g()

    print("================")
    print("Aceleración")
    print("X:", round(ax,2),"g")
    print("Y:", round(ay,2),"g")
    print("Z:", round(az,2),"g")


    time.sleep(1)