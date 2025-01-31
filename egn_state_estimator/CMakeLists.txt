cmake_minimum_required(VERSION 3.0.0)
project(egn_state_estimator VERSION 1.0.0 LANGUAGES CXX)

include(${CMAKE_CURRENT_SOURCE_DIR}/../cmakefiles/defaults/CMakeLists.txt)
include(${CMAKE_CURRENT_SOURCE_DIR}/../cmakefiles/compile-flags/CMakeLists.txt)

find_package(Eigen3)
if(NOT EIGEN3_FOUND)
  # Fallback to cmake_modules
  find_package(Eigen REQUIRED)
  set(EIGEN3_INCLUDE_DIRS ${EIGEN_INCLUDE_DIRS})
  set(EIGEN3_LIBRARIES ${EIGEN_LIBRARIES})
  # ...
endif()

set(CMAKE_BUILD_TYPE Debug)

set(EIGEN_INC_DIR /usr/include/eigen3/)
include_directories(
	include
	interface
	${EIGEN_INC_DIR}
	${Eigen_INCLUDE_DIRS}
	)

include(${CMAKE_CURRENT_SOURCE_DIR}/../cmakefiles/CMakeLists.txt)
