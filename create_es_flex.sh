./es_build_flex_sql.sh >flex_es.sql
vsql -U dbadmin -w dbadmin -f flex_es.sql
