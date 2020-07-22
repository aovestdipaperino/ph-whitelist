!/bin/bash
#####ADAPTED FROM https://github.com/dMopp/pihole5-adlist-update-cron by
#####Include and trim only lines which start with 'https://' to allow comments, MD format, etc.
#####Point to the proper list from Gioxx

#####CHANGE STUFF HERE
PIHOLE_DIR="/etc/pihole"
ADLIST_URL="https://raw.githubusercontent.com/gioxx/ph-whitelist/master/domains/blocklists.md"
CLEAN_ADLISTS_BEFORE_UPDATE=true


#####DO NOT CHANGE
#####Variables
DATE=$(date '+%Y-%m-%d')
ADLIST="${PIHOLE_DIR}/adlists.list"
FLUSH_SQL="${PIHOLE_DIR}/FLUSH.sql"
IMPORT_SQL="${PIHOLE_DIR}/IMPORT.sql"
GRAVITY_DB="${PIHOLE_DIR}/gravity.db"


#####Fetch Files
echo "Downloading Adlist(s)"
wget -O ${ADLIST} ${ADLIST_URL}

#####GENERATE SQL
echo "Generating SQL files..."
cat <<EOF > ${FLUSH_SQL}
DELETE FROM adlist;
EOF

cat <<EOF > ${IMPORT_SQL}
CREATE TEMP TABLE i(txt);
.separator ~
.import ${ADLIST} i
INSERT OR IGNORE INTO adlist (address) SELECT TRIM(txt) FROM i WHERE txt LIKE 'https://%';
DROP TABLE i;
EOF

#####CLEANUP DB (if selected)
if ${CLEAN_ADLISTS_BEFORE_UPDATE}; then
	echo "Cleanup DB..."
	sqlite3 ${GRAVITY_DB} < ${FLUSH_SQL}
fi

#####IMPORT FILE to DB
echo "Import Adlist(s)..."
sqlite3 ${GRAVITY_DB} < ${IMPORT_SQL}
pihole -g

###CLEANUP
echo "Cleaning up..."
rm ${ADLIST}
rm ${FLUSH_SQL}
rm ${IMPORT_SQL}
