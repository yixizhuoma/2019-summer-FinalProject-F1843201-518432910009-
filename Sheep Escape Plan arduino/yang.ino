#define sound_pin A0    
int sensorvalue;
void setup()
{
    Serial.begin(115200);                
}
void loop()
{
    sensorvalue=analogRead(sound_pin); 
    if (sensorvalue>40) {
Serial.println(sensorvalue,DEC); 
        delay(100);
    }
}
