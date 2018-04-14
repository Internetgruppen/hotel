
# Sådan virker hotellet

## traefik

Traefik lytter på port 80 og 443 og sender videre til individuelle apache instanser baseret på URL. Den står også for at kryptere til https med certifikater fra letsincrypt.

## MySQL

Bruges som DB til at indeholde opsætning af brugere til proFTPd. Desuden kan hvert værelse i hotellet have sin egen DB. Brugernavn og PW står i en MySQL tabel (NKJ?)

## FTP
Brugere kan up- og downloade filer via FTP. proFTPd skriver med samme uid og gid uanset bruger. Hver bruger bliver chroot'ed til et bibliotek i træet.

## Apache
kører i form af Docker images. Dvs. alle apache instanser er ens, kører med samme uid og gid og er chroot'ed til hver sit bibliotek i træet. Apache opdateringer sker ved at bygge et nyt Docker image.

## Docker
konfigurationen ligger i /opt/hotel/cong/apache2.conf

## Docker compose
docker-compose [definerer og kører Docker applikationer:] (https://docs.docker.com/compose/overview/)
Scriptet /opt/hotel/bin/compose.sh kalder docker-compose.

Eksempel: Start pilt.dk med kommandoen:
`root@mysa:/opt/hotel/bin# ./compose.sh ../conf/sites-enabled/pilt.dk.yml up -d`

Første parameter er en .yml fil, så en kommando og til sidst "resten" af options, her "-d" som betyder (NKJ?)

Det ender med 
`docker-compose -f /opt/hotel/conf/default.yml -f /opt/hotel/conf/sites-enabled/pilt.dk.yml -p /opt/hotel/conf/sites-enabled/pilt.dk up -d`

# Opstart

## Opstart af eet hotelværelse
Startede pilt.dk med kommandoen:

`root@mysa:/opt/hotel/bin# ./compose.sh ../conf/sites-enabled/pilt.dk.yml up -d`

## Opstart af hele hotellet
Man kan starte alle sites på hotellet med:

`root@mysa:/opt/hotel/bin# ./hotel.sh up`

... Forestiller mig at sidstnævnte skal i et init-script på mysa på et tidspunkt


# Dashboard
https://mysa.dds.dk/dashboard/#/
