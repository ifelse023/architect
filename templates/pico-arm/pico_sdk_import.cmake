# Simplified pico_sdk_import.cmake for Arch Linux package manager installation

# Check for PICO_SDK_PATH in environment or cache
if(DEFINED ENV{PICO_SDK_PATH} AND (NOT PICO_SDK_PATH))
  set(PICO_SDK_PATH $ENV{PICO_SDK_PATH})
  message("Using PICO_SDK_PATH from environment ('${PICO_SDK_PATH}')")
endif()

# Ensure PICO_SDK_PATH is in the cache
set(PICO_SDK_PATH
    "${PICO_SDK_PATH}"
    CACHE PATH
    "Path to the Raspberry Pi Pico SDK"
)

# Validate the SDK path
get_filename_component(
    PICO_SDK_PATH
    "${PICO_SDK_PATH}"
    REALPATH
    BASE_DIR "${CMAKE_BINARY_DIR}"
)
if(NOT EXISTS ${PICO_SDK_PATH})
  message(FATAL_ERROR "Directory '${PICO_SDK_PATH}' not found")
endif()

# Verify that the path contains the Pico SDK
set(PICO_SDK_INIT_CMAKE_FILE ${PICO_SDK_PATH}/pico_sdk_init.cmake)
if(NOT EXISTS ${PICO_SDK_INIT_CMAKE_FILE})
  message(
        FATAL_ERROR
        "Directory '${PICO_SDK_PATH}'
        does not appear to contain the Raspberry Pi Pico SDK"
    )
endif()

# Include the SDK initialization file
include(${PICO_SDK_INIT_CMAKE_FILE})
