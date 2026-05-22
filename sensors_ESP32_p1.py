#este nuevo es con el ssd agregado
# =============================
# ESP32 + MAX30102 + MLX90614 + Web
# =============================
import framebuf
import network
import socket
import machine
import time

import math
from machine import SoftI2C, I2C, Pin

# -----------------------------
# Configuración Wi‑Fi
# -----------------------------
SSID = "LABSOL NETWORK"
PASSWORD = "L4b.50L1.N3t"
#-----------------------------

# -----------------------------
# Buzzer (PWM en GPIO 27)
# -----------------------------
buzzer = machine.PWM(machine.Pin(27), freq=1000, duty=0)

oled_display = None

pulso_bajo = 60
pulso_alto = 150

nombre_paciente = "Sin nombre"
perfil_usuario = "normal"
movimiento = "reposo"
edad = 60

def play_tone(freq, duration):
    buzzer.freq(freq)
    buzzer.duty(512)
    time.sleep(duration)
    buzzer.duty(0)

def play_melody(melody):
    for freq, dur in melody:
        buzzer.freq(freq)
        buzzer.duty(512)
        time.sleep(dur)
        buzzer.duty(0)
        time.sleep(0.05)

alarm_melody     = [(1000, 0.3), (800, 0.3), (1000, 0.3)]
christmas_melody = [(523, 0.3), (587, 0.3), (659, 0.3), (523, 0.3)]
police_melody    = [(1000, 0.2), (1500, 0.2)] * 5

# -----------------------------
# MAX30102 (HR/SpO2) en SoftI2C (GPIO 21/22)
# -----------------------------
i2c_hr = SoftI2C(sda=Pin(21), scl=Pin(22), freq=100000)
MAX30102_ADDR = 0x57

REG_INTR_STATUS_1 = 0x00
REG_INTR_STATUS_2 = 0x01
REG_INTR_ENABLE_1 = 0x02
REG_INTR_ENABLE_2 = 0x03
REG_FIFO_WR_PTR   = 0x04
REG_FIFO_OVF_CNT  = 0x05
REG_FIFO_RD_PTR   = 0x06
REG_FIFO_DATA     = 0x07
REG_FIFO_CONFIG   = 0x08
REG_MODE_CONFIG   = 0x09
REG_SPO2_CONFIG   = 0x0A
REG_LED1_PA       = 0x0C
REG_LED2_PA       = 0x0D

def _w(reg, val): i2c_hr.writeto_mem(MAX30102_ADDR, reg, bytes([val]))
def _r(reg, n=1): return i2c_hr.readfrom_mem(MAX30102_ADDR, reg, n)

def max30102_init():
    _w(REG_MODE_CONFIG, 0x40); time.sleep_ms(100)
    _w(REG_FIFO_WR_PTR, 0x00); _w(REG_FIFO_RD_PTR, 0x00); _w(REG_FIFO_OVF_CNT, 0x00)
    _w(REG_INTR_ENABLE_1, 0xC0); _w(REG_INTR_ENABLE_2, 0x00)
    _w(REG_FIFO_CONFIG, 0x4F)     # avg=4, rollover=1, afull=15
    _w(REG_SPO2_CONFIG, 0x27)     # ADC 2048, SR=100Hz, PW=411us
    _w(REG_LED1_PA, 0x24); _w(REG_LED2_PA, 0x24)
    _w(REG_MODE_CONFIG, 0x03)     # modo SpO2
    time.sleep_ms(50)

def read_sample_pair():
    data = _r(REG_FIFO_DATA, 6)
    red = ((data[0] << 16) | (data[1] << 8) | data[2]) & 0x3FFFF
    ir  = ((data[3] << 16) | (data[4] << 8) | data[5]) & 0x3FFFF
    return red, ir

# -----------------------------
# MLX90614 (Temperatura bebé) en I2C(0) (GPIO 33/32)
# -----------------------------
#mlx_i2c  = I2C(0, scl=Pin(33), sda=Pin(32), freq=100000)
#MLX_ADDR = 0x5A

