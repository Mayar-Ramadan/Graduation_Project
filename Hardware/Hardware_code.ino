// ---------- Libraries ----------
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <Adafruit_VL53L0X.h>
#include <MPU6050.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <WebServer.h>
#include <Preferences.h>
#include <ArduinoJson.h>
#include <time.h>

// =============================================
// WiFi
// =============================================
const char* ssid     = "we99";
const char* password = "01148594440Ashraf 4920041997";

// =============================================
// Firebase
// =============================================
String userId       = "m8HNuLCuGadP58dFQO5GSj4xA3N2";
String firebaseBase = "https://graduation-project-d3f62-default-rtdb.firebaseio.com/";

// =============================================
// Pins
// =============================================
#define ONE_WIRE_BUS 4
const int trigPin   = 19;
const int echoPin   = 18;
const int buzzerPin = 23;

const bool FIREBASE_ENABLED = false;

const float DRINK_PITCH_MIN  =  8.0;
const float DRINK_PITCH_MAX  = 27.0;
const float DRINK_ROLL_MAX   = 20.0;
const float SPILL_ROLL_RIGHT =  50.0;
const float SPILL_ROLL_LEFT  = -50.0;

// =============================================
// Volume settings
// =============================================
const float MAX_HEIGHT     = 20.0;   // cm
const float TOTAL_CAPACITY = 800.0;  // ml

// =============================================
// Cooldowns
// =============================================
const unsigned long DRINK_COOLDOWN = 15000;  // ms
const unsigned long SPILL_COOLDOWN =  3000;  // ms

// =============================================
// Objects
// =============================================
LiquidCrystal_I2C lcd(0x27, 16, 2);
OneWire           oneWire(ONE_WIRE_BUS);
DallasTemperature sensors(&oneWire);
Adafruit_VL53L0X  vl53;
MPU6050           mpu;
WebServer         server(80);
Preferences       prefs;

// =============================================
// State variables
// =============================================
bool  isWiFiConnected = false;
int   readingCounter  = 1;

// --- Ultrasonic ---
float filteredDistance = 0;

// --- MPU ---
int16_t ax, ay, az, gx, gy, gz;
float   pitch = 0, roll = 0;

// --- Volume ---
float currentVolume  = 0;
float previousVolume = 0;
float consumed       = 0;
bool  firstRead      = true;

// --- Timers ---
unsigned long lastDrinkTime = 0;
unsigned long lastSpillTime = 0;

// --- Status tracking ---
String previousStatus = "Remaining Water";

// =============================================
// TIME HELPERS
// =============================================
String getTimeString() {
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) return "";
  char buffer[10];
  strftime(buffer, sizeof(buffer), "%I:%M %p", &timeinfo);
  return String(buffer);
}

String getCreatedAt() {
  time_t now;
  time(&now);
  return String((long)now) + "000";
}

// =============================================
// WIFI
// =============================================
void connectToWiFi() {
  Serial.println("Connecting to WiFi: " + String(ssid));
  lcd.setCursor(0, 0);
  lcd.print("Connecting WiFi ");

  WiFi.begin(ssid, password);

  unsigned long startTime = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - startTime < 15000) {
    delay(500);
    Serial.print(".");
  }

  if (WiFi.status() == WL_CONNECTED) {
    isWiFiConnected = true;
    Serial.println("\nWiFi Connected! IP: " + WiFi.localIP().toString());
    lcd.clear(); lcd.setCursor(0, 0); lcd.print("WiFi Connected!");
  } else {
    isWiFiConnected = false;
    Serial.println("\nWiFi Failed!");
    lcd.clear(); lcd.setCursor(0, 0); lcd.print("WiFi Failed!");
  }
  delay(1000);
  lcd.clear();
}

// =============================================
// BOTTLE STATUS
// =============================================
String getBottleStatus(float pitch, float roll) {
  if (roll >= SPILL_ROLL_RIGHT) return "SPILL RIGHT";
  if (roll <= SPILL_ROLL_LEFT)  return "SPILL LEFT";

  if (pitch >= DRINK_PITCH_MIN && pitch <= DRINK_PITCH_MAX && abs(roll) < DRINK_ROLL_MAX)
    return "Drinking";

  return "Remaining Water";
}

bool isSpill(const String& status) {
  return status == "SPILL RIGHT" || status == "SPILL LEFT";
}

// =============================================
// FIREBASE SEND
// =============================================
void sendToFirebase(const String& status, float amount) {
  if (!FIREBASE_ENABLED) {
    Serial.println("[Firebase] DISABLED - " + status + " / " + String((int)amount) + " ml");
    return;
  }

  if (!isWiFiConnected) {
    Serial.println("[Firebase] No WiFi - skipped");
    return;
  }

  String readingKey = "reading" + String(readingCounter);
  String url = firebaseBase
             + "debug_users/" + userId
             + "/water_readings/"
             + readingKey + ".json";

  HTTPClient http;
  http.begin(url);
  http.addHeader("Content-Type", "application/json");

  String json = "{";
  json += "\"amount\":"    + String((int)amount) + ",";
  json += "\"createdAt\":" + getCreatedAt()       + ",";
  json += "\"status\":\""  + status              + "\",";
  json += "\"time\":\""    + getTimeString()      + "\"";
  json += "}";

  int httpCode = http.PUT(json);
  http.end();

  Serial.println("[Firebase] Key:" + readingKey + "  Status:" + status
               + "  Amount:" + String((int)amount) + "  HTTP:" + String(httpCode));

  if (httpCode == 200 || httpCode == 201) {
    readingCounter++;
    prefs.putInt("readingCnt", readingCounter);
  }
}

