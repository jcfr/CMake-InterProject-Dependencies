
#-------------------------------------------------------------
function(create_library_source)

  set(name ${KIT})

  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
"
void helloFrom${name}();
")

  set(_includes)
  set(_calls)
  foreach(dep ${KIT_DEPENDS})
    set(_includes "#include \"${dep}.h\"\n")
    set(_calls "helloFrom${dep}();\n")
  endforeach()

  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${name}.cpp"
"
#include \"${name}.h\"
${_includes}
#include <iostream>
void helloFrom${name}()
{
  std::cout << \"${name}\" << std::endl;
  ${_calls}
}
")

endfunction()

#-------------------------------------------------------------
function(create_executable_source)

  set(name ${PROJECT_NAME}Main)
  
  set(_includes)
  set(_calls)
  foreach(kit ${KITS})
    set(_includes "#include \"${kit}.h\"\n")
    set(_calls "helloFrom${kit}();\n")
  endforeach()
  
  file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/${name}.cpp"
"
#include <cstdlib>
#include <iostream>

${_includes}

int main(int, char*[])
{
  std::cout << \"Starting ${name}\" << std::endl;
  ${_calls}
}
")

endfunction()


#-------------------------------------------------------------
function(generate_config)

  set(CONFIG_INSTALL_DIR share/${PROJECT_NAME})
  set(CONFIG_BUILD_DIR ${CMAKE_BINARY_DIR})#/${CONFIG_INSTALL_DIR})

  # Configure '<proj>Targets.cmake'
  get_property(${PROJECT_NAME}_TARGETS GLOBAL PROPERTY ${PROJECT_NAME}_TARGETS)
  export(TARGETS ${${PROJECT_NAME}_TARGETS} APPEND FILE ${CONFIG_BUILD_DIR}/${PROJECT_NAME}Targets.cmake)

  include(CMakePackageConfigHelpers)
  
  set(PROJECT_CONFIG_CODE "####### Expanded from \@PROJECT_CONFIG_CODE\@ #######\n")
  foreach(proj ${PROJECT_DEPENDS})
    set(PROJECT_CONFIG_CODE "${PROJECT_CONFIG_CODE}find_package(${proj} REQUIRED)\n")
    set(PROJECT_CONFIG_CODE "${PROJECT_CONFIG_CODE}list(APPEND ${PROJECT_NAME}_INCLUDE_DIR \${${proj}_INCLUDE_DIRS})\n")
  endforeach()
  set(PROJECT_CONFIG_CODE "${PROJECT_CONFIG_CODE}##################################################")

  set(libraries ${${PROJECT_NAME}_TARGETS})

  # Configure '<proj>Config.cmake' for a build tree
  set(CONFIG_DIR_CONFIG ${CONFIG_BUILD_DIR})
  set(INCLUDE_DIR_CONFIG ${CMAKE_CURRENT_BINARY_DIR})
  set(_config ${CONFIG_BUILD_DIR}/${PROJECT_NAME}Config.cmake)
  message("Configuring ${_config}")
  configure_package_config_file(
      ${CMAKE_SOURCE_DIR}/../ProjConfig.cmake.in
      ${_config}
      INSTALL_DESTINATION ${CMAKE_BINARY_DIR}
      PATH_VARS CONFIG_DIR_CONFIG INCLUDE_DIR_CONFIG
      NO_CHECK_REQUIRED_COMPONENTS_MACRO
  )

endfunction()
