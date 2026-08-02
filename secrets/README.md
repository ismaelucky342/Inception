# secrets/

Esta carpeta está en `.gitignore` y nunca se commitea. Antes de `make`,
creamos estos 5 ficheros de texto plano (una línea, sin saltos extra):

| Fichero                       | Contenido                                          |
|--------------------------------|-----------------------------------------------------|
| `db_password.txt`              | password del usuario MySQL de WordPress             |
| `db_root_password.txt`         | password de root de MariaDB                         |
| `credentials.txt`              | 2 líneas: usuario admin de WP, luego password admin |
| `wp_user_password.txt`         | password del segundo usuario WP (subscriber)        |
| `ftp_password.txt`             | password del usuario `ftpuser`                      |
| `grafana_admin_password.txt`   | password del admin de Grafana                       |


rapido: 

```bash
echo "S3cur3DB_@2026"        > db_password.txt
echo "R00t_M4r1aDB_@2026"    > db_root_password.txt
printf "admin\nAdm1nWP_@2026\n" > credentials.txt
echo "Subscr1b3r_2026"      > wp_user_password.txt
echo "Ftp_Us3r_@2026"       > ftp_password.txt
echo "Graf4na_@2026"         > grafana_admin_password.txt
```
