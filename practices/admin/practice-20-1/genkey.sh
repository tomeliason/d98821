
# ------------------------------------------------------------------------
# -- DISCLAIMER:
# --    This script is provided for educational purposes only. It is NOT
# --    supported by Oracle World Wide Technical Support.
# --    The script has been tested and appears to work as intended.
# --    You should always run new scripts on a test instance initially.
# --
# ------------------------------------------------------------------------


keytool -genkey -v -alias wlskey -keyalg RSA -keysize 2048 -sigalg MD5withRSA -dname "CN=wls-sysadm" -keypass wlskeypass -validity 365 -keystore wls_identity.jks -storepass wlsstorepass
