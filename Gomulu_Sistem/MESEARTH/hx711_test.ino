#include <Arduino.h>
#include "HX711.h"
#include "soc/rtc.h"
#include <Servo.h>
#include <WiFi.h>
#include "time.h"
#include <ESP32Time.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

#define buzzer_PIN 19 // Buzzer pinini tanımlıyoruz
boolean komutIsareti=false;
float okuma;

unsigned long previousMillis = 0; 
const long interval = 5000; // buzzer'ın çalacağı süre
long silentInterval; // buzzer'ın susacağı süre
bool isBuzzerOn = false;

ESP32Time rtc(3600);  // GMT+1 için saat dilimi ofsetini saniye olarak belirtir

const char *ssid = "RIGJAZZ";
const char *password = "Kashmiri786";
String besleyiciAdi="testfeeder";

String serverAdi = "http://remanent-hours.000webhostapp.com/getapi.php";
unsigned long sonZaman = 0;  
unsigned long zamanGecikme = 1000*5;  // 5 saniyelik bir zaman gecikmesi tanımlıyoruz

String sensorOkumalar;
float sensorOkumalarArr[3];
String yuk = "{}";  // HTTP yanıtını saklayan bir dize
unsigned long premilliskomut;

unsigned premillis=0;
int guncelAgirlik=0;

const char* ntpServer = "europe.pool.ntp.org";
const long  gmtOffset_sec = 3600;
const int   daylightOffset_sec = 3600;
unsigned long epochZaman=0; 

const int LOADCELL_DOUT_PIN = 16;
const int LOADCELL_SCK_PIN = 4;

HX711 scale;

unsigned long getZaman() {
  time_t simdi;
  struct tm timeinfo;
  if (!getLocalTime(&timeinfo)) {
    return(0);
  }
  time(&simdi);
  return simdi;
}

// HTTP GET talebi gönderen ve yanıtı döndüren bir fonksiyon
String httpGETRequest(const char *serverAdi)
{
  Serial.println("-----------API'YE TALEP GÖNDERILIYOR--------------");
  WiFiClient istemci;
  HTTPClient http;
  http.begin(istemci, serverAdi);
  okuma=round(scale.get_units());
  http.addHeader("Content-Type", "application/json");
  String servereGonder="{\"id\":\""+besleyiciAdi+"\",\"reading\":\""+(String)okuma+"\"}";
  int httpResponseCode = http.POST(servereGonder);
  Serial.println(servereGonder);

  if (httpResponseCode > 0) {
    Serial.print("HTTP Yanıt kodu: ");
    Serial.println(httpResponseCode);
    yuk = http.getString();
    Serial.println((String)yuk);
  }
  else {
    Serial.print("Hata kodu: ");
    Serial.println(httpResponseCode);
  }

  http.end();

  return yuk;
}

void getntp() {

  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);

  epochZaman = getZaman();
  Serial.print("Epoch Zaman: ");
  Serial.println(epochZaman);
  rtc.setTime(epochZaman);

}

void scaleAyarlama(){
  
  Serial.println("Ölçeğin başlatılması");

  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);

  scale.set_scale(0.42);
  scale.tare();               // ölçeği 0'a sıfırlar

  Serial.println("################# AYARLAMA TAMAMLANDI ###################");
}

void setup() {
  Serial.begin(9600);
 pinMode(buzzer_PIN,OUTPUT);

  scaleAyarlama();
  pinMode(buzzer_PIN,OUTPUT);
  digitalWrite(buzzer_PIN,LOW);
  Serial.println("WiFi başlatılıyor...");
  WiFi.mode(WIFI_STA);  Serial.println("WiFi'ye bağlanılıyor");
  WiFi.begin("Wokwi-GUEST", "");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi'ye bağlandı");

  while (epochZaman < 1){
    getntp();
  }
  Serial.println(rtc.getTime());
  premilliskomut=0;

  randomSeed(analogRead(0)); // random() fonksiyonunun düzgün çalışması için
  silentInterval = random(5000, 10000); // buzzer'ın susacağı süreyi belirle
}

