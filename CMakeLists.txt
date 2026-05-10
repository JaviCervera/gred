cmake_minimum_required(VERSION 3.12)
project(gred)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Build Irrlicht as a static library
add_subdirectory(lib/irrlicht)

# Collect all source files
file(GLOB GRED_SOURCES
    "src/*.cpp"
    "src/command/*.cpp"
)
list(APPEND GRED_SOURCES "lib/tinyfiledialogs/tinyfiledialogs.c")

add_executable(gred ${GRED_SOURCES})

target_include_directories(gred PRIVATE
    "lib/irrlicht/include"
    "lib/tinyfiledialogs"
)

target_compile_definitions(gred PRIVATE _IRR_STATIC_LIB_)

# Set output directory
set_target_properties(gred PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/_build")

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    if (MSVC)
        target_compile_definitions(gred PRIVATE _CRT_SECURE_NO_WARNINGS WIN32)
    else()
        # MinGW
        target_compile_definitions(gred PRIVATE DISABLE_SIMD WIN32)
        target_compile_options(gred PRIVATE -Wno-unused-parameter)
        set_target_properties(gred PROPERTIES LINK_FLAGS "-s -static -mwindows")
        target_link_libraries(gred Irrlicht opengl32 gdi32 winmm)
    endif()
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    target_compile_options(gred PRIVATE -DGL_SILENCE_DEPRECATION)
    target_link_libraries(gred Irrlicht
        "-framework Cocoa"
        "-framework IOKit"
        "-framework OpenGL"
    )
    add_custom_command(TARGET gred POST_BUILD
        COMMAND codesign --force --deep -s - $<TARGET_FILE:gred>
        COMMENT "Code-signing gred"
    )
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    target_compile_options(gred PRIVATE -fPIC)
    target_link_libraries(gred Irrlicht GL X11 Xxf86vm)
    add_custom_command(TARGET gred POST_BUILD
        COMMAND strip $<TARGET_FILE:gred>
        COMMENT "Stripping gred"
    )
else()
    target_link_libraries(gred Irrlicht)
endif()
