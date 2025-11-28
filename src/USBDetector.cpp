#include "USBDetector.h"
#include <iostream>

#ifdef _WIN32
#include <windows.h>
#endif

USBDetector::USBDetector() {}

USBDetector::~USBDetector() {}

bool USBDetector::detectUSBDrives() {
#ifdef _WIN32
    scanWindowsDrives();
#else
    scanLinuxDrives();
#endif
    return !usbPaths.empty();
}

std::vector<std::string> USBDetector::getUSBPaths() const {
    return usbPaths;
}

#ifdef _WIN32
void USBDetector::scanWindowsDrives() {
    usbPaths.clear();
    
    DWORD drives = GetLogicalDrives();
        
    for (char letter = 'D'; letter <= 'Z'; letter++) {
        int bit = letter - 'A';
        if (drives & (1 << bit)) {
            std::string drivePath = std::string(1, letter) + ":\\";
            
            UINT driveType = GetDriveTypeA(drivePath.c_str());
            
            std::cout << "Drive " << drivePath << " detectado. Tipo: ";
            switch(driveType) {
                case DRIVE_REMOVABLE: std::cout << "REMOVABLE"; break;
                case DRIVE_FIXED: std::cout << "FIXED"; break;
                case DRIVE_REMOTE: std::cout << "REMOTE"; break;
                case DRIVE_CDROM: std::cout << "CDROM"; break;
                case DRIVE_RAMDISK: std::cout << "RAMDISK"; break;
                default: std::cout << "UNKNOWN"; break;
            }
            std::cout << std::endl;

            if (driveType == DRIVE_REMOVABLE || driveType == DRIVE_FIXED) {
                if (GetDriveTypeA(drivePath.c_str()) != DRIVE_NO_ROOT_DIR) {
                    std::cout << "Agregado como USB: " << drivePath << std::endl;
                    usbPaths.push_back(drivePath);
                }
            }
        }
    }
    
    std::cout << "Total USBs encontrados: " << usbPaths.size() << std::endl;
}
#else
void USBDetector::scanLinuxDrives() {
    usbPaths.clear();

    std::string mediaPath = "/media/usb_drive/";

    // Verificamos si existe la carpeta
    if (fs::exists(mediaPath) && fs::is_directory(mediaPath)) {
        if (!fs::is_empty(mediaPath)) {
             usbPaths.push_back(mediaPath);
             std::cout << "USB detectada en: " << mediaPath << std::endl;
        }
    }
}
#endif
