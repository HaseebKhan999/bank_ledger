cmake_minimum_required(VERSION 3.10)

project(BankLedger LANGUAGES CXX)

# -------------------------
# C++ Standard
# -------------------------
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# -------------------------
# MSVC-specific flags
# -------------------------
if(MSVC)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)   # Suppress secure warnings
    add_compile_options(/W3)                     # Warning level 3
endif()

# -------------------------
# Include directories
# -------------------------
include_directories(${CMAKE_SOURCE_DIR}/include)

# -------------------------
# Source files
# -------------------------
set(CORE_SOURCES
    src/transaction.cpp
    src/linked_list.cpp
    src/stack.cpp
    src/bank_ledger.cpp
)

# -------------------------
# 1. Shared library (DLL) for Flutter FFI
# -------------------------
add_library(bank_ledger_ffi SHARED
    ${CORE_SOURCES}
    src/ffi_bridge.cpp
)

# DLL name
set_target_properties(bank_ledger_ffi PROPERTIES
    OUTPUT_NAME "bank_ledger"
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build
    ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build
    WINDOWS_EXPORT_ALL_SYMBOLS ON
)

# -------------------------
# 2. Console executable for testing
# -------------------------
add_executable(bank_ledger_test
    main.cpp
    ${CORE_SOURCES}
)

set_target_properties(bank_ledger_test PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build
)

# -------------------------
# Multi-config support (Debug/Release)
# -------------------------
foreach(CONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${CONFIG} CONFIG_UPPER)

    set_target_properties(bank_ledger_ffi PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY_${CONFIG_UPPER} ${CMAKE_BINARY_DIR}/build
        LIBRARY_OUTPUT_DIRECTORY_${CONFIG_UPPER} ${CMAKE_BINARY_DIR}/build
        ARCHIVE_OUTPUT_DIRECTORY_${CONFIG_UPPER} ${CMAKE_BINARY_DIR}/build
    )

    set_target_properties(bank_ledger_test PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY_${CONFIG_UPPER} ${CMAKE_BINARY_DIR}/build
    )
endforeach()

# -------------------------
# Build information
# -------------------------
message(STATUS "========================================")
message(STATUS "Bank Ledger DSA Project - MSVC Build")
message(STATUS "========================================")
message(STATUS "C++ Standard: C++${CMAKE_CXX_STANDARD}")
message(STATUS "Compiler: ${CMAKE_CXX_COMPILER_ID}")
message(STATUS "")
message(STATUS "Build Targets:")
message(STATUS "  1. bank_ledger.dll     - Flutter FFI library")
message(STATUS "  2. bank_ledger_test.exe - Console demo/test")
message(STATUS "")
message(STATUS "Output Directory: ${CMAKE_BINARY_DIR}/build/")
message(STATUS "")
message(STATUS "DSA Features Implemented:")
message(STATUS "  ✓ Linked List (Traversal)")
message(STATUS "  ✓ Stack (Undo functionality)")
message(STATUS "  ✓ Merge Sort O(n log n) - Sort by date/amount")
message(STATUS "  ✓ Binary Search O(log n) - Search by ID")
message(STATUS "========================================")
