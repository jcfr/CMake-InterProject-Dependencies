cmake_minimum_required(VERSION 2.8.9)
project(ProjA)

set(PROJECT_DEPENDS )

#-------------------------------------------------------------
include(../Common.cmake)

set(KITS )

#-------------------------------------------------------------
set(KIT ${PROJECT_NAME}Lib1)
set(KIT_DEPENDS )
create_library_source()
add_library(${KIT} SHARED
  ${KIT}.h
  ${KIT}.cpp
  )
list(APPEND KITS ${KIT})

# Export target
set_property(GLOBAL APPEND PROPERTY ${PROJECT_NAME}_TARGETS ${KIT})

#-------------------------------------------------------------
generate_config()
