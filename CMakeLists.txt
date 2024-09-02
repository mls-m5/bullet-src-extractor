# Minimum CMake version required
cmake_minimum_required(VERSION 3.10)

project(bullet3-src)

set(BULLET3_SRC_VERSION 1.0)

set(SOURCE_FILES
    src/btBulletCollisionAll.cpp
    src/btBulletDynamicsAll.cpp
    src/btLinearMathAll.cpp
)

add_library(
    BulletSrc
    STATIC
    ${SOURCE_FILES}
)

set_target_properties(
    BulletSrc PROPERTIES
    VERSION ${BULLET3_SRC_VERSION}
    SOVERSION 1
)

target_include_directories(
    BulletSrc
    PUBLIC ${CMAKE_SOURCE_DIR}/src
)

add_library(
    BulletSrc::BulletSrc
    ALIAS BulletSrc
)

