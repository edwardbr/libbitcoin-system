hunter_config(Boost VERSION 1.70.0-p0)

hunter_config(secp256k1
    URL https://github.com/edwardbr/secp256k1/archive/master.tar.gz
    SHA1 c630cef1a69e1b8e79a121e7a3e2ba7c636bdd03
    CMAKE_ARGS 
        CONFIG_MACRO_U_USING_ICU_NAMESPACE=1
        CONFIG_MACRO_U_DISABLE_RENAMING=0
		SECP256K1_BUILD_TEST=off
		SECP256K1_ENABLE_MODULE_RECOVERY=on
		SECP256K1_ENABLE_MODULE_SCHNORR=off)


hunter_config(
    ICU
    VERSION 55.1-p4
    CMAKE_ARGS 
        U_USING_ICU_NAMESPACE=1
        U_DISABLE_RENAMING=0
)