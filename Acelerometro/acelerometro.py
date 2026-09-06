import time
from machine import Pin, I2C
from mpu6050 import accel


class Acelerometro:

    def __init__(self):

        i2c = I2C(
            0,
            scl=Pin(22),
            sda=Pin(21),
            freq=400000
        )

        self.sensor = accel(i2c)


    def obtener_aceleracion(self):

        datos = self.sensor.get_values()

        ax = datos["AcX"] / 16384
        ay = datos["AcY"] / 16384
        az = datos["AcZ"] / 16384

        return ax, ay, az


    def obtener_magnitud(self):

        ax, ay, az = self.obtener_aceleracion()

        magnitud = (
            ax**2 +
            ay**2 +
            az**2
        )**0.5

        return magnitud


    def detectar_impacto(self):

        magnitud = self.obtener_magnitud()

        if magnitud > 2.2:
            return True

        return False


    def detectar_caida_libre(self):

        magnitud = self.obtener_magnitud()

        if magnitud < 0.5:
            return True

        return False


    def detectar_caida(self):

        # Primera etapa: detectar caída libre
        magnitud = self.obtener_magnitud()

        if magnitud < 0.5:

            print("⬇️ Caída libre detectada")

            # Tiempo máximo para esperar el impacto
            tiempo_inicio = time.ticks_ms()

            while time.ticks_diff(
                time.ticks_ms(),
                tiempo_inicio
            ) < 1000:

                magnitud = self.obtener_magnitud()

                # Segunda etapa: detectar impacto
                if magnitud > 2.2:

                    print("💥 Impacto detectado")

                    return True

                time.sleep(0.05)


        return False
    
    def detectar_reposo(self):

        lecturas = []

        for i in range(10):

            magnitud = self.obtener_magnitud()

            lecturas.append(magnitud)

            time.sleep(0.1)


        promedio = sum(lecturas) / len(lecturas)


        if 0.8 < promedio < 1.5:

            return True


        return False