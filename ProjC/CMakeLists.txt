cmake_minimum_required(VERSION 2.8.9)
project(ProjC)

set(PROJECT_DEPENDS )

#-------------------------------------------------------------
find_package(ProjB REQUIRED)
include_directories(${ProjB_INCLUDE_DIRS})
list(APPEND PROJECT_DEPENDS ProjB)

#-------------------------------------------------------------
include(../Common.cmake)

set(KITS )

#-------------------------------------------------------------
# ProjCLib1 depends on ProjBLib1

set(KIT ${PROJECT_NAME}Lib1)
set(KIT_DEPENDS ProjBLib1)
create_library_source()
add_library(${KIT} SHARED
  ${KIT}.h
  ${KIT}.cpp
  )
target_link_libraries(${KIT} ${ProjB_LIBRARIES})
list(APPEND KITS ${KIT})

# Export target
set_property(GLOBAL APPEND PROPERTY ${PROJECT_NAME}_TARGETS ${KIT})


#-------------------------------------------------------------
create_executable_source()
add_executable(${PROJECT_NAME}Main ${PROJECT_NAME}Main.cpp)
target_link_libraries(${PROJECT_NAME}Main ${KITS})

#-------------------------------------------------------------
generate_config()
