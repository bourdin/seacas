# @HEADER
# ************************************************************************
#
#            TriBITS: Tribal Build, Integrate, and Test System
#                    Copyright 2013 Sandia Corporation
#
# Under the terms of Contract DE-AC04-94AL85000 with Sandia Corporation,
# the U.S. Government retains certain rights in this software.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the Corporation nor the names of the
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY SANDIA CORPORATION "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SANDIA CORPORATION OR THE
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ************************************************************************
# @HEADER


include(TribitsSetupStrongCompileWarnings)
include(PrependCmndlineArgs)
include(DualScopeAppendCmndlineArgs)


#
# Helper macros and functions
#


macro(tribits_apply_warnings_as_error_flags_lang LANG)
  prepend_cmndline_args(CMAKE_${LANG}_FLAGS
    "${${PROJECT_NAME}_WARNINGS_AS_ERRORS_FLAGS}")
  if (${PROJECT_NAME}_VERBOSE_CONFIGURE)
    message(STATUS "Setting up for ${LANG} warnings as errors just in this package ...")
    print_var(CMAKE_${LANG}_FLAGS)
  endif()
endmacro()


macro(tribits_set_package_language_flags LANG)

  #message("Entering tribits_set_package_language_flags(${LANG})")
  #print_var(${PROJECT_NAME}_ENABLE_STRONG_${LANG}_COMPILE_WARNINGS)

  if (${PACKAGE_NAME}_${LANG}_FLAGS)
    dual_scope_append_cmndline_args(CMAKE_${LANG}_FLAGS
      "${${PACKAGE_NAME}_${LANG}_FLAGS}")
  endif()

  if(${PROJECT_NAME}_VERBOSE_CONFIGURE)
    message(STATUS "Adding strong ${LANG} warning flags \"${${LANG}_STRONG_COMPILE_WARNING_FLAGS}\"")
    print_var(CMAKE_${LANG}_FLAGS)
  endif()

endmacro()


function(tribits_setup_add_package_compile_flags)

  #message("Entering tribits_setup_add_package_compile_flags()")

  #
  # C compiler options
  #

  assert_defined(${PROJECT_NAME}_ENABLE_C CMAKE_C_COMPILER_ID)
  if (${PROJECT_NAME}_ENABLE_C)
    tribits_set_package_language_flags(C)
  endif()

  #
  # C++ compiler options
  #

  assert_defined(${PROJECT_NAME}_ENABLE_CXX CMAKE_CXX_COMPILER_ID)
  if (${PROJECT_NAME}_ENABLE_CXX)
    tribits_set_package_language_flags(CXX)
  endif()

  #
  # Fortran compiler options
  #

  assert_defined(${PROJECT_NAME}_ENABLE_Fortran)
  if (${PROJECT_NAME}_ENABLE_Fortran)
    tribits_set_package_language_flags(Fortran)
  endif()

endfunction()













#
# Macro that sets up compiler flags for a package
#
# This CMake code is broken out in order to allow it to be unit tested.
#

macro(tribits_setup_compiler_flags  PACKAGE_NAME_IN)

  # Set up strong warning flags

  if (NOT PARSE_DISABLE_STRONG_WARNINGS AND NOT ${PACKAGE_NAME_IN}_DISABLE_STRONG_WARNINGS)
    tribits_setup_strong_compile_warnings(${PARSE_ENABLE_SHADOWING_WARNINGS})
  endif()

  # Set up for warnings as errors if requested

  assert_defined(PARSE_CLEANED)

  assert_defined(${PROJECT_NAME}_ENABLE_C ${PROJECT_NAME}_ENABLE_C_DEBUG_COMPILE_FLAGS)
  if (PARSE_CLEANED AND ${PROJECT_NAME}_ENABLE_STRONG_C_COMPILE_WARNINGS)
    tribits_apply_warnings_as_error_flags_lang(C)
  endif()

  assert_defined(${PROJECT_NAME}_ENABLE_CXX ${PROJECT_NAME}_ENABLE_CXX_DEBUG_COMPILE_FLAGS)
  if (PARSE_CLEANED AND ${PROJECT_NAME}_ENABLE_STRONG_CXX_COMPILE_WARNINGS)
    tribits_apply_warnings_as_error_flags_lang(CXX)
  endif()

  # Append package specific options
  tribits_setup_add_package_compile_flags()

  if (${PROJECT_NAME}_VERBOSE_CONFIGURE)
    message("Final compiler flags:")
    print_var(CMAKE_CXX_FLAGS)
    print_var(CMAKE_CXX_FLAGS_${CMAKE_BUILD_TYPE})
    print_var(CMAKE_C_FLAGS)
    print_var(CMAKE_C_FLAGS_${CMAKE_BUILD_TYPE})
    print_var(CMAKE_Fortran_FLAGS)
    print_var(CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE})
  endif()

endmacro()