def init_mlx90614():

    """
    Inicializa el bus I2C y el sensor MLX90614.
    Retorna el objeto sensor listo para usarse.
    """
    from machine import I2C, Pin
    import time

    class MLX90614:
        def __init__(self, i2c, addr=0x5A):
            self.i2c = i2c
            self.addr = addr

        def _read16(self, reg):
            data = self.i2c.readfrom_mem(self.addr, reg, 3)
            return data[0] | (data[1] << 8)

        def _temp(self, reg):
            raw = self._read16(reg)
            temp = raw * 0.02 - 273.15
            return temp

        def get_ambient_temp(self):
            return self._temp(0x06)

        def get_object_temp(self):
            return self._temp(0x07)

    # Configuración I2C para ESP32
    i2c = I2C(
        1,
        scl=Pin(33),
        sda=Pin(32),
        freq=100000
    )

    sensor = MLX90614(i2c)
    time.sleep(0.1)

    return sensor


def leer_temperatura_corporal(sensor, offset=0.0):
    """
    Lee la temperatura corporal desde el MLX90614.
    offset permite calibrar la lectura si es necesario.
    Retorna la temperatura en °C.
    """
    temp = sensor.get_object_temp()
    return temp + offset


sensor_temp = init_mlx90614()
def read_temp_obj(): return leer_temperatura_corporal(sensor_temp, offset=1)#(sensor_temp, offset=+1.5)

#sensor_temp = init_mlx90614()
# Leer temperatura corporal
#temperatura = leer_temperatura_corporal(sensor_temp)



# ==================================================
# DRIVER SSD1306 BASE
# ==================================================

class SSD1306(framebuf.FrameBuffer):
    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.pages = self.height // 8
        self.buffer = bytearray(self.pages * self.width)
        super().__init__(self.buffer, self.width, self.height, framebuf.MONO_VLSB)

    def init_display(self):
        for cmd in (
            0xAE, 0x20, 0x00, 0x40, 0xA1, 0xC8,
            0xDA, 0x12, 0x81, 0xCF, 0xA4, 0xA6,
            0xD5, 0x80, 0x8D, 0x14, 0xAF
        ):
            self.write_cmd(cmd)
        self.clear()

    def clear(self):
        self.fill(0)
        self.show()

    def show(self):
        for page in range(self.pages):
            self.write_cmd(0xB0 + page)
            self.write_cmd(0x00)
            self.write_cmd(0x10)
            self.write_data(
                self.buffer[self.width * page:self.width * (page + 1)]
            )


# ==================================================
# DRIVER SSD1306 I2C
# ==================================================

class SSD1306(framebuf.FrameBuffer):
    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.pages = self.height // 8
        self.buffer = bytearray(self.pages * self.width)
        super().__init__(self.buffer, self.width, self.height, framebuf.MONO_VLSB)

    def init_display(self):
        for cmd in (
            0xAE, 0x20, 0x00, 0x40, 0xA1, 0xC8,
            0xDA, 0x12, 0x81, 0xCF, 0xA4, 0xA6,
            0xD5, 0x80, 0x8D, 0x14, 0xAF
        ):
            self.write_cmd(cmd)
        self.fill(0)
        self.show()

    def show(self):
        for page in range(self.pages):
            self.write_cmd(0xB0 + page)
            self.write_cmd(0x00)
            self.write_cmd(0x10)
            self.write_data(
                self.buffer[self.width * page:self.width * (page + 1)]
            )

class SSD1306_I2C(SSD1306):
    def __init__(self, width, height, i2c, addr=0x3C):
        self.i2c = i2c
        self.addr = addr
        self.temp = bytearray(2)
        super().__init__(width, height)
        self.init_display()

    def write_cmd(self, cmd):
        self.temp[0] = 0x80
        self.temp[1] = cmd
        self.i2c.writeto(self.addr, self.temp)

    def write_data(self, buf):
        self.i2c.writeto(self.addr, b'\x40' + buf)



