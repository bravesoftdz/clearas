        ��  ��                  z  0   ��
 C H A N G E L O G       0         Clearas
Ein Open-Source Projekt von PM Code Works

Changelog
---------

Version 4.1  [??.06.15]

- ProgressBar wird nun w�hrend des Exportierens von Kontextmn�-Eintr�gen angezeigt
- "Abbrechen" w�hrend des Hinzuf�gens von Eintr�gen funktioniert nun korrekt
- "Symbole anzeigen" entfernt
- Sprache wird benutzerspezifisch geladen
- Unterst�tzung von Unicode
- 32/64-Bit Bin�rdateien
- Updater v2.3

---------------------------------

Version 4.0  [28.03.15]

- API Version 4.1
  - Multi-Threaded
  - Exception Handling stark verbessert
- Neues Feature "Dienste":
  - Erm�glicht Bearbeiten von Windows Diensten
- Nutzung des TaskDialogs (ab Vista)
- �nderungen im Popup Men�:
  - Neue Funktion "Pfad bearbeiten" hinzugef�gt
    - Dateipfade sowie Parameter k�nnen nach eigenem Ermessen bearbeitet werden
  - Funktion "Nach Programm suchen" entfernt (durch "Pfad bearbeiten" ersetzt)
  - Neue Funktion "In RegEdit �ffnen" hinzugef�gt
    - �ffnet den Registry Pfad des aktuellen Elements in RegEdit
  - Neue Funktion "In Explorer �ffnen"
    - �ffnet den Dateipfad des aktuellen Elements im Explorer
  - Neue Funktion "Ort kopieren"
    - Kopiert den Pfad des aktuellen Elements in die Zwischenablage
  - Funktion "Eigenschaften" entfernt (durch "Ort kopieren" ersetzt)
- �nderungen auf der Seite "Kontextmen�":
  - Men�:
    - Neue Funktion "Kontextmen� hinzuf�gen"
    - Neue Funktion "Eintr�ge exportieren"
  - Beschriftungen von Shell-Eint�gen werden nun direkt angezeigt
  - "Quick-Search" hinzugef�gt
  - "Expertenmodus" verbessert:
    - Suche beschleunigt
    - Mehr Ergebnisse
- �nderungen auf der Seite "Autostart":
  - Men�-Eintrag "RunOnce-Eintr�ge" durch Checkbox ersetzt
  - Men�-Eintrag "Symbole anzeigen" hinzugef�gt
  - Icons von Programmen werden nun standardm��ig angezeigt
  - 32 Bit Eintr�ge werden nun speziell gekennzeichnet (nur 64 Bit Windows)
- Ausw�hlen von Elementen in Autostart und Kontextmen� Listen beschleunigt
- "Backup importieren" verbessert
- Registry Dateiexport verbessert (eigener Parser)
- Bug Fixes: 
  - Gel�schte Autostart Elemente werden nun korrekt aus Liste gel�scht
  - RunOnce Eintr�ge werden nun auch in 32 Bit Schl�sseln ausgelesen (nur 64 Bit Windows)
- Neues Manifest
- Updater v2.2
- OSUtils v2.1
- Open-Source

---------------------------------

Version 3.0  [03.10.13]

- API Version 4
- Bei "Programm hinzuf�gen" k�nnen Parameter angegeben werden
- "RunOnce"-Eintr�ge k�nnen ausgelesen werden
- "Personal Edition" eingestellt

---------------------------------

Version 2.1.2  [07.03.13]

- �nderungen im Fenstermanagement
- Seltener Fehler bei doppelten Autostarteintr�gen behoben
- sonstige kleine Bug Fixes

---------------------------------

Version 2.1.1  [29.12.12]

- Update-Funktion verbessert
- Batchdateien k�nnen nun auch in den Autostart geladen werden
  - �nderung des Anzeigenamens m�glich
- Fehler mit doppelten Kontextmen�-Eintr�gen behoben
- Mutex hinzugef�gt
- wenige GUI �nderungen

---------------------------------

Version 2.1 (Clearas NT Release)  [22.11.12]

- Clearas NT: API Version 3 und nochmals �berarbeiteter Source-Code
  - verbesserte Speichernutzung
- Kontextmen�-Eintr�ge k�nnen ausgelesen und (wie bei den Autostart-Objekten) bearbeitet werden
  - Expertenmodus f�r verfeinerte Suche nach Eintr�gen verf�gbar
