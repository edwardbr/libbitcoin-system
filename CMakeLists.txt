# Copyright (c) 2017 The Bitcoin developers

cmake_minimum_required(VERSION 3.13)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON) 

set(CMAKE_VERBOSE_MAKEFILE ON)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)


include(HunterGate)

message(STATUS "[project] CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}")

option(HUNTER_STATUS_DEBUG "Hunter debug info" ON)
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.23.165.tar.gz"
    SHA1 "5a73f91df5f6109c0bb1104d0c0ee423f7bece79"
    LOCAL
)

set(HUNTER_KEEP_PACKAGE_SOURCES ON)
option(HUNTER_STATUS_DEBUG "Hunter debug info" ON)

project(libbitcoin-system VERSION 0.1)

include(CTest)

# Implement -Dwith-tests and declare with-tests.
#------------------------------------------------------------------------------
option(with-tests "Compile with unit tests" "no")

# Implement -Dwith-examples and declare with-examples.
#------------------------------------------------------------------------------
option( with-examples  "Compile with examples." "no")

# Implement -Dwith-icu and define BOOST_HAS_ICU and output ${icu}.
#------------------------------------------------------------------------------
option( with-icu "Compile with International Components for Unicode." "no" )

# Implement -Dwith-png and output ${png}.
#------------------------------------------------------------------------------
option( with-png "Compile with Libpng support." "no")

# Implement -Dwith-qrencode and output ${qrencode}.
#------------------------------------------------------------------------------
option( with-qrencode "Compile with QREncode." "no" )

# select a particular windows version for optimal performance 0x0A00 is windows 10
#------------------------------------------------------------------------------
set( windows-version "0x0A00" )

# Find secp256k1
#------------------------------------------------------------------------------

hunter_add_package(secp256k1)
find_package(secp256k1 CONFIG REQUIRED)

# Find boost
#------------------------------------------------------------------------------

hunter_add_package(Boost COMPONENTS 
    atomic
    chrono
    date_time
    filesystem
    iostreams
    log
	locale
    program_options
    regex
    system
    thread
    test)

find_package(Boost CONFIG REQUIRED 
    atomic
    chrono
    date_time
    filesystem
    iostreams
    log_setup
    log
	locale
    program_options
    regex
    system
    thread
    unit_test_framework)

# Find icu-i18n
#------------------------------------------------------------------------------
if (with-icu)
    message(STATUS "compiling with ICU")
    hunter_add_package(ICU)
    find_package(ICU CONFIG REQUIRED)
    
    add_definitions( -DBOOST_HAS_ICU )
    add_definitions( -DWITH_ICU )
endif()

# Find png
#------------------------------------------------------------------------------
if (with-png)
    set( png "-DWITH_PNG" )
    hunter_add_package(PNG)
    find_package(PNG CONFIG REQUIRED)
endif()

# Find qrencode
#------------------------------------------------------------------------------
if (with-qrencode)
    set( qrencode "-DWITH_QRENCODE" )
    find_package( Qrencode 3.4.4 REQUIRED )
endif()

