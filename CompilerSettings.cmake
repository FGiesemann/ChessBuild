option(ENABLE_LTO "Enable Link Time Optimization" ON)
set(ARCH_LEVEL "v2" CACHE STRING "x86-64 Architecture Level: generic, v2, v3, v4, native")

function(add_optimization_settings TARGET_NAME)
    set(_ARCH_STR $<IF:$<STREQUAL:${ARCH_LEVEL},native>,native,x86-64-${ARCH_LEVEL}>)

    target_compile_options(${TARGET_NAME} PRIVATE
        # LTO
        $<$<AND:$<CXX_COMPILER_ID:GNU>,$<BOOL:${ENABLE_LTO}>>:-flto>
        $<$<AND:$<CXX_COMPILER_ID:Clang>,$<BOOL:${ENABLE_LTO}>>:-flto=thin>
        $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<BOOL:${ENABLE_LTO}>>:/GL;/W4;/permissive->

        $<$<CXX_COMPILER_ID:GNU>:-O3>
        $<$<CXX_COMPILER_ID:GNU>:-march=${_ARCH_STR}>

        $<$<CXX_COMPILER_ID:Clang>:-O3>
        $<$<CXX_COMPILER_ID:Clang>:-march=${_ARCH_STR}>

        $<$<CXX_COMPILER_ID:MSVC>:/O2>
        $<$<CXX_COMPILER_ID:MSVC>:/Oi>
        $<$<CXX_COMPILER_ID:MSVC>:/Ot>
        $<$<CXX_COMPILER_ID:MSVC>:/Gt>
        $<$<CXX_COMPILER_ID:MSVC>:$<$<STREQUAL:${ARCH_LEVEL},v3>:/arch:AVX2>>
        $<$<CXX_COMPILER_ID:MSVC>:$<$<STREQUAL:${ARCH_LEVEL},v4>:/arch:AVX512>>
        $<$<CXX_COMPILER_ID:MSVC>:>
    )

    target_link_options(${TARGET_NAME} PRIVATE
        $<$<AND:$<CXX_COMPILER_ID:GNU>,$<BOOL:${ENABLE_LTO}>>:-flto>

        $<$<AND:$<CXX_COMPILER_ID:Clang>,$<BOOL:${ENABLE_LTO}>>:-flto=thin>
        $<$<AND:$<CXX_COMPILER_ID:Clang>,$<BOOL:${ENABLE_LTO}>>:-fuse-ld=lld>
        
        $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<BOOL:${ENABLE_LTO}>>:/LTCG>
        $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<BOOL:${ENABLE_LTO}>>:/INCREMENTAL:NO>
    )
endfunction()