// =============================================
// SETUP
// =============================================
void setup() {
  Serial.begin(115200);
  Wire.begin();

  lcd.init();
  lcd.backlight();

  pinMode(trigPin,   OUTPUT);
  pinMode(echoPin,   INPUT);
  pinMode(buzzerPin, OUTPUT);

  sensors.begin();

  if (!vl53.begin()) {
    lcd.setCursor(0, 0); lcd.print("VL53 Error");
    while (1);
  }

  mpu.initialize();
  if (!mpu.testConnection()) {
    lcd.setCursor(0, 0); lcd.print("MPU Error");
    while (1);
  }

  prefs.begin("bottle", false);
  readingCounter = prefs.getInt("readingCnt", 1);

  connectToWiFi();

  if (isWiFiConnected) {
    configTime(2 * 3600, 0, "pool.ntp.org");
    struct tm timeinfo;
    int tries = 0;
    Serial.print("Waiting for NTP");
    while (!getLocalTime(&timeinfo) && tries < 10) {
      delay(500); Serial.print("."); tries++;
    }
    Serial.println(tries < 10 ? "\nTime synced!" : "\nTime sync failed");
  }

  lcd.setCursor(0, 0); lcd.print("Project Ready");
  delay(1000);
  lcd.clear();
}

// =============================================
// LOOP
// =============================================
void loop() {
  server.handleClient();

  // ---------- Ultrasonic ----------
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long  duration    = pulseIn(echoPin, HIGH, 30000);
  float rawDistance = duration * 0.034f / 2.0f;

  if (filteredDistance == 0)
    filteredDistance = rawDistance;
  else
    filteredDistance = 0.7f * filteredDistance + 0.3f * rawDistance;

  // ---------- Volume ----------
  currentVolume = ((MAX_HEIGHT - filteredDistance) / MAX_HEIGHT) * TOTAL_CAPACITY;
  currentVolume = constrain(currentVolume, 0, TOTAL_CAPACITY);

  // ---------- MPU ----------
  mpu.getMotion6(&ax, &ay, &az, &gx, &gy, &gz);

  float ax_g = ax / 16384.0f;
  float ay_g = ay / 16384.0f;
  float az_g = az / 16384.0f;

  pitch = atan2(ax_g, sqrt(ay_g * ay_g + az_g * az_g)) * 180.0f / PI;
  roll  = atan2(ay_g, sqrt(ax_g * ax_g + az_g * az_g)) * 180.0f / PI;

  String currentStatus = getBottleStatus(pitch, roll);

  // ---------- First read ----------
  if (firstRead) {
    previousVolume = currentVolume;
    previousStatus = currentStatus;
    firstRead = false;
    return;
  }

  unsigned long now = millis();

  // =============================================
  // 1 - DRANK WATER
  // =============================================
  if (currentStatus == "Drinking" && previousStatus != "Drinking") {
    if (now - lastDrinkTime > DRINK_COOLDOWN) {

      float diff = previousVolume - currentVolume;

      if (diff <= 0) {
        Serial.println(">>> Ignored noise (negative/zero diff)");
        return;
      }

      if (diff < 5 || diff > 300) {
        Serial.println(">>> Ignored invalid drink value: " + String(diff));
        return;
      }

      consumed += diff;
      lastDrinkTime = now;

    Serial.println(">>> Drank : " + String((int)diff) + " ml");
    Serial.println(">>> Total : " + String((int)consumed) + " ml");

    sendToFirebase("Drank water", diff);
  }
}

  // =============================================
  // 2 - SPILLING
  // =============================================
  if (isSpill(currentStatus) && now - lastSpillTime > SPILL_COOLDOWN) {
    lastSpillTime = now;
    Serial.println(">>> Spilling! " + currentStatus);
    sendToFirebase("Spilling", 0);
  }

  // =============================================
  // 3 - BACK TO NORMAL after Spill
  // =============================================
  if (currentStatus == "Remaining Water" && isSpill(previousStatus)) {
    Serial.println(">>> Back to Normal");
    sendToFirebase("Remaining Water", currentVolume);
  }

  previousVolume = currentVolume;
  previousStatus = currentStatus;

  // ---------- LCD ----------
  lcd.setCursor(0, 0); lcd.print("P:" + String(pitch, 1) + "   ");
  lcd.setCursor(0, 1); lcd.print("R:" + String(roll,  1) + "   ");

  // ---------- Serial ----------
  Serial.println("------");
  Serial.print("Pitch  : "); Serial.println(pitch);
  Serial.print("Roll   : "); Serial.println(roll);
  Serial.print("Status : "); Serial.println(currentStatus);
  Serial.print("Volume : "); Serial.println(currentVolume);

  delay(500);
}