add_library( ${PROJECT_NAME}
    "src/error.cpp"
    "src/settings.cpp"
    "src/chain/block.cpp"
    "src/chain/chain_state.cpp"
    "src/chain/compact.cpp"
    "src/chain/header.cpp"
    "src/chain/input.cpp"
    "src/chain/output.cpp"
    "src/chain/output_point.cpp"
    "src/chain/payment_record.cpp"
    "src/chain/point.cpp"
    "src/chain/point_value.cpp"
    "src/chain/points_value.cpp"
    "src/chain/script.cpp"
    "src/chain/stealth_record.cpp"
    "src/chain/transaction.cpp"
    "src/chain/witness.cpp"
    "src/config/authority.cpp"
    "src/config/base16.cpp"
    "src/config/base2.cpp"
    "src/config/base58.cpp"
    "src/config/base64.cpp"
    "src/config/block.cpp"
    "src/config/checkpoint.cpp"
    "src/config/directory.cpp"
    "src/config/endpoint.cpp"
    "src/config/hash160.cpp"
    "src/config/hash256.cpp"
    "src/config/header.cpp"
    "src/config/input.cpp"
    "src/config/output.cpp"
    "src/config/parameter.cpp"
    "src/config/parser.cpp"
    "src/config/point.cpp"
    "src/config/printer.cpp"
    "src/config/script.cpp"
    "src/config/sodium.cpp"
    "src/config/transaction.cpp"
    "src/formats/base_10.cpp"
    "src/formats/base_16.cpp"
    "src/formats/base_32.cpp"
    "src/formats/base_58.cpp"
    "src/formats/base_64.cpp"
    "src/formats/base_85.cpp"
    "src/log/file_collector.cpp"
    "src/log/file_collector_repository.cpp"
    "src/log/file_counter_formatter.cpp"
    "src/log/sink.cpp"
    "src/log/statsd_sink.cpp"
    "src/log/udp_client_sink.cpp"
    "src/machine/interpreter.cpp"
    "src/machine/number.cpp"
    "src/machine/opcode.cpp"
    "src/machine/operation.cpp"
    "src/machine/program.cpp"
    "src/math/checksum.cpp"
    "src/math/crypto.cpp"
    "src/math/ec_point.cpp"
    "src/math/ec_scalar.cpp"
    "src/math/elliptic_curve.cpp"
    "src/math/hash.cpp"
    "src/math/ring_signature.cpp"
    "src/math/secp256k1_initializer.cpp"
    "src/math/secp256k1_initializer.hpp"
    "src/math/stealth.cpp"
    "src/math/external/aes256.c"
    "src/math/external/aes256.h"
    "src/math/external/crypto_scrypt.c"
    "src/math/external/crypto_scrypt.h"
    "src/math/external/hmac_sha256.c"
    "src/math/external/hmac_sha256.h"
    "src/math/external/hmac_sha512.c"
    "src/math/external/hmac_sha512.h"
    "src/math/external/lax_der_parsing.c"
    "src/math/external/lax_der_parsing.h"
    "src/math/external/pbkdf2_sha256.c"
    "src/math/external/pbkdf2_sha256.h"
    "src/math/external/pkcs5_pbkdf2.c"
    "src/math/external/pkcs5_pbkdf2.h"
    "src/math/external/ripemd160.c"
    "src/math/external/ripemd160.h"
    "src/math/external/sha1.c"
    "src/math/external/sha1.h"
    "src/math/external/sha256.c"
    "src/math/external/sha256.h"
    "src/math/external/sha512.c"
    "src/math/external/sha512.h"
    "src/math/external/zeroize.c"
    "src/math/external/zeroize.h"
    "src/message/address.cpp"
    "src/message/alert.cpp"
    "src/message/alert_payload.cpp"
    "src/message/block.cpp"
    "src/message/block_transactions.cpp"
    "src/message/compact_block.cpp"
    "src/message/fee_filter.cpp"
    "src/message/filter_add.cpp"
    "src/message/filter_clear.cpp"
    "src/message/filter_load.cpp"
    "src/message/get_address.cpp"
    "src/message/get_block_transactions.cpp"
    "src/message/get_blocks.cpp"
    "src/message/get_data.cpp"
    "src/message/get_headers.cpp"
    "src/message/header.cpp"
    "src/message/headers.cpp"
    "src/message/heading.cpp"
    "src/message/inventory.cpp"
    "src/message/inventory_vector.cpp"
    "src/message/memory_pool.cpp"
    "src/message/merkle_block.cpp"
    "src/message/messages.cpp"
    "src/message/network_address.cpp"
    "src/message/not_found.cpp"
    "src/message/ping.cpp"
    "src/message/pong.cpp"
    "src/message/prefilled_transaction.cpp"
    "src/message/reject.cpp"
    "src/message/send_compact.cpp"
    "src/message/send_headers.cpp"
    "src/message/transaction.cpp"
    "src/message/verack.cpp"
    "src/message/version.cpp"
    "src/unicode/console_streambuf.cpp"
    "src/unicode/ifstream.cpp"
    "src/unicode/ofstream.cpp"
    "src/unicode/unicode.cpp"
    "src/unicode/unicode_istream.cpp"
    "src/unicode/unicode_ostream.cpp"
    "src/unicode/unicode_streambuf.cpp"
    "src/utility/binary.cpp"
    "src/utility/conditional_lock.cpp"
    "src/utility/deadline.cpp"
    "src/utility/dispatcher.cpp"
    "src/utility/flush_lock.cpp"
    "src/utility/interprocess_lock.cpp"
    "src/utility/istream_reader.cpp"
    "src/utility/monitor.cpp"
    "src/utility/ostream_writer.cpp"
    "src/utility/png.cpp"
    "src/utility/prioritized_mutex.cpp"
    "src/utility/property_tree.cpp"
    "src/utility/pseudo_random.cpp"
    "src/utility/scope_lock.cpp"
    "src/utility/sequencer.cpp"
    "src/utility/sequential_lock.cpp"
    "src/utility/socket.cpp"
    "src/utility/string.cpp"
    "src/utility/thread.cpp"
    "src/utility/threadpool.cpp"
    "src/utility/work.cpp"
    "src/wallet/bitcoin_uri.cpp"
    "src/wallet/dictionary_en.cpp"
    "src/wallet/dictionary_es.cpp"
    "src/wallet/dictionary_fr.cpp"
    "src/wallet/dictionary_it.cpp"
    "src/wallet/dictionary_ja.cpp"
    "src/wallet/dictionary_ko.cpp"
    "src/wallet/dictionary_zh_Hans.cpp"
    "src/wallet/dictionary_zh_Hant.cpp"
    "src/wallet/ec_private.cpp"
    "src/wallet/ec_public.cpp"
    "src/wallet/ek_private.cpp"
    "src/wallet/ek_public.cpp"
    "src/wallet/ek_token.cpp"
    "src/wallet/electrum.cpp"
    "src/wallet/electrum_dictionary.cpp"
    "src/wallet/electrum_dictionary_en.cpp"
    "src/wallet/electrum_dictionary_es.cpp"
    "src/wallet/electrum_dictionary_ja.cpp"
    "src/wallet/electrum_dictionary_pt.cpp"
    "src/wallet/electrum_dictionary_zh_Hans.cpp"
    "src/wallet/encrypted_keys.cpp"
    "src/wallet/hd_private.cpp"
    "src/wallet/hd_public.cpp"
    "src/wallet/message.cpp"
    "src/wallet/mini_keys.cpp"
    "src/wallet/mnemonic.cpp"
    "src/wallet/payment_address.cpp"
    "src/wallet/qrcode.cpp"
    "src/wallet/select_outputs.cpp"
    "src/wallet/stealth_address.cpp"
    "src/wallet/stealth_receiver.cpp"
    "src/wallet/stealth_sender.cpp"
    "src/wallet/uri.cpp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_key.hpp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_key.ipp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_prefix.hpp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_prefix.ipp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_private.cpp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_private.hpp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_public.cpp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_public.hpp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_token.cpp"
    "src/wallet/parse_encrypted_keys/parse_encrypted_token.hpp" )


if(WIN32)
	target_compile_options(${PROJECT_NAME} PRIVATE 
		"-DBC_STATIC" 
		"-DNOMINMAX" 
		"-D_WIN32_WINNT=${windows-version}")
else(WIN32)
    # libsecp256k1 use a different set of flags.
    target_compile_options(${PROJECT_NAME} PRIVATE
         "-Wall" 

        # Warn on extra stuff.
        "-Wextra" 

        # Be really annoying.
        "-Wpedantic" 

        # Disallow warning on style order of declarations.
        "-Wno-reorder" 

        # Suppress warning for incomplete field initialization.
        "-Wno-missing-field-initializers" 

        # Conform to style.
        "-Wno-missing-braces" 

        # Ignore comments within comments or commenting of backslash extended lines.
        "-Wno-comment" 

        # Allow use of C99 'long long' type.
        "-Wno-long-long"
    )
endif()


# Conflict in stdlib under clang.
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
     target_compile_options(${PROJECT_NAME} PRIVATE "-Wno-mismatched-tags") 
endif()

# Limit delays and warnings.
if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
     target_compile_options(${PROJECT_NAME} PRIVATE "-fno-var-tracking-assignments" )
endif()

target_include_directories( ${PROJECT_NAME} PRIVATE include)

target_link_libraries( ${PROJECT_NAME}  
                            Boost::chrono
                            Boost::date_time
                            Boost::filesystem
                            Boost::iostreams
                            Boost::log_setup
                            Boost::log
                            Boost::program_options
                            Boost::regex
                            Boost::system
                            Boost::thread
                            Threads::Threads
                            secp256k1::secp256k1)

if (with-icu)
    target_link_libraries( ${PROJECT_NAME} 
        ICU::uc
        ICU::i18n
        ICU::data
        Boost::locale)
endif ()

# Define libbitcoin-system-examples project.
#------------------------------------------------------------------------------
if (with-examples)
    add_executable( ${PROJECT_NAME}-examples
        "examples/main.cpp" )

	if(WIN32)
		target_compile_options(${PROJECT_NAME}-examples PRIVATE 
			"-DBC_STATIC" 
			"-DNOMINMAX" 
			"-D_WIN32_WINNT=${windows-version}")
	endif(WIN32)

#     libbitcoin-system-examples project specific include directories.
    #------------------------------------------------------------------------------
    target_include_directories( ${PROJECT_NAME}-examples PRIVATE
        "include" )

    #     libbitcoin-system-examples project specific libraries/linker flags.
    #------------------------------------------------------------------------------
    target_link_libraries( ${PROJECT_NAME}-examples
        ${PROJECT_NAME} 
        secp256k1::secp256k1
            Boost::locale)
        
    if (with-icu)
        target_link_libraries( ${PROJECT_NAME}-examples
            ICU::uc
            ICU::i18n
            ICU::data)
    endif ()
endif()

# Define libbitcoin-system-test project.
#------------------------------------------------------------------------------
if (with-tests)
    add_executable( ${PROJECT_NAME}-test
        "test/main.cpp"
        "test/settings.cpp"
        "test/chain/block.cpp"
        "test/chain/chain_state.cpp"
        "test/chain/compact.cpp"
        "test/chain/header.cpp"
        "test/chain/input.cpp"
        "test/chain/output.cpp"
        "test/chain/output_point.cpp"
        "test/chain/payment_record.cpp"
        "test/chain/point.cpp"
        "test/chain/point_value.cpp"
        "test/chain/points_value.cpp"
        "test/chain/satoshi_words.cpp"
        "test/chain/script.cpp"
        "test/chain/script.hpp"
        "test/chain/stealth_record.cpp"
        "test/chain/transaction.cpp"
        "test/config/authority.cpp"
        "test/config/base58.cpp"
        "test/config/block.cpp"
        "test/config/checkpoint.cpp"
        "test/config/endpoint.cpp"
        "test/config/hash256.cpp"
        "test/config/parameter.cpp"
        "test/config/printer.cpp"
        "test/formats/base_10.cpp"
        "test/formats/base_16.cpp"
        "test/formats/base_32.cpp"
        "test/formats/base_58.cpp"
        "test/formats/base_64.cpp"
        "test/formats/base_85.cpp"
        "test/machine/number.cpp"
        "test/machine/number.hpp"
        "test/machine/opcode.cpp"
        "test/machine/operation.cpp"
        "test/math/checksum.cpp"
        "test/math/ec_point.cpp"
        "test/math/ec_scalar.cpp"
        "test/math/elliptic_curve.cpp"
        "test/math/hash.cpp"
        "test/math/hash.hpp"
        "test/math/limits.cpp"
        "test/math/ring_signature.cpp"
        "test/math/stealth.cpp"
        "test/math/uint256.cpp"
        "test/message/address.cpp"
        "test/message/alert.cpp"
        "test/message/alert_payload.cpp"
        "test/message/block.cpp"
        "test/message/block_transactions.cpp"
        "test/message/compact_block.cpp"
        "test/message/fee_filter.cpp"
        "test/message/filter_add.cpp"
        "test/message/filter_clear.cpp"
        "test/message/filter_load.cpp"
        "test/message/get_address.cpp"
        "test/message/get_block_transactions.cpp"
        "test/message/get_blocks.cpp"
        "test/message/get_data.cpp"
        "test/message/get_headers.cpp"
        "test/message/header.cpp"
        "test/message/headers.cpp"
        "test/message/heading.cpp"
        "test/message/inventory.cpp"
        "test/message/inventory_vector.cpp"
        "test/message/memory_pool.cpp"
        "test/message/merkle_block.cpp"
        "test/message/messages.cpp"
        "test/message/network_address.cpp"
        "test/message/not_found.cpp"
        "test/message/ping.cpp"
        "test/message/pong.cpp"
        "test/message/prefilled_transaction.cpp"
        "test/message/reject.cpp"
        "test/message/send_compact.cpp"
        "test/message/send_headers.cpp"
        "test/message/transaction.cpp"
        "test/message/verack.cpp"
        "test/message/version.cpp"
        "test/unicode/unicode.cpp"
        "test/unicode/unicode_istream.cpp"
        "test/unicode/unicode_ostream.cpp"
        "test/utility/binary.cpp"
        "test/utility/collection.cpp"
        "test/utility/data.cpp"
        "test/utility/endian.cpp"
        "test/utility/png.cpp"
        "test/utility/property_tree.cpp"
        "test/utility/pseudo_random.cpp"
        "test/utility/serializer.cpp"
        "test/utility/stream.cpp"
        "test/utility/thread.cpp"
        "test/wallet/bitcoin_uri.cpp"
        "test/wallet/ec_private.cpp"
        "test/wallet/ec_public.cpp"
        "test/wallet/electrum.cpp"
        "test/wallet/encrypted_keys.cpp"
        "test/wallet/hd_private.cpp"
        "test/wallet/hd_public.cpp"
        "test/wallet/message.cpp"
        "test/wallet/mnemonic.cpp"
        "test/wallet/mnemonic.hpp"
        "test/wallet/payment_address.cpp"
        "test/wallet/qrcode.cpp"
        "test/wallet/select_outputs.cpp"
        "test/wallet/stealth_address.cpp"
        "test/wallet/stealth_receiver.cpp"
        "test/wallet/stealth_sender.cpp"
        "test/wallet/uri.cpp"
        "test/wallet/uri_reader.cpp" )

	if(WIN32)
		target_compile_options(${PROJECT_NAME}-test PRIVATE 
			"-DBC_STATIC" 
			"-DNOMINMAX" 
			"-D_WIN32_WINNT=${windows-version}")
	endif(WIN32)

    add_test( NAME ${PROJECT_NAME}-test COMMAND ${PROJECT_NAME}-test
            --run_test=*
            --show_progress=no
            --detect_memory_leak=0
            --report_level=no
            --build_info=yes )

