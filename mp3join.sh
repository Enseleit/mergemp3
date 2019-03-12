#!/bin/bash
#			+---------------------------------------------------------------------------+
#			|			oip.sh															|
#			+---------------------------------------------------------------------------+
#			|	Description																|
#			|	Dieses sehr einfache Script zum Zusammenfuehren mehrerer MP3-Dateien in	|
#			|	eine einzige benötigt die Pakete "libav-tools" und "id3-tools"			|
#			|	Unter Ubuntu kann man diese wie folgt nachinstallieren:					|
#			|	sudo apt-get install libav-tools id3-tools 								|
#			+---------------+-----------------------------------------------------------+
#			|	Date		|	Discription												|
#			+---------------+-----------------------------------------------------------+
#			|	12.03.2019	|	Version 0.1												|
#			|				|															|
#			+---------------+-----------------------------------------------------------+
#
#set -x         																		# debug or not!
# 
#########################################################################################
# Quelldateien werden ausgewaehlt und in die Variable QUELLE geschrieben
#########################################################################################
QUELLE=$(zenity --file-selection --text "mp3join -- Welche Dateien sollen verknüpft werden?" --title "mp3join -- Quelldateien auswählen" --multiple);
#
# Hat der User wirklich Dateien angegeben?
if [[ -z $QUELLE ]]; then
	echo "Nichts ausgewaehlt... breche ab..."
	exit 1;
fi
DATEI=$(echo $QUELLE | cut -d"|" -f1)
FDIR=$(dirname "$DATEI")
FNAME=$(basename "$DATEI")
Z=$FDIR/komplet.mp3
TIME=1

echo $DATEI
echo $FDIR
echo $FNAME

$ZIEL=$(zenity --entry --text "Bitte den Namen und vollständigen Pfad der Zieldatei angeben" --entry-text "$Z");
sleep $TIME 
#########################################################################################
# Der Separator (ist hier standardmaessig "|") wird in IFS gespeichert
#########################################################################################
IFS="|"
#########################################################################################
#Start des Dialogs
#########################################################################################
(
	echo "10"																			# check, ob /tmp/tmp.mp3 existiert, wenn ja, dann loesche sie...
	echo "# Vorbereitung..."
	sleep $TIME
	if [ -f /tmp/tmp.mp3 ]; then
		rm /tmp/tmp.mp3
	fi
	touch /tmp/tmp.mp3																	# Hilfsdatei wird angelegt.
	echo "30"
	echo "# Erzeuge neue Datei..."
	sleep $TIME
	for arg in ${QUELLE}																# Alle Dateien per cat miteinander verbinden
		do echo "${arg}"
		cat /tmp/tmp.mp3 "${arg}" > /tmp/tmp2.mp3
		rm /tmp/tmp.mp3
		mv /tmp/tmp2.mp3 /tmp/tmp.mp3
	done
	echo "60"
	echo "# Repariere Datei-Header..."
	sleep $TIME
	avconv -i /tmp/tmp.mp3 -acodec copy ${ZIEL} 										# repariere Datei-Header und speichere das Endergebnis nach
	echo "#ACHTUNG: '${ZIEL}' erstellt."
	echo "90"
	echo "# Räume auf..."
	sleep $TIME
	rm /tmp/tmp.mp3																		# loesche Hilfsdatei
	if [ -f "${ZIEL}" ]; then
		echo "100"
		echo "# Fertig!"
	else
		echo "99"
		echo "# Keine Schreibberechtigung! Datei konnte nicht angelegt werden!"
	fi
)|zenity --progress --text="Vorgang wird bearbeitet" --percentage=0
exit 0;