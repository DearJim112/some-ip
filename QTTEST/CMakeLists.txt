
cmake_minimum_required(VERSION 3.0)
project(demo)

find_package(Qt5Widgets REQUIRED)
find_package(Qt5Gui REQUIRED)
find_package(Qt5Widgets)
add_executable(demo demo.cpp)

target_include_directories(demo PRIVATE ${Qt5Widgets_INCLUDE_DIRS} ${Qt5Gui_INCLUDE_DIRS})
target_link_libraries(demo PRIVATE Qt5::Widgets Qt5::Gui)
