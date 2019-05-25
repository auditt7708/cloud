# Linux Cert Management

* Debian/Ubuntu: sudo apt-get install libnss3-tools

* Fedora: su -c "yum install nss-tools"

* Gentoo: su -c "echo 'dev-libs/nss utils' >> /etc/portage/package.use && emerge dev-libs/nss" (You need to launch all commands below with the nss prefix, e.g., nsscertutil.)

* Opensuse: sudo zypper install mozilla-nss-tools

## List all certificates

`certutil -d sql:$HOME/.pki/nssdb -L`

## List details of a certificate

`certutil -d sql:$HOME/.pki/nssdb -L -n <certificate nickname>`

## Add a certificate

```sh
certutil -d sql:$HOME/.pki/nssdb -A -t <TRUSTARGS> -n <certificate nickname> \
-i <certificate filename>
```

### Sources

* https://raymii.org/s/tutorials/Strong_SSL_Security_On_Apache2.html
* https://raymii.org/s/tutorials/Pass_the_SSL_Labs_Test_on_Apache2_(Mitigate_the_CRIME_and_BEAST_attack_-_Disable_SSLv2_-_Enable_PFS).html
* https://raymii.org/s/tutorials/Pass_the_SSL_Labs_Test_on_NGINX_(Mitigate_the_CRIME_and_BEAST_attack_-_Disable_SSLv2_-_Enable_PFS).html
* https://raymii.org/s/tutorials/haproxy_client_side_ssl_certificates.html
* https://chromium.googlesource.com/chromium/src/+/master/docs/linux_cert_management.md