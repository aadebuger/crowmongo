project( crowmongo )
cmake_minimum_required( VERSION 2.8 )
#set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

# remove compiler checks if you are using VS2010, it supports
#   1. auto
#   2. lambda
#   3. const iterator
# and, sadly, it doesn't support `for(item, cotainer)'
include( CheckCXXCompilerFlag )
check_cxx_compiler_flag( "-std=c++11"   COMPILER_SUPPORTS_CXX11 )
check_cxx_compiler_flag( "-std=c++0x"   COMPILER_SUPPORTS_CXX0X )
if( COMPILER_SUPPORTS_CXX11 )
    if( CMAKE_COMPILER_IS_GNUCXX )
        set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11" )
    else()
        set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11" )
    endif()
elseif( COMPILER_SUPPORTS_CXX0X)
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x" )
else()
    # MSVC, On by default (if available)
endif()
find_package( Boost 1.58.0 REQUIRED COMPONENTS system thread )
include_directories( ${Boost_INCLUDE_DIR} ) 
include_directories( /Users/aadebuger/github/mongo-cxx-driver/build/install/include/bsoncxx/v_noabi/)
include_directories( /Users/aadebuger/github/mongo-cxx-driver/build/install/include/mongocxx/v_noabi/)

#include_directories( /usr/local/include/libmongoc-1.0 ) 

#include_directories( /usr/local/include/libbson-1.0 )
link_directories( /Users/aadebuger/github/mongo-cxx-driver/build/install/lib )
link_directories( /usr/local/lib )
add_subdirectory(ext/crow)

include_directories(ext/crow/include)

include( cmake/FindBSON.cmake )
#include( cmake/FindLibMongoC.cmake)
pkg_check_modules(_LIBMONGOC QUIET libmongoc-1.0)

pkg_check_modules ( mongoc-1.0  libmongoc-1.0)

message( STATUS "mongoc-1.0=" ${mongoc-1.0_INCLUDE_DIRS} )

include_directories( ${mongoc-1.0_INCLUDE_DIRS} )
add_executable( ${PROJECT_NAME} main.cpp )
add_executable( jsonmain  jsonmain.cpp )
add_executable( mongorest  mongorest.cpp )
add_executable( mongoexample  mongoexample.c )

target_link_libraries( ${PROJECT_NAME} ${Boost_LIBRARIES} )
target_link_libraries( jsonmain ${Boost_LIBRARIES} )
target_link_libraries( mongorest ${Boost_LIBRARIES} )
target_link_libraries( mongoexample  mongoc-1.0.0 bson-1.0 )

#target_link_libraries(${PROJECT_NAME}  network-uri)
