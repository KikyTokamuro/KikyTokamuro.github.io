#linux #device

![[Pasted image 20241217125240.png]]

Nokia 5110 LCD — это монохромный дисплей 84x48 пикселей, который использовался в старых телефонах Nokia. Основное преимущество этого дисплея — легкость в управлении.

На плате модуля дисплея расположены два параллельных ряда по 8 пинов для подключения и передачи данных:

1. RST — Перезагрузка.
2. CE — Выбор чипа.
3. DC — Выбор режима.
4. DIN — Вход данных.
5. CLK — Вход тактового сигнала.
6. VCC — Питание.
7. LIGHT — Питание подсветки дисплея.
8. GND — Земля.

![[Pasted image 20241217125302.png]]

Подключение данного дисплея к Raspberry Pi осуществляется очень просто, вот по этой схеме (чтобы при подключении дисплея работала его подсветка, нужно пин LIGHT подключить на землю):

![[Pasted image 20241217125331.png]]

Дальше для взаимодействия с дисплеем на Raspberry Pi нужно установить нужные библиотеки (предполагается что такие вещи как git, python-pip, python-dev, build-essential у вас уже установлены, если нет, то их тоже нужно установить):
```shell
sudo apt install python-imaging
pip install RPi.GPIO
```

Так как взаимодействие с модулем экрана осуществляется по SPI, его так же нужно включить на Raspberry Pi. Для этого открываем файл “/boot/config.txt” и раскомментируем в нем строку:
```Shell
dtparam=spi=on
```

После этого сохраняем файл и перезагружаемся командой:
```shell
sudo reboot
```

Чтобы проверить что SPI включено, можно воспользоваться командой:
```shell
lsmod | grep "spi_bcm*"
```

Дальше скачиваем и устанавливаем библиотеку для взаимодействия с дисплеем Nokia 5110:
```shell
git clone https://github.com/adafruit/Adafruit_Nokia_LCD
cd Adafruit_Nokia_LCD
sudo python setup.py install
```

Чтобы проверить то что дисплей правильно подключен и все работает, можно запустить один из примеров, из папки “Adafruit_Nokia_LCD/examples/”.

А теперь попробуем написать простенькие часы для этого дисплея:
```python
#!/usr/bin/python

import time
from datetime import datetime

import Adafruit_Nokia_LCD as LCD
import Adafruit_GPIO.SPI as SPI

from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont

# Raspberry Pi hardware SPI config:
DC = 23
RST = 24
SPI_PORT = 0
SPI_DEVICE = 0

# Hardware SPI usage:
disp = LCD.PCD8544(DC, RST, spi=SPI.SpiDev(SPI_PORT, SPI_DEVICE, max_speed_hz=4000000))

# Software SPI usage (defaults to bit-bang SPI interface):
#disp = LCD.PCD8544(DC, RST, SCLK, DIN, CS)

# Initialize library.
disp.begin(contrast=40)

# Clear display.
disp.clear()
disp.display()

# Create blank image for drawing.
# Make sure to create image with mode '1' for 1-bit color.
image = Image.new('1', (LCD.LCDWIDTH, LCD.LCDHEIGHT))

# Get drawing object to draw on image.
draw = ImageDraw.Draw(image)

print('Press Ctrl-C to quit.')

while True:
    # Get current time
    strt = datetime.now().strftime('%H:%M:%S')

    # Draw a white filled box to clear the image.
    draw.rectangle((0,0,LCD.LCDWIDTH,LCD.LCDHEIGHT), outline=255, fill=255)

    # Alternatively load a TTF font.
    # Some nice fonts to try: http://www.dafont.com/bitmap.php
    font = ImageFont.truetype('game_over.ttf', 58)

    # Write some text.
    draw.text((0,0), strt, font=font)

    # Display image.
    disp.image(image)
    disp.display()
    
    time.sleep(1.0)
```

Запускается этот код командой:
```shell
sudo python clock.py
```

Демонстрация работы получившихся часов:
<iframe width="100%" height="500" src="https://www.youtube.com/embed/Pj_oeo0m8-s" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