#     libbitcoin-system-test project specific include directories.
#------------------------------------------------------------------------------
    target_include_directories( ${PROJECT_NAME}-test PRIVATE
        "include" )

#     libbitcoin-system-test project specific libraries/linker flags.
#------------------------------------------------------------------------------
    target_link_libraries( ${PROJECT_NAME}-test
        ${PROJECT_NAME}
        Boost::unit_test_framework )

    if (with-icu)
        target_link_libraries( ${PROJECT_NAME}-test
            ICU::uc
            ICU::i18n
            ICU::data
            Boost::locale)
    endif ()
endif()




set(pc_config "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.pc")
configure_file(${PROJECT_NAME}.pc.in ${pc_config} @ONLY)

#set(la_config "${CMAKE_CURRENT_BINARY_DIR}/lib${PROJECT_NAME}.la")
#configure_file(${PROJECT_NAME}.la.in ${la_config} @ONLY)

# Installation (https://github.com/forexample/package-example) {

set(config_install_dir "lib/cmake/${PROJECT_NAME}")
set(include_install_dir "include")

set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")

set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")

include(CMakePackageConfigHelpers)

# Use:
#   * PROJECT_VERSION
write_basic_package_version_file(
    "${version_config}" COMPATIBILITY SameMajorVersion
)

# Use variables:
#   * TARGETS_EXPORT_NAME
#   * PROJECT_NAME
configure_package_config_file(
    "cmake/Config.cmake.in"
    "${project_config}"
    INSTALL_DESTINATION "${config_install_dir}"
)

install(
    TARGETS ${PROJECT_NAME}
    EXPORT "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION "lib"
    ARCHIVE DESTINATION "lib"
    RUNTIME DESTINATION "bin"
    INCLUDES DESTINATION "${include_install_dir}"
)

install(
    DIRECTORY include/
    DESTINATION "${include_install_dir}"
)

install(
    FILES "${project_config}" "${version_config}"
    DESTINATION "${config_install_dir}"
)

install(
    EXPORT "${TARGETS_EXPORT_NAME}"
    NAMESPACE "${namespace}"
    DESTINATION "${config_install_dir}"
)

install(FILES ${pc_config} DESTINATION lib/pkgconfig)
install(FILES ${la_config} DESTINATION lib)