# ==================================================
# CLASE PRINCIPAL DE APLICACIÓN
# ==================================================

class VitalsDisplay:
    def __init__(self):
        self.i2c = I2C(0, scl=Pin(2), sda=Pin(4))
        self.oled = SSD1306_I2C(128, 64, self.i2c)
        self.oled.fill(0)
        self.oled.text("Monitor Vital", 0, 0)
        self.oled.text("--------------", 0, 10)
        self.oled.show()

    def update(self, bpm, spo2, temp, alarm):
        self.oled.fill(0)

        #self.oled.text("Monitor Vital", 0, 0)
        self.oled.text(nombre_paciente[:16], 0, 0)

        bpm_str  = "--" if bpm  is None else "{:.1f}".format(bpm)
        spo2_str = "--" if spo2 is None else "{:.1f}".format(spo2)
        temp_str = "--" if temp is None else "{:.1f}".format(temp)

        self.oled.text("HR:   {} bpm".format(bpm_str), 0, 16)
        self.oled.text("SpO2: {} %".format(spo2_str), 0, 28)
        self.oled.text("Temp: {} C".format(temp_str), 0, 40)

        if alarm:
            self.oled.text("!!! ALARMA !!!", 0, 54)
        else:
            self.oled.text("Estado: OK", 0, 54)

        self.oled.show()
# -----------------------------
# Umbrales temperatura Adulto mayor
# -----------------------------
TEMP_LOW_C      = 27.0
TEMP_NORMAL_MAX = 37.9
TEMP_HIGH_C     = 38.0

# -----------------------------
# Estado / buffers HR-SpO2
# -----------------------------
dc_red = None; dc_ir = None
SR = 100; WINDOW_SEC = 5; N = SR * WINDOW_SEC
red_ac_buf = []; ir_ac_buf  = []

# Variables para detección de picos mejorada
ir_buffer = []
bpm_list = []
last_peak_time = 0
last_ir_val = 0
subiendo = False

latest_bpm       = None
latest_spo2      = None
latest_hr_cat    = "sin dato"
latest_spo2_cat  = "sin dato"
latest_temp_c    = None
latest_temp_cat  = "sin dato"

_last_print_ms   = time.ticks_ms()
alarm_active     = False

# -----------------------------
# Alarma
# -----------------------------
def trigger_alarm():
    global alarm_active
    if not alarm_active:
        alarm_active = True
        buzzer.freq(1000)
        buzzer.duty(512)

def clear_alarm():
    global alarm_active
    if alarm_active:
        buzzer.duty(0)
        alarm_active = False

# -----------------------------
# Procesamiento HR/SpO2
# -----------------------------
def update_dc_ac(red, ir, alpha=0.95):
    global dc_red, dc_ir
    if dc_red is None:
        dc_red, dc_ir = red, ir
    else:
        dc_red = alpha*dc_red + (1-alpha)*red
        dc_ir  = alpha*dc_ir  + (1-alpha)*ir
    return red - dc_red, ir - dc_ir, dc_red, dc_ir

def detect_peak(ir_val):
    """
    Detecta picos en la señal IR usando el método de subida-bajada con buffer promedio.
    Más preciso que el método anterior de threshold simple.
    """
    global ir_buffer, last_peak_time, last_ir_val, subiendo, bpm_list
    
    THRESHOLD =300  # Umbral sobre el promedio para considerar un pico
    MIN_IBI = 700    # Inter-beat interval mínimo 600(100 BPM máx)
    MAX_IBI = 1200   # Inter-beat interval máximo (50 BPM mín) era 1200
    
    # Mantener buffer de últimas 8 muestras para promedio
    ir_buffer.append(ir_val)
    if len(ir_buffer) > 8:
        del ir_buffer[0]
    
    # Calcular promedio del buffer
    if len(ir_buffer) < 3:
        return None  # No hay suficientes datos aún
    
    promedio = sum(ir_buffer) / len(ir_buffer)
    
    # Detectar si está subiendo
    if ir_val > last_ir_val:
        subiendo = True
    
    # Detectar pico: estaba subiendo, ahora baja, y el valor anterior supera el umbral
    elif subiendo and ir_val < last_ir_val and last_ir_val > promedio + THRESHOLD:
        ahora = time.ticks_ms()
        
        # Si no es el primer pico
        if last_peak_time != 0:
            ibi = time.ticks_diff(ahora, last_peak_time)
            
            # Validar que el IBI esté en rango razonable
            if MIN_IBI < ibi < MAX_IBI:
                bpm = 60000.0 / ibi
                bpm_list.append(bpm)
                
                # Mantener solo últimos 5 valores
                if len(bpm_list) > 5:
                    del bpm_list[0]
        
        last_peak_time = ahora
        subiendo = False
    
    last_ir_val = ir_val
    return None

def estimate_bpm():
    """
    Estima BPM basado en el promedio de las últimas mediciones válidas.
    Más estable y preciso que calcular desde peak_times.
    """
    if len(bpm_list) < 2:
        return None
    
    # Retornar promedio de las últimas mediciones
    bpm_promedio = sum(bpm_list) / len(bpm_list)
    return bpm_promedio

def _rms(values):
    if not values: return 0.0
    s = 0.0
    for v in values: s += v*v
    return math.sqrt(s/len(values))

def estimate_spo2(red_ac_buf, ir_ac_buf, dc_red, dc_ir):
    if not dc_red or not dc_ir: return None
    ac_red_rms = _rms(red_ac_buf); ac_ir_rms  = _rms(ir_ac_buf)
    if ac_red_rms <= 0 or ac_ir_rms <= 0: return None
    R = (ac_red_rms/dc_red) / (ac_ir_rms/dc_ir)
    spo2 = -45.060*(R**2) + 30.354*R + 94.845
    if spo2 < 70 or spo2 > 100.5: return None
    return spo2

# -----------------------------
# Clasificación (y alarma)
# -----------------------------
def classify_spo2(spo2):
    if spo2 is None:      return "sin dato"
    if spo2 <= 70:        trigger_alarm(); return "SpO2 baja"
    if spo2 >= 71:        clear_alarm();   return "normal"
    clear_alarm();        return "SpO2 alta"

#-----------------------------------------------------------------
def pulso_limites_normal(edad, movimiento):
    global pulso_bajo, pulso_alto
    if movimiento == "reposo":
        pulso_bajo = 60
        pulso_alto = 100
    elif movimiento == "ejercitando":
        pulso_bajo = 75
        pulso_alto = 200

def pulso_limites_diabetes(edad, movimiento):
    global pulso_bajo, pulso_alto
    if movimiento == "reposo":
        pulso_bajo = 75
        pulso_alto = 140
    elif movimiento == "ejercitando":
        pulso_bajo = 60
        pulso_alto = 250

def pulso_limites_hipertencion(edad, movimiento):
    global pulso_bajo, pulso_alto
    if movimiento == "reposo":
        pulso_bajo = 40
        pulso_alto = 130
    elif movimiento == "ejercitando":
        pulso_bajo = 60
        pulso_alto = 250

def pulso_limites_diabetes_hipertencion(edad, movimiento):
    global pulso_bajo, pulso_alto
    if movimiento == "reposo":
        pulso_bajo = 40
        pulso_alto = 130
    elif movimiento == "ejercitando":
        pulso_bajo = 60        
        pulso_alto = 200
        
#--------------------------------------------------------------
def configurar_perfil():

    global perfil_usuario
    global edad
    global movimiento

    print("Configurando perfil:", perfil_usuario)

    if perfil_usuario == "sano":
        pulso_limites_normal(edad, movimiento)

    elif perfil_usuario == "diabetes":
        pulso_limites_diabetes(edad, movimiento)

    elif perfil_usuario == "hipertenso":
        pulso_limites_hipertencion(edad, movimiento)

    elif perfil_usuario == "hipertension y diabetes":
        pulso_limites_diabetes_hipertencion(edad, movimiento)

    else:
        pulso_limites_normal(edad, movimiento)

    print("Límites BPM:", pulso_bajo, pulso_alto)
    
    
