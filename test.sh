echo
echo "==============> BUILDING Tests =============="
echo
mkdir -p "/home/pi/avs-device-sdk/KWD/inputs/SensoryModels/"
cp "/home/pi/third-party/alexa-rpi/models/spot-alexa-rpi-31000.snsr" "/home/pi/avs-device-sdk/KWD/inputs/SensoryModels/"
cd /home/pi/build
make all test -j2
chmod +x "/home/pi/startsample.sh"
