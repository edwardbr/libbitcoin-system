hunter_config(Boost VERSION 1.70.0-p0)

hunter_config(secp256k1
    URL https://github.com/edwardbr/secp256k1/archive/master.tar.gz
    SHA1 7229336a56a3d0171cc6c6055bf4f0635435e0cb
    CMAKE_ARGS 
        CONFIG_MACRO_U_USING_ICU_NAMESPACE=1
        CONFIG_MACRO_U_DISABLE_RENAMING=0)


hunter_config(
    ICU
    VERSION 55.1-p4
    CMAKE_ARGS 
        U_USING_ICU_NAMESPACE=1
        U_DISABLE_RENAMING=0
)