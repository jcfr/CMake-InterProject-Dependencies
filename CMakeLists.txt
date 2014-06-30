cmake_minimum_required(VERSION 2.8.9)
project(SuperProj)

include(ExternalProject)

#---------------------------------------------------------
function(force_rebuild name)
  # This custom external project step forces the build and later
  # steps to run whenever a top level build is done...
  ExternalProject_Add_Step(${proj} forcebuild
    COMMAND ${CMAKE_COMMAND} -E remove
      ${CMAKE_CURRENT_BINARY_DIR}/${proj}-prefix/src/${proj}-stamp/Slicer-build
    COMMENT "Forcing build step for '${proj}'"
    DEPENDEES build
    ALWAYS 1
    )
endfunction()

#---------------------------------------------------------
set(proj "ProjA")
set(${proj}_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
ExternalProject_Add(${proj}
  SOURCE_DIR ${CMAKE_SOURCE_DIR}/${proj}
  BINARY_DIR ${${proj}_DIR}
  DOWNLOAD_COMMAND ""
  INSTALL_COMMAND ""
  )
force_rebuild(${proj})

#---------------------------------------------------------
set(proj "ProjB")
set(${proj}_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
ExternalProject_Add(${proj}
  SOURCE_DIR ${CMAKE_SOURCE_DIR}/${proj}
  BINARY_DIR ${${proj}_DIR}
  DOWNLOAD_COMMAND ""
  INSTALL_COMMAND ""
  CMAKE_CACHE_ARGS
    -DProjA_DIR:PATH=${ProjA_DIR}
  DEPENDS ProjA
  )
force_rebuild(${proj})

#---------------------------------------------------------
set(proj "ProjC")
set(${proj}_DIR ${CMAKE_BINARY_DIR}/${proj}-build)
ExternalProject_Add(${proj}
  SOURCE_DIR ${CMAKE_SOURCE_DIR}/${proj}
  BINARY_DIR ${${proj}_DIR}
  DOWNLOAD_COMMAND ""
  INSTALL_COMMAND ""
  CMAKE_CACHE_ARGS
    -DProjA_DIR:PATH=${ProjA_DIR}
    -DProjB_DIR:PATH=${ProjB_DIR}
  DEPENDS ProjA ProjB
  )
force_rebuild(${proj})
