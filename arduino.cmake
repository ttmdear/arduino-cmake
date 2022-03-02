if (NOT DEFINED ARDUINO_HOME_DIR)
    message(SEND_ERROR "ARDUINO_HOME_DIR is not set")
endif ()

if (DEFINED PROFILE_ATTINY_85_1MHz)
    set(AVR_MMCU attiny85)
    set(AVR_CPU 1000000L)
    set(AVR_PARTNO attiny85)
elseif (DEFINED PROFILE_ATTINY_85_16MHz)
    set(AVR_MMCU attiny85)
    set(AVR_CPU 16000000L)
    set(AVR_PARTNO attiny85)
elseif (DEFINED PROFILE_ATTINY_85_12MHz)
    set(AVR_MMCU attiny85)
    set(AVR_CPU 12000000L)
    set(AVR_PARTNO attiny85)
endif ()

set(ARDUINO_CORE ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino)
set(AVR_BIN ${ARDUINO_HOME_DIR}/hardware/tools/avr/bin)
set(AVR_INCLUDE ${ARDUINO_HOME_DIR}/hardware/tools/avr/avr/include/avr)

include_directories(
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino
)

include_directories(
    /home/workstati/.arduino15/packages/attiny/hardware/avr/1.0.2/variants/tiny8
    # ${ARDUINO_HOME_DIR}/hardware/arduino/avr/variants/standard
)

set(ARDUINO_FLAGS "-DARDUINO=10816 -DARDUINO_attiny -DARDUINO_ARCH_AVR")

# C
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_COMPILER ${AVR_BIN}/avr-gcc)
# byc moze nie potrzebne -std=gnu++11
set(CMAKE_C_FLAGS "-c -g -Os -Wall -Wextra -std=gnu11 -ffunction-sections -fdata-sections -MMD -flto -fno-fat-lto-objects -mmcu=${AVR_MMCU} -DF_CPU=${AVR_CPU} ${ARDUINO_FLAGS}")
set(CMAKE_C_LINK_EXECUTABLE "${ARDUINO_HOME_DIR}/hardware/tools/avr/bin/avr-gcc -Wall -Wextra -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=${AVR_MMCU} <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_C_ARCHIVE_FINISH true)

# C++
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_COMPILER "${AVR_BIN}/avr-g++")
# byc moze nie potrzebne -std=gnu++11
set(CMAKE_CXX_FLAGS "-c -g -Os -Wall -Wextra -fpermissive -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -Wno-error=narrowing -MMD -flto -mmcu=${AVR_MMCU} -DF_CPU=${AVR_CPU} ${ARDUINO_FLAGS}")
set(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_C_LINK_EXECUTABLE}")
set(CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <LINK_FLAGS> <OBJECTS>")
set(CMAKE_CXX_ARCHIVE_FINISH true)

# ASM
set(CMAKE_ASM_COMPILER  "${AVR_BIN}/avr-gcc")
set(CMAKE_ASM_FLAGS "-c -g -x assembler-with-cpp -flto -MMD -mmcu=${AVR_MMCU} -DF_CPU=${AVR_CPU} ${ARDUINO_FLAGS}")

# set(CMAKE_RANLIB "")
set(CMAKE_AR ${ARDUINO_HOME_DIR}/hardware/tools/avr/bin/avr-gcc-ar)

add_custom_target(upload
    COMMAND ${AVR_BIN}/avr-objcopy -j .text -j .data -O ihex ${PROJECT_NAME} ${PROJECT_NAME}.hex
    COMMAND ${AVR_BIN}/avr-size --mcu=${AVR_MMCU} -C ${PROJECT_NAME}
    COMMAND ${AVR_BIN}/avrdude -C${ARDUINO_HOME_DIR}/hardware/tools/avr/etc/avrdude.conf -v -p${AVR_PARTNO} -cusbasp -Pusb -Uflash:w:${PROJECT_NAME}.hex:i
    VERBATIM)

add_dependencies(upload ${PROJECT_NAME})

add_library(Arduino_Core
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/wiring_pulse.S
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/WInterrupts.c
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/hooks.c
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/wiring_shift.c
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/wiring_digital.c
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/wiring_analog.c
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/wiring.c
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/wiring_pulse.c
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/CDC.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/PluggableUSB.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/HardwareSerial1.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/HardwareSerial3.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/HardwareSerial2.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/HardwareSerial.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/IPAddress.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/HardwareSerial0.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/Print.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/Stream.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/Tone.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/USBCore.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/WMath.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/WString.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/abi.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/main.cpp
    ${ARDUINO_HOME_DIR}/hardware/arduino/avr/cores/arduino/new.cpp
)

# add_library(SPI
#     ${ARDUINO_HOME_DIR}/hardware/arduino/avr/libraries/SPI/src/SPI.cpp)
#
# include_directories(
#     ${ARDUINO_HOME_DIR}/hardware/arduino/avr/libraries/SPI/src)
