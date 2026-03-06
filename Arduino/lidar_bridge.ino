#include <RPLidar.h>
RPLidar lidar;
#define RPLIDAR_MOTOR 3 // Motor control pin (PWM)
void setup() {
// PC connection (Native USB port on Arduino Due)
SerialUSB.begin(115200);
delay(1000); // wait for USB connection
// LiDAR connection (UART1 on Due: RX1=19, TX1=18)
Serial1.begin(115200);
lidar.begin(Serial1);
// Motor pin setup
pinMode(RPLIDAR_MOTOR, OUTPUT);
analogWrite(RPLIDAR_MOTOR, 255); // full speed
// Start scanning
if (IS_OK(lidar.startScan())) {
SerialUSB.println("Angle,Distance,Quality");
} else {
SerialUSB.println("Lidar scan start failed!");
}
}
void loop() {
if (IS_OK(lidar.waitPoint())) {
float distance = lidar.getCurrentPoint().distance; // in mm
float angle = lidar.getCurrentPoint().angle; // in degrees
byte quality = lidar.getCurrentPoint().quality;
if (distance > 0 && quality > 0) {
SerialUSB.print(angle, 2);
SerialUSB.print(",");
SerialUSB.print(distance, 2);
SerialUSB.print(",");
SerialUSB.println(quality);
}
}
}