void loop() {
  unsigned long currentMillis = millis();
  if (!isBuzzerOn && currentMillis - previousMillis >= silentInterval) {
    // Buzzer'ı çal
    digitalWrite(buzzer_PIN,HIGH);
    isBuzzerOn = true;
    previousMillis = currentMillis;
  } else if (isBuzzerOn && currentMillis - previousMillis >= interval) {
    // Buzzer'ı durdur ve susma süresini rastgele belirle
    digitalWrite(buzzer_PIN,LOW);
    isBuzzerOn = false;
    silentInterval = random(5000, 10000);
    previousMillis = currentMillis;
  }
   if(millis()-premillis > 1000){
    Serial.println("ESP ZAMAN : "+(String)rtc.getTime());
    okuma=round(scale.get_units());
    Serial.println((String)komutIsareti);
    Serial.println("GERGİNLİK :"+(String)okuma);
    premillis=millis();
  }

  if ((millis() - sonZaman) > zamanGecikme) {
    if (WiFi.status() == WL_CONNECTED) {
      sensorOkumalar = httpGETRequest(serverAdi.c_str());
      DynamicJsonDocument doc(2500);
      DeserializationError error = deserializeJson(doc, yuk);

      if (error) {
        Serial.print(F("deserializeJson() basarisiz oldu: "));
        Serial.println(error.f_str());
        return;
      }

      for(int i=0;i<doc.size();i++){
        Serial.println("##################"+(String)i+"###############");
        String programAdi  = doc[i]["programadi"];
        String baslamaZamani  = doc[i]["baslamazamani"];
        int agirlik = doc[i]["agirlik"];
        String komutZamani  = doc[i]["komutzamani"];
        int zamanlayici= doc[i]["zamanlayici"];
        String komutDurumu=doc[i]["komutdurumu"];

        Serial.println("PROGRAM ADI : "+(String)programAdi);
        Serial.println("BASLAMA ZAMANI : "+(String)baslamaZamani);
        Serial.println("AGIRLIK : "+(String)agirlik);
        Serial.println("komut ZAMANLAYICISI : "+(String)zamanlayici);
        Serial.println("komut DURUMU : "+(String)komutDurumu);

        // Isıtma zamanını ve durumunu analiz ediyoruz ve buna göre buzzer'ı kontrol ediyoruz
        String h_saat = komutZamani.substring(0,2);
        if(h_saat[0]== 0){
          h_saat = komutZamani.substring(1,2); 
        }
        String h_dakika = komutZamani.substring(3,5);
        if(h_dakika[0]== 0){
          h_dakika = komutZamani.substring(4,5); 
        }
             
        int komut_saat=h_saat.toInt();
        int komut_dakika=h_dakika.toInt();
               
        if((komut_saat == rtc.getHour(true)) && ( rtc.getMinute() >= komut_dakika ) && (rtc.getMinute() <= (komut_dakika + zamanlayici)) && (komutDurumu == "ON")){
          digitalWrite(buzzer_PIN,HIGH);
        }
        else{
          digitalWrite(buzzer_PIN,LOW);
        }

        //Eğer beslenme saati gelmiş ve ağırlık istenen ağırlığın altındaysa, yiyecek eklemek için buzzer çalıyoruz.
        String f_saat = baslamaZamani.substring(0,2);
        if(f_saat[0]== 0){
          f_saat = baslamaZamani.substring(1,2); 
        }
        String f_dakika = baslamaZamani.substring(3,5);
        if(f_dakika[0]== 0){
          f_dakika = baslamaZamani.substring(4,5); 
        }
             
        int besleme_saat=f_saat.toInt();
        int besleme_dakika=f_dakika.toInt();

        if((besleme_saat == rtc.getHour(true)) && ( rtc.getMinute() >= besleme_dakika ) && (okuma < agirlik)){
          digitalWrite(buzzer_PIN,HIGH);
        }
        else{
          digitalWrite(buzzer_PIN,LOW);
        }
      }
    }
    else {
      Serial.println("Internet bağlantısı yok");
    }
    sonZaman = millis();
  }
}