#------------------------------------------------------------------
def classify_hr(bpm):
    if bpm is None:       return "sin dato"
    if bpm < pulso_bajo:          trigger_alarm(); return "bpm baja"
    elif bpm >= pulso_alto:      clear_alarm();   return "bpm Alta"
    else:                 clear_alarm(); return "normal"

def classify_temp(temp_c):
    if temp_c is None:    return "sin dato"
    if temp_c < TEMP_LOW_C:
        trigger_alarm();  return "baja"
    elif temp_c >= TEMP_HIGH_C:
        trigger_alarm();  return "alta"
    elif temp_c <= TEMP_NORMAL_MAX:
        clear_alarm();    return "normal"
    else:
        clear_alarm();    return "normal"  # subfebril

# -----------------------------
# Actualización de temperatura
# -----------------------------
def update_temperature():
    global latest_temp_c, latest_temp_cat
    t = read_temp_obj()           # MLX90614 objeto (piel)
    latest_temp_c   = t
    latest_temp_cat = classify_temp(t)

# -----------------------------
# Loop de actualización (HR/SpO2/Temp)
# -----------------------------
def update_vitals():
    global latest_bpm, latest_spo2, latest_hr_cat, latest_spo2_cat, _last_print_ms
    try:
        # HR/SpO2 (llenar buffers)
        for _ in range(5):
            red, ir = read_sample_pair()
            red_ac, ir_ac, cur_dc_red, cur_dc_ir = update_dc_ac(red, ir, alpha=0.95)
            red_ac_buf.append(red_ac); ir_ac_buf.append(ir_ac)
            if len(red_ac_buf) > N: del red_ac_buf[0]
            if len(ir_ac_buf)  > N: del ir_ac_buf[0]
            
            # Usar la nueva función de detección de picos (pasando valor IR crudo)
            detect_peak(ir)

        # Temperatura
        update_temperature()

        # Reporte cada ~1 s
        now = time.ticks_ms()
        if time.ticks_diff(now, _last_print_ms) >= 1000:
            bpm  = estimate_bpm()
            spo2 = estimate_spo2(red_ac_buf, ir_ac_buf, cur_dc_red, cur_dc_ir)
            latest_bpm      = bpm
            latest_spo2     = spo2
            latest_hr_cat   = classify_hr(bpm)
            latest_spo2_cat = classify_spo2(spo2)

            bstr = "--" if bpm  is None else f"{bpm:5.1f}"
            sstr = "--" if spo2 is None else f"{spo2:5.1f}"
            tstr = "--" if latest_temp_c is None else f"{latest_temp_c:4.2f}"

            # Mensaje de alarma en terminal si está activa
            if alarm_active:
                print("ALARMA ACTIVA REVISE AL PACIENTE")
            
            
            print(f"HR: {bstr} bpm ({latest_hr_cat}) | SpO2: {sstr}% ({latest_spo2_cat}) | Temp: {tstr} °C ({latest_temp_cat})")
            

            # AQUÍ se actualiza el OLED cada 1s
            if oled_display is not None:
                oled_display.update(
                    latest_bpm,
                    latest_spo2,
                    latest_temp_c,
                    alarm_active
                )

            _last_print_ms = now


    except OSError as e:
        print("Error I2C:", e, "→ Reinicializando MAX30102")
        max30102_init()
        time.sleep_ms(50)

# -----------------------------
# JSON para /vitals (incluye temp)
# -----------------------------
def vitals_json():
    b = "null" if latest_bpm  is None else f"{latest_bpm:.1f}"
    s = "null" if latest_spo2 is None else f"{latest_spo2:.1f}"
    t = "null" if latest_temp_c is None else f"{latest_temp_c:.2f}"
    
    return ('{"hr":' + b +
            ',"hr_cat":"' + latest_hr_cat +
            '","spo2":' + s +
            ',"spo2_cat":"' + latest_spo2_cat +
            '","temp":' + t +
            ',"temp_cat":"' + latest_temp_cat + '"}')

