
if(APPLE)
    include(macos/includes.cmake)
endif(APPLE)

set(SOURCES ${SOURCES}
    utils.c
    win-list.c
)

add_library(neutron ${SOURCES})
target_link_libraries(neutron ${LIBRARIES})
target_include_directories(neutron PUBLIC ${PROJECT_SOURCE_DIR}/include)

if(APPLE)
    # set_property (TARGET neutron APPEND_STRING PROPERTY COMPILE_FLAGS "-fobjc-arc")
endif(APPLE)

install(TARGETS neutron DESTINATION lib)

