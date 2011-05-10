#!/bin/sh
# Copyright (c) 2011 The Open Source Geospatial Foundation.
# Licensed under the GNU LGPL.
# 
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License,
# or any later version.  This library is distributed in the hope that
# it will be useful, but WITHOUT ANY WARRANTY, without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details, either
# in the "LICENSE.LGPL.txt" file distributed with this software or at
# web page "http://www.fsf.org/licenses/lgpl.html".

# About:
# =====
# This script will install pycsw

# Running:
# =======
# sudo ./install_pycsw.sh

# Requires: Apache2, python-lxml, python-shapely and python-sqlalchemy
#
# Uninstall:
# ============
# sudo rm /etc/apache2/conf.d/pycsw
# sudo rm -rf /var/www/pycsw*

VERSION=0.2.0-dev

echo -n 'Installing pycsw $VERSION'

echo -n 'Installing dependencies ...'

# install dependencies
apt-get install apache2 python-lxml python-sqlalchemy python-shapely

# live disc's username is "user"
USER_NAME=user
USER_HOME=/home/$USER_NAME

WEB=/var/www

# package specific settings
PYCSW_HOME=$WEB/pycsw
PYCSW_TMP=/tmp/build_pycsw
PYCSW_APACHE_CONF=/etc/apache2/conf.d/pycsw

mkdir -p "$PYCSW_TMP"

echo -n 'Downloading package ...'

# Download pycsw LiveDVD tarball.
wget -N --progress=dot:mega "https://sourceforge.net/projects/pycsw/files/$VERSION/pycsw-$VERSION.tar.gz/download" \
     -O "$PYCSW_TMP/pycsw-$VERSION.tar.gz"

echo -n 'Extracting package ...'

# Uncompress pycsw LiveDVD tarball.
tar -zxvf "$PYCSW_TMP/pycsw-$VERSION.tar.gz" -C "$PYCSW_TMP"
mv "$PYCSW_TMP/pycsw-$VERSION" "$PYCSW_TMP/pycsw"
mv "$PYCSW_TMP/pycsw" $WEB

echo -n "Updating Apache configuration ..."
# Add pycsw apache configuration
cat << EOF > "$PYCSW_APACHE_CONF"

        <Directory $PYCSW_HOME>
	    Options FollowSymLinks +ExecCGI
	    Allow from all
	    AddHandler cgi-script .py
        </Directory>

EOF

echo -n "Generating configuration files ..."
# Add pycsw configuration files

cat << EOF > $PYCSW_HOME/default.cfg

[server]
home=/var/www/pycsw
url=http://localhost/pycsw/csw.py
mimetype=application/xml; charset=iso-8859-1
encoding=iso-8859-1
language=en-CA
maxrecords=10
#loglevel=DEBUG
#logfile=/tmp/pycsw.log
#ogc_schemas_base=http://foo
#federatedcatalogues=http://geodiscover.cgdi.ca/wes/serviceManagerCSW/csw
xml_pretty_print=true
#gzip_compresslevel=8
transactions=false
transactions_ips=127.0.0.1
#profiles=apiso

[metadata:main]
identification_title=pycsw Geospatial Catalogue
identification_abstract=pycsw is an OGC CSW server implementation written in Python
identification_keywords=catalogue,discovery
identification_fees=None
identification_accessconstraints=None
provider_name=pycsw
provider_url=http://pycsw.org/
contact_name=Kralidis, Tom
contact_position=Senior Systems Scientist
contact_address=TBA
contact_city=Toronto
contact_stateorprovince=Ontario
contact_postalcode=M9C 3Z9
contact_country=Canada
contact_phone=+01-416-xxx-xxxx
contact_fax=+01-416-xxx-xxxx
contact_email=tomkralidis@hotmail.com
contact_url=http://www.kralidis.ca/
contact_hours=0800h - 1600h EST
contact_instructions=During hours of service.  Off on weekends.
contact_role=pointOfContact

[repository:cite]
typename=csw:Record
enabled=true
database=sqlite:////var/www/pycsw/data/cite/dc.db

[repository:iso_records]
enabled=true
typename=gmd:MD_Metadata
database=sqlite:////var/www/pycsw/trunk/server/profiles/apiso/data/apiso.db

[metadata:inspire]
enabled=true
languages_supported=eng,gre
default_language=eng
date=2011-03-29
gemet_keywords=Utility and governmental services
conformity_service=notEvaluated
contact_name=National Technical University of Athens
contact_email=tzotsos@gmail.com
temp_extent=2011-02-01/2011-03-30

EOF

echo -n "Done\n"

#Add Launch icon to desktop
if [ ! -e /usr/share/applications/pycsw.desktop ] ; then
   cat << EOF > /usr/share/applications/pycsw.desktop
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=pycsw
Comment=pycsw catalog server
Categories=Application;Education;Geography;
Exec=firefox http://localhost/pycsw/tester/index.html
Icon=
Terminal=false
StartupNotify=false
Categories=Education;Geography;
EOF
fi
cp /usr/share/applications/pycsw.desktop "$USER_HOME/Desktop/"
chown "$USER_NAME:$USER_NAME" "$USER_HOME/Desktop/pycsw.desktop"

# Reload Apache
/etc/init.d/apache2 force-reload