- Sprachunterst�tzung f�r "Franz�sisch" hinzugef�gt (Danke an Angela Hansen)
- "nach Programm suchen"-Feature �berarbeitet
  - User kann Pfad selbst bearbeiten
    - "Pfad bearbeiten"-Eintrag im Kontextmen� hinzugef�gt
- es k�nnen keine Programme mehr doppelt in den Autostart gelangen
- Reiter "Hilfe" erweitert:
  - automatische und manuelle Update-Funktion verf�gbar
  - "PM Code Works" Zertifikat kann installiert werden
  - alternative "Personal Edition" kann heruntergeladen werden
- Support f�r Windows 8 sowie 2000
- Manifest-Skript �berarbeitet
- kleinere Bug fixes, die �berwiegend x64 Systeme betreffen

---------------------------------

Version 2.0 (Clearas Beta Final Release)  [08.02.11]

- Clearas Beta: Source-Code komplett �berarbeitet und gr��tenteils neu geschrieben
  - Clearas ben�tigt noch weniger Resourcen
  - verbesserte Fehlererkennung
- Sprachunterst�tzung f�r "Englisch" hinzugef�gt (Danke an Angela Hansen)
- Main Menu um Reiter "Datei" erweitert
  - Export der kompletten Liste als *.txt und *.reg m�glich
  - es k�nnen beliebige Programme manuell in den Autostart geladen werden
  - Import von vorhandenen Backups (*.Startup-Dateien) m�glich
- Falls ein Programm-Pfad fehlt, kann danach gesucht werden
- von aktivierten Programmen im Autostartordner k�nnen manuell Backups
    gemacht werden
  - Beim L�schvorgang wird gefragt, ob Backup (falls vorhanden) auch gel�scht
    werden soll
  - autom. L�schen von Backups nach Aktivierung kann ge�ndert werden
- Deaktivierungsdatum kann angezeigt werden
- "Service-Pack anzeigen" kann ge�ndert werden
- jede Menge Bugfixes

---------------------------------

Version 1.2.21  [09.11.11]

- volle Abw�rtskompatibilit�t f�r Windows XP
- Main Menu um Reiter "Bearbeiten" und "Hilfe" erweitert
  - unter "Bearbeiten" kann ein Verkn�pfung zu Clearas im Papierkorb Kontextmen� eingetragen werden
- Beim deaktivieren von Programmen aus dem Autostart-Ordner wird eine Backup *.lnk unter "%WinDir%\pss" erzeugt
- Anzeige des Betriebssystems einschlie�lich Service Pack
- jede Menge Bugfixes

---------------------------------

Version 1.2.2  [15.10.11]

- volle Kompatibilit�t f�r Windows 7 und Vista (jeweils 32 oder 64bit)
- Gr��e des Forms anpassbar
- Bugfixes

---------------------------------

Version 1.2.1  [07.10.11]

- "Main Menu" eingef�gt
- Funktion "Eigenschaften" zum Popup Men� hinzugef�gt
  - anzeigen des Registrierungsschl�ssels m�glich
- Anzeige des Betriebssystems
- neuer Dialogtyp

---------------------------------

Version 1.2  [05.10.11]

- Export von REG-Dateien ("*.reg") m�glich
- Popup Men� hinzugef�gt
- Hotkey-Funktion hinzugef�gt
  - "Entf" = selektierten Eintrag l�schen
  - "Strg+C" = selektierten Eintrag exportieren
  - "F5" = aktualisieren
  - "F6" = Standard Spaltengr��e
  - "F7" = Spaltengr��e optimieren 
- "Speichern-Dialog" vor l�schen eingef�gt
- Sortierfunktion hinzugef�gt
- Layout ge�ndert
  - gr��eres Form
  - gr��ere Buttons
- Bugfixes

---------------------------------

Version 1.1  [03.10.11]

- verfeinerte Suche nach Autostart-Programmen ("Startup User")
- Manifest eingebunden 
  --> wird nun mit Admin-Rechten ausgef�hrt
- Bugfixes
- neuer Icon

---------------------------------

Version 1.0  [13.04.11]

Erste Version von Clearas.

Features:

- aktivieren, 
- deaktivieren und
- l�schen von Autostart-Objekten

-------------------------------------------------------------------------------------------------
Clearas wurde unter der D-FSL-Lizenz ver�ffentlicht und ist somit Open-Source. Der Quelltext kann auf der Website heruntergeladen werden.

Soll Clearas auf eine kommerzielle CD-ROM (mit Magazin) gepresst werden, w�re es nett, mir eine Ausgabe dieser CD-ROM (mit Magazin) zu schicken. Meine Adresse erfahren Sie unter team@pm-codeworks.de.

06/2015
  