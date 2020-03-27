# Sådan virker hotellet

## traefik
Traefik lytter på port 80 og 443 og sender videre til individuelle apache instanser baseret på URL. Den står også for at kryptere til https med certifikater fra letsencrypt.

## MySQL
Bruges som DB til at indeholde opsætning af brugere til proFTPd, dvs. proFTPd bruger ikke unix-brugere. Desuden kan hvert værelse i hotellet have sin egen DB. Brugernavn og PW til den database står i en anden MySQL tabel (NKJ?).

## FTP
Brugere kan up- og downloade filer via FTP. proFTPd skriver filer med samme uid og gid uanset bruger. Hver bruger bliver chroot'ed til et bibliotek i træet.

## Apache
kører i form af Docker images. Hvert docker image startes chroot'ed til et bibliotek. Apache starter op som root i containeren. Den tager port 80 og smider sine rettigheder. Herefter kører alle worker-threads med samme uid og gid.
Apache kontakter MySQL ...(NKJ?) 
Unix-root har ikke socket adgang, men bruger et user-id og password, der står i en fil som kun Unix-root kan læse. Den fil læser Debian ved nedlukning af Apache f.eks. ved opdateringer.

## Docker
konfigurationen ligger i /opt/hotel/cong/apache2.conf

## Docker compose
docker-compose [definerer og kører Docker applikationer:] (https://docs.docker.com/compose/overview/)
Scriptet /opt/hotel/bin/compose.sh kalder docker-compose.

Eksempel: Start pilt.dk med kommandoen:
`root@mysa:/opt/hotel/bin# ./compose.sh ../conf/sites-enabled/pilt.dk.yml up -d`

Første parameter er en .yml fil, så en kommando og til sidst "resten" af options, her "-d" som betyder (NKJ?)
I praksis er .yml filen et softlink til filen med samme navn i /sites-available. Linket laves sådan:

cd /opt/hotel/conf
sudo ls -s sites-available/pilt.dk.yml sites-enabled/

Det ender med 
`docker-compose -f /opt/hotel/conf/default.yml -f /opt/hotel/conf/sites-enabled/pilt.dk.yml -p /opt/hotel/conf/sites-enabled/pilt.dk up -d`
Det betyder at følgende sker:
(NKJ?)

# Opstart

## Opstart af eet hotelværelse
Start pilt.dk med kommandoen:

`root@mysa:/opt/hotel/bin# ./compose.sh ../conf/sites-enabled/pilt.dk.yml up -d`

Hotellets run-status er nu administreret af systemd, så en bedre måde at starte et værelse på er:

`# systemctl start hotel-pilt.dk`


## Opstart af hele hotellet
Man kan starte alle sites på hotellet med:

`# systemctl start hotel.target`

## Se logs for et enkelt hotelværelse

`# journalctl -u hotel-pilt.dk`

# Dashboard
https://mysa.dds.dk/dashboard/#/
(NKJ?)
