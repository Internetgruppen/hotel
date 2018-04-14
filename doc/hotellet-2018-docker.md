
# Sådan virker hotellet

## traefik

Traefik lytter på port 80 og 443 og sender videre til individuelle apache instanser baseret på URL. Den står også for at kryptere til https med certifikater fra letsincrypt.

## MySQL

Bruges som DB til at indeholde opsætning af brugere til proFTPd. Desuden kan hvert værelse i hotellet have sin egen DB. Brugernavn og PW står i en MySQL tabel (NKJ?).

## FTP
Brugere kan up- og downloade filer via FTP. proFTPd skriver med samme uid og gid uanset bruger. Hver bruger bliver chroot'ed til et bibliotek i træet.

## Apache
kører i form af Docker images. Apache starter op som root i containeren. Den tager port 80 og smider sine rettigheder. Apache kører chroot'ed til sit eget bibliotek. Herefter kører alle worker-threads med samme uid og gid.
Apache kontakter MySQL på en måde, der gør det umuligt for een apache instans at få adgang til andre databaser: Apache-root har ikke socket adgang, men bruger et user-id og password, der står i en fil som kun Unix-root kan læse. Den fil læser Debian ved nedlukning af Apache f.eks. ved opdateringer.

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
