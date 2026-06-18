# Hardware

This project is a Smart Water Bottle system built using ESP32 that tracks water consumption, detects drinking events, and sends data to Firebase in real time.

# Instructions for Installation

## 📌 Requirements
- Arduino IDE (latest version)
- ESP32 Development Board
- USB Cable
- Internet Connection (WiFi)

---

## 📚 Required Libraries

Install the following libraries from Arduino Library Manager:

- LiquidCrystal_I2C  
- OneWire  
- DallasTemperature  
- Adafruit_VL53L0X  
- MPU6050  
- ArduinoJson  

Built-in ESP32 libraries (no installation needed):
- WiFi  
- HTTPClient  
- WebServer  
- Preferences  
- Wire  

---

## ⚙️ Setup Steps

### 1. Install ESP32 Board in Arduino IDE
Go to:

File → Preferences

Add this URL:

https://dl.espressif.com/dl/package_esp32_index.json

Then go to:

Tools → Board → Boards Manager → Install ESP32

---

### 2. Select Board
Tools → Board → ESP32 Dev Module

---

### 3. Configure WiFi
Edit in code:

```cpp
const char* ssid = "YOUR_WIFI_NAME";
const char* password = "YOUR_WIFI_PASSWORD";
4. Firebase Setup (Optional)

Enable Firebase:

const bool FIREBASE_ENABLED = true;

Set your Firebase URL:

String firebaseBase = "https://your-project.firebaseio.com/";
5. Upload Code

Click Upload (→) in Arduino IDE

6. Open Serial Monitor

Set baud rate to: (115200)

--------

**Notes
Make sure all sensors are connected correctly (MPU6050, VL53L0X, Ultrasonic)
First boot may take time for WiFi + NTP sync
If Firebase is disabled, data will only appear in Serial Monitor