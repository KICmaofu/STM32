"""ESP32-S3 MicroPython 入门程序: GPIO5 控制 LED 闪烁(每 0.5 秒切换一次)。

上传到开发板后会被保存为 /main.py, 开机自动运行。
临时运行(不保存): mpremote run main.py
"""

from machine import Pin
import time

LED_PIN = 1

led = Pin(LED_PIN, Pin.OUT)

print(f"ESP32-S3 MicroPython 已启动, LED 引脚: GPIO{LED_PIN}")

while True:
    led.value(not led.value())
    time.sleep(0.5)