# -----------------------------
# Conexión Wi‑Fi
# -----------------------------
def connect_wifi():
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(SSID, PASSWORD)
    print("Conectando a WiFi...")
    while not wlan.isconnected():
        time.sleep(0.5)
    ip = wlan.ifconfig()[0]
    print("Conectado a WiFi:", ip)
    return ip

# -----------------------------
# Servidor HTTP (CORS)
# -----------------------------
def start_server(ip):
    global oled_display
    max30102_init()
    oled_display = VitalsDisplay()
    print("Servidor Activo - Esperando datos...")

    addr = socket.getaddrinfo(ip, 80)[0][-1]
    s = socket.socket()
    s.bind(addr); s.listen(1); s.settimeout(1)
    print("Servidor escuchando en http://{}:80".format(ip))
    
    #-----------------------------------
      
    #-----------------------------------------------
    oled_display = VitalsDisplay()
    
    import gc

    while True:
        update_vitals()
        
        gc.collect()
        
        time.sleep_ms(3)

        try:
            cl, addr = s.accept()
            
        except OSError:
            continue

        try:
            request = cl.recv(4024).decode()
            
            ####
            # ===================================
            # RECIBIR CONFIGURACIÓN DESDE PYTHON
            # ===================================

            if "POST /config" in request:

                global nombre_paciente
                global perfil_usuario
                

                try:

                    body = request.split("\r\n\r\n")[1]

                    import ujson

                    datos = ujson.loads(body)
                    print("datos cargo\n")

                    nombre_paciente = datos.get("name", "SinNombre")
                    perfil_usuario = datos.get("tipoHome", "normal")

                    configurar_perfil()

                    print("Paciente:", nombre_paciente)
                    print("Perfil:", perfil_usuario)

                    respuesta = "CONFIG OK"

                    cl.sendall(
                        "HTTP/1.1 200 OK\r\n"
                        "Content-Type: text/plain\r\n"
                        "Access-Control-Allow-Origin: *\r\n"
                        "\r\n" + respuesta
                    )
                    
                    
                    continue

                except Exception as e:

                    print("Error config:", e)

                    cl.sendall(
                        "HTTP/1.1 500 ERROR\r\n"
                        "Content-Type: text/plain\r\n"
                        "\r\nERROR"
                    )
            ##

            if "GET /buzzer" in request:
                if "state=on1" in request:   play_melody(alarm_melody)
                elif "state=on2" in request: play_melody(christmas_melody)
                elif "state=on3" in request: play_melody(police_melody)
                elif "state=stop" in request: buzzer.duty(0); clear_alarm()
                cl.send("HTTP/1.1 200 OK\r\n"
                        "Content-Type: text/plain\r\n"
                        "Access-Control-Allow-Origin: *\r\n"
                        "Cache-Control: no-store\r\n"
                        "\r\nOK")

            
            elif "GET /vitals" in request:
                
                payload = vitals_json()
                cl.send("HTTP/1.1 200 OK\r\n"
                        "Content-Type: application/json\r\n"
                        "Access-Control-Allow-Origin: *\r\n"
                        "Cache-Control: no-store\r\n"
                        "Connection: close\r\n"
                        "Content-Length: {}\r\n"
                        "\r\n{}".format(len(payload), payload))


            else:
                cl.sendall("HTTP/1.1 404 Not Found\r\n"
                        "Access-Control-Allow-Origin: *\r\n"
                        "\r\n")
        finally:
            cl.close()
                

# -----------------------------
# Ejecuta
# -----------------------------
try:
    ip = connect_wifi()
    start_server(ip)
    app = DisplayApp()
    app.run()
except Exception as e:
    print("Error crítico:", e)
    print("Reinicie el sistema")
