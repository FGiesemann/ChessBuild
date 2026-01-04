option(ENABLE_LTO "Enable Link Time Optimization" ON)
set(ARCH_LEVEL "v3" CACHE STRING "x86-64 Architecture Level: generic, v2, v3, v4, native")

add_library(chess_compiler_settings INTERFACE)

target_compile_options(chess_compiler_settings INTERFACE
    $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:
        -O3
        -march=$<IF:$<STREQUAL:${ARCH_LEVEL},native>,native,x86-64-${ARCH_LEVEL}>
        $<$<BOOL:${ENABLE_LTO}>:-flto=thin>
        -Wall -Wextra -Wpedantic
    >
    $<$<CXX_COMPILER_ID:MSVC>:
        /O2 /Oi /Ot /GT
        $<$<STREQUAL:${ARCH_LEVEL},v3>:/arch:AVX2>
        $<$<STREQUAL:${ARCH_LEVEL},v4>:/arch:AVX512>
        $<$<BOOL:${ENABLE_LTO}>:/GL>
        /W4 /permissive- 
    >
)

target_link_options(chess_compiler_settings INTERFACE
    $<$<CXX_COMPILER_ID:GNU>:$<$<BOOL:${ENABLE_LTO}>:-flto>>
    $<$<CXX_COMPILER_ID:Clang>:$<$<BOOL:${ENABLE_LTO}>:-flto=thin -fuse-ld=lld>>
    $<$<CXX_COMPILER_ID:MSVC>:$<$<BOOL:${ENABLE_LTO}>:/LTCG /INCREMENTAL:NO>>
)

set_target_properties(chess_compiler_settings PROPERTIES EXPORT_NO_SYSTEM ON)
