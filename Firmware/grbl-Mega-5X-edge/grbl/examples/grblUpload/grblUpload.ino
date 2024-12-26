/***********************************************************************
This sketch compiles and uploads Grbl to your Mega2560 Arduino board! 

To use:
- First make sure you have imported Grbl source code into your Arduino
  IDE. See more details on the Github wiki page of grbl-Mega-5X:
  https://github.com/fra589/grbl-Mega-5X/wiki/Compiling-grbl-Mega-5X

- Select your Arduino Board and Serial Port in the Tools drop-down menu.
  NOTE: grbl-Mega-5X only officially supports Mega2560 Arduino boards.
  Using other boards will likely not work!

- Then just click 'Upload'. That's it!

For advanced users:
  If you'd like to see what else Grbl can do, there are some additional
  options for customization and features you can enable or disable. 
  Navigate your file system to where the Arduino IDE has stored the Grbl 
  source code files, open the 'config.h' file in your favorite text 
  editor. Inside are dozens of feature descriptions and #defines. Simply
  comment or uncomment the #defines or alter their assigned values, save
  your changes, and then click 'Upload' here. 

Copyright (c) 2015 Sungeun K. Jeon
Released under the MIT-license. See license.txt for details.
***********************************************************************/

#include <grbl.h>

// Do not alter this file!
