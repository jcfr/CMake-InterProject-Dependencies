cmake_minimum_required(VERSION 2.8.9)
project(ProjB)

set(PROJECT_DEPENDS )

#-------------------------------------------------------------
find_package(ProjA REQUIRED)
include_directories(${ProjA_INCLUDE_DIRS})
list(APPEND PROJECT_DEPENDS ProjA)

#-------------------------------------------------------------
include(../Common.cmake)

set(KITS )

#-------------------------------------------------------------
# ProjBLib1 depends on ProjALib1

set(KIT ${PROJECT_NAME}Lib1)
set(KIT_DEPENDS ProjALib1)
create_library_source()
add_library(${KIT} SHARED
  ${KIT}.h
  ${KIT}.cpp
  )
target_link_libraries(${KIT} ${ProjA_LIBRARIES})
list(APPEND KITS ${KIT})

# Export target
set_property(GLOBAL APPEND PROPERTY ${PROJECT_NAME}_TARGETS ${KIT})

#-------------------------------------------------------------
generate_config()
