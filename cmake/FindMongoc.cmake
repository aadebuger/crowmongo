# Read-Only variables:
#  BSON_FOUND - system has the BSON library
#  BSON_INCLUDE_DIR - the BSON include directory
#  BSON_LIBRARIES - The libraries needed to use BSON
#  BSON_VERSION - This is set to $major.$minor.$revision$path (eg. 0.4.1)

if (UNIX)
  find_package(PkgConfig QUIET)
  pkg_check_modules(_MONGOC QUIET libmongoc-1.0)
endif ()

find_path(MONGOC_INCLUDE_DIR
  NAMES
    libmongoc-1.0/mongoc.h
  HINTS
    ${MONGOC_ROOT_DIR}
  PATH_SUFFIXES
    include
)

set(MONGOC_INCLUDE_DIR "${MONGOC_INCLUDE_DIR}/libmongoc-1.0")

find_library(BSON
  NAMES
    "libmongoc-1.0"
  HINTS
    ${MONGOC_ROOT_DIR}
  PATH_SUFFIXES
    bin
    lib
)

if(WIN32)
   set(BSON_LIBRARIES ${BSON} ws2_32)
else()
  find_package (Threads REQUIRED)
  set(MONGOC_LIBRARIES ${BSON} ${CMAKE_THREAD_LIBS_INIT})
endif()

if (MONGOC_INCLUDE_DIR)
  if (_BSON_VERSION)
     set(BSON_VERSION "${_BSON_VERSION}")
  elseif(BSON_INCLUDE_DIR AND EXISTS "${BSON_INCLUDE_DIR}/bson-version.h")
     file(STRINGS "${BSON_INCLUDE_DIR}/bson-version.h" bson_version_str
        REGEX "^#define[\t ]+BSON_VERSION[\t ]+\([0-9.]+\)[\t ]+$")

     string(REGEX REPLACE "^.*BSON_VERSION[\t ]+\([0-9.]+\)[\t ]+$"
        "\\1" BSON_VERSION "${bson_version_str}")
  endif ()
endif ()

include(FindPackageHandleStandardArgs)

if (BSON_VERSION)
   find_package_handle_standard_args(BSON
    REQUIRED_VARS
      BSON_LIBRARIES
      BSON_INCLUDE_DIR
    VERSION_VAR
      BSON_VERSION
    FAIL_MESSAGE
      "Could NOT find BSON version"
  )
else ()
   find_package_handle_standard_args(BSON "Could NOT find BSON"
      BSON_LIBRARIES
      BSON_INCLUDE_DIR
  )
endif ()

mark_as_advanced(BSON_INCLUDE_DIR BSON_LIBRARIES)
