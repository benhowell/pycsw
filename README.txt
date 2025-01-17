pycsw README
============

pycsw is an OGC CSW server implementation written in Python.

pycsw fully implements the OpenGIS Catalogue Service Implementation Specification [Catalogue Service for the Web]. Initial development started in 2010 (more formally announced in 2011). The project is certified OGC Compliant, and is an OGC Reference Implementation.

pycsw allows for the publishing and discovery of geospatial metadata. Existing repositories of geospatial metadata can also be exposed via OGC:CSW 2.0.2, providing a standards-based metadata and catalogue component of spatial data infrastructures.

pycsw is Open Source, released under an MIT license, and runs on all major platforms (Windows, Linux, Mac OS X).

Please read the docs at http://pycsw.org/docs for more information.


This forked version was modified for use by SPC Geoscience Division and acts as csw cataloge service for GeoNode. 
Changes to this fork includes the following:
 * Bug fix: pycsw-admin export_records now reads schema (mappings) from config file passed in as a command parameter rather than the default config.
 * Bug fix: pycsw-admin export_records now uses schema mapping to determine xml column (previously hardcoded as record.xml)
 * New functionality to export records table to a single csv file.