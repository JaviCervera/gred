cmake_minimum_required(VERSION 3.12)
project(gred)

# Build Irrlicht as a static library
add_subdirectory(lib/irrlicht)

# Collect all source files
file(GLOB GRED_SOURCES
    "src/*.cpp"
    "src/command/*.cpp"
)
list(APPEND GRED_SOURCES "lib/tinyfiledialogs/tinyfiledialogs.c")

if (APPLE)
    add_executable(gred MACOSX_BUNDLE ${GRED_SOURCES})
else()
    add_executable(gred ${GRED_SOURCES})
endif()

set_target_properties(gred PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
)

target_include_directories(gred PRIVATE
    "lib/irrlicht/include"
    "lib/tinyfiledialogs"
)

target_compile_definitions(gred PRIVATE _IRR_STATIC_LIB_)

# Set output directory
set_target_properties(gred PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/_build"
    BUNDLE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/_build"
)

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

    set(GRED_ASSET_SOURCE_DIR "${CMAKE_SOURCE_DIR}/_build")
    set(GRED_BUNDLE_RES_DIR "$<TARGET_FILE_DIR:gred>/../Resources")
    add_custom_command(TARGET gred POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory "${GRED_BUNDLE_RES_DIR}"
        COMMAND ${CMAKE_COMMAND} -E copy_directory "${GRED_ASSET_SOURCE_DIR}/textures" "${GRED_BUNDLE_RES_DIR}/textures"
        COMMAND ${CMAKE_COMMAND} -E copy_directory "${GRED_ASSET_SOURCE_DIR}/icons" "${GRED_BUNDLE_RES_DIR}/icons"
        COMMAND ${CMAKE_COMMAND} -E copy_directory "${GRED_ASSET_SOURCE_DIR}/levels" "${GRED_BUNDLE_RES_DIR}/levels"
        COMMENT "Copying game assets into gred.app bundle"
    )

    add_custom_command(TARGET gred POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E rm -f "${CMAKE_SOURCE_DIR}/_build/gred"
        COMMAND ${CMAKE_COMMAND} -E create_symlink "$<TARGET_FILE:gred>" "${CMAKE_SOURCE_DIR}/_build/gred"
        COMMENT "Creating _build/gred launcher symlink"
    )

    add_custom_command(TARGET gred POST_BUILD
        COMMAND codesign --force --deep -s - "$<TARGET_BUNDLE_DIR:gred>"
        COMMENT "Code-signing gred.app"
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
