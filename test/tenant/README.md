# Tentant administration test
```
docker-compose up -d
# Wait for everything to come up
docker-compose exec ftp /opt/hotel/bin/new-tenant.sh someusername /var/hotel/home/someusername
# Take note of the generated uses password
docker-compose exec ftp ftp localhost
# You should now be able to login with the new users password
```
