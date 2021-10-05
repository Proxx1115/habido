# habido_app

Habido app

## Getting Started

cd C:\Program Files\Java\jdk-16.0.1\bin
keytool -genkey -v -keystore C:/PROJECTS/Habido/habido_app/android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

habidopassword

C:\Program Files\Java\jdk-16.0.1\bin>keytool -genkey -v -keystore C:/PROJECTS/Habido/habido_app/android/app/upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
Enter keystore password:
Re-enter new password:
What is your first and last name?
  [Unknown]:  Habido
What is the name of your organizational unit?
  [Unknown]:  Habido
What is the name of your organization?
  [Unknown]:  Habido
What is the name of your City or Locality?
  [Unknown]:  Ulaanbaatar
What is the name of your State or Province?
  [Unknown]:  MN
What is the two-letter country code for this unit?
  [Unknown]:  MN
Is CN=Habido, OU=Habido, O=Habido, L=Ulaanbaatar, ST=MN, C=MN correct?
  [no]:  c
What is your first and last name?
  [Habido]:  Habido
What is the name of your organizational unit?
  [Habido]:  Optimal
What is the name of your organization?
  [Habido]:  Optimal
What is the name of your City or Locality?
  [Ulaanbaatar]:  Ulaanbaatar
What is the name of your State or Province?
  [MN]:  Ulaanbaatar
What is the two-letter country code for this unit?
  [MN]:  MN
Is CN=Habido, OU=Optimal, O=Optimal, L=Ulaanbaatar, ST=Ulaanbaatar, C=MN correct?
  [no]:  yes

Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10,000 days
        for: CN=Habido, OU=Optimal, O=Optimal, L=Ulaanbaatar, ST=Ulaanbaatar, C=MN
Enter key password for <upload>
        (RETURN if same as keystore password):
[Storing C:/PROJECTS/Habido/habido_app/android/app/upload-keystore.jks]

Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore C:/PROJECTS/Habido/habido_app/android/app/upload-keystore.jks -destkeystore C:/PROJECTS/Habido/habido_app/android/app/upload-keystore.jks -deststoretype pkcs12".