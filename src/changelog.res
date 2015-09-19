        ��  ��                  �$  0   ��
 C H A N G E L O G       0         ﻿Clearas
Ein Open-Source Projekt von PM Code Works

Changelog
=========

Version 4.2  [??.??.15]

- Autostart-Feature: Unterstützung von Windows 8
  - Änderungen an "Startup User" und "Common Startup" Einträgen
    - Kein Export mehr als .reg sondern als .Startup bzw. .CommonStartup
    - Keine automatischen Backups ("Backup beim Aktivieren löschen" entfernt)
- Neues Feature "Aufgaben":
  - Ermöglicht Bearbeiten von geplanten Aufgaben
  - "Einträge exportieren" speichert alle Aufgaben als ZIP-Datei
  - "Backup importieren" importiert eine zuvor exportierte Aufgabe als XML-Datei
  - "Expertenmodus" findet versteckte Aufgaben
- Änderungen am Popup Menü:
  - "Umbenennen" hinzugefügt
  - "Icon ändern" für Kontextmenü-Einträge vom Typ "Shell" hinzugefügt
- "In Explorer öffnen" verbessert
- Event-System verbessert
- Nutzung von generischen Container-Klassen (Generics)
- Menüeinträge werden nur noch deaktiviert (ausgegraut) anstatt versteckt

---------------------------------

Version 4.1  [27.08.15]

- Änderungen auf der Seite "Kontextmenü":
  - Kontextmenü-Einträge "ShellNew", die sich unter "Neu" befinden, werden nun gefunden
  - Falls Benutzer-definiertes Programm für Dateityp existiert, erscheint Meldung, nachdem neuer Eintrag hinzugefügt wurde
  - "Kontextmenü hinzufügen" verbessert:
    - Es können beliebige Datei-Typen bzw. Dateiendungen benutzt werden
    - Einträge können versteckt werden (nur durch Shift + Rechtsklick sichtbar)
  - Änderungen an der ProgressBar: 
    - wird nun während des Exportierens von Kontextmenü-Einträgen angezeigt
    - Benutzung ausschließlich als Ladeindikator
- ProgressBar zu Diensten hinzugefügt
- "Symbole anzeigen" im Menü unter Autostart entfernt
- Buttons zur "Quick-Search" hinzugefügt
- Listen können nun auf- und absteigend sortiert werden
- Bug fixes:
  - "Abbrechen" während des Hinzufügens von Einträgen funktioniert nun korrekt 
  - Nachdem schwerwiegener Fehler aufgetreten ist, können die Listen trotzdem aktualisiert werden
  - Nachdem neuer Dienst hinzugefügt wurde, wird der korrekte Pfad (mit Argumenten) angezeigt
- Icon erneuert: http://de.divinity.wikia.com/wiki/Datei:Icon_Besen.svg.png
- Nutzung von Windows spezifischen grafischen Features (ab Vista)
- Sprache wird benutzerspezifisch geladen
- Unterstützung von Unicode
- 32/64-Bit Binärdateien
- Updater v3.0 mit SSL-Unterstützung

---------------------------------

Version 4.0  [28.03.15]

- API Version 4.1
  - Multi-Threaded
  - Exception Handling stark verbessert
- Neues Feature "Dienste":
  - Ermöglicht Bearbeiten von Windows Diensten
- Nutzung des TaskDialogs (ab Vista)
- Änderungen im Popup Menü:
  - Neue Funktion "Pfad bearbeiten" hinzugefügt
    - Dateipfade sowie Parameter können nach eigenem Ermessen bearbeitet werden
  - Funktion "Nach Programm suchen" entfernt (durch "Pfad bearbeiten" ersetzt)
  - Neue Funktion "In RegEdit öffnen" hinzugefügt
    - Öffnet den Registry Pfad des aktuellen Elements in RegEdit
  - Neue Funktion "In Explorer öffnen"
    - Öffnet den Dateipfad des aktuellen Elements im Explorer
  - Neue Funktion "Ort kopieren"
    - Kopiert den Pfad des aktuellen Elements in die Zwischenablage
  - Funktion "Eigenschaften" entfernt (durch "Ort kopieren" ersetzt)
- Änderungen auf der Seite "Kontextmenü":
  - Menü:
    - Neue Funktion "Kontextmenü hinzufügen"
    - Neue Funktion "Einträge exportieren"
  - Beschriftungen von Shell-Eintägen werden nun direkt angezeigt
  - "Quick-Search" hinzugefügt
  - "Expertenmodus" verbessert:
    - Suche beschleunigt
    - Mehr Ergebnisse
- Änderungen auf der Seite "Autostart":
  - Menü-Eintrag "RunOnce-Einträge" durch Checkbox ersetzt
  - Menü-Eintrag "Symbole anzeigen" hinzugefügt
  - Icons von Programmen werden nun standardmäßig angezeigt
  - 32-Bit Einträge werden nun speziell gekennzeichnet (nur 64-Bit Windows)
- Auswählen von Elementen in Autostart und Kontextmenü Listen beschleunigt
- "Backup importieren" verbessert
- Registry Dateiexport verbessert (eigener Parser)
- Bug Fixes: 
  - Gelöschte Autostart Elemente werden nun korrekt aus Liste gelöscht
  - RunOnce Einträge werden nun auch in 32-Bit Schlüsseln ausgelesen (nur 64-Bit Windows)
- Neues Manifest
- Updater v2.2
- OSUtils v2.1
- Open-Source

---------------------------------

Version 3.0  [03.10.13]

- API Version 4
- Bei "Programm hinzufügen" können Parameter angegeben werden
- "RunOnce"-Einträge können ausgelesen werden
- "Personal Edition" eingestellt

---------------------------------

Version 2.1.2  [07.03.13]

- Änderungen im Fenstermanagement
- Seltener Fehler bei doppelten Autostarteinträgen behoben
- sonstige kleine Bug Fixes

---------------------------------

Version 2.1.1  [29.12.12]

- Update-Funktion verbessert
- Batchdateien können nun auch in den Autostart geladen werden
  - Änderung des Anzeigenamens möglich
- Fehler mit doppelten Kontextmenü-Einträgen behoben
- Mutex hinzugefügt
- wenige GUI Änderungen

---------------------------------

Version 2.1 (Clearas NT Release)  [22.11.12]

- Clearas NT: API Version 3 und nochmals überarbeiteter Source-Code
  - verbesserte Speichernutzung
- Kontextmenü-Einträge können ausgelesen und (wie bei den Autostart-Objekten) bearbeitet werden
  - Expertenmodus für verfeinerte Suche nach Einträgen verfügbar
- Sprachunterstützung für "Französisch" hinzugefügt (Danke an Angela Hansen)
- "nach Programm suchen"-Feature überarbeitet
  - User kann Pfad selbst bearbeiten
    - "Pfad bearbeiten"-Eintrag im Kontextmenü hinzugefügt
- es können keine Programme mehr doppelt in den Autostart gelangen
- Reiter "Hilfe" erweitert:
  - automatische und manuelle Update-Funktion verfügbar
  - "PM Code Works" Zertifikat kann installiert werden
  - alternative "Personal Edition" kann heruntergeladen werden
- Support für Windows 8 sowie 2000
- Manifest-Skript überarbeitet
- kleinere Bug fixes, die überwiegend x64 Systeme betreffen

---------------------------------

Version 2.0 (Clearas Beta Final Release)  [08.02.11]

- Clearas Beta: Source-Code komplett überarbeitet und größtenteils neu geschrieben
  - Clearas benötigt noch weniger Resourcen
  - verbesserte Fehlererkennung
- Sprachunterstützung für "Englisch" hinzugefügt (Danke an Angela Hansen)
- Main Menu um Reiter "Datei" erweitert
  - Export der kompletten Liste als *.txt und *.reg möglich
  - es können beliebige Programme manuell in den Autostart geladen werden
  - Import von vorhandenen Backups (*.Startup-Dateien) möglich
- Falls ein Programm-Pfad fehlt, kann danach gesucht werden
- von aktivierten Programmen im Autostartordner können manuell Backups
    gemacht werden
  - Beim Löschvorgang wird gefragt, ob Backup (falls vorhanden) auch gelöscht
    werden soll
  - autom. Löschen von Backups nach Aktivierung kann geändert werden
- Deaktivierungsdatum kann angezeigt werden
- "Service-Pack anzeigen" kann geändert werden
- jede Menge Bugfixes

---------------------------------

Version 1.2.21  [09.11.11]

- volle Abwärtskompatibilität für Windows XP
- Main Menu um Reiter "Bearbeiten" und "Hilfe" erweitert
  - unter "Bearbeiten" kann ein Verknüpfung zu Clearas im Papierkorb Kontextmenü eingetragen werden
- Beim deaktivieren von Programmen aus dem Autostart-Ordner wird eine Backup *.lnk unter "%WinDir%\pss" erzeugt
- Anzeige des Betriebssystems einschließlich Service Pack
- jede Menge Bugfixes

---------------------------------

Version 1.2.2  [15.10.11]

- volle Kompatibilität für Windows 7 und Vista (jeweils 32 oder 64bit)
- Größe des Forms anpassbar
- Bugfixes

---------------------------------

Version 1.2.1  [07.10.11]

- "Main Menu" eingefügt
- Funktion "Eigenschaften" zum Popup Menü hinzugefügt
  - anzeigen des Registrierungsschlüssels möglich
- Anzeige des Betriebssystems
- neuer Dialogtyp

---------------------------------

Version 1.2  [05.10.11]

- Export von REG-Dateien ("*.reg") möglich
- Popup Menü hinzugefügt
- Hotkey-Funktion hinzugefügt
  - "Entf" = selektierten Eintrag löschen
  - "Strg+C" = selektierten Eintrag exportieren
  - "F5" = aktualisieren
  - "F6" = Standard Spaltengröße
  - "F7" = Spaltengröße optimieren 
- "Speichern-Dialog" vor löschen eingefügt
- Sortierfunktion hinzugefügt
- Layout geändert
  - größeres Form
  - größere Buttons
- Bugfixes

---------------------------------

Version 1.1  [03.10.11]

- verfeinerte Suche nach Autostart-Programmen ("Startup User")
- Manifest eingebunden 
  --> wird nun mit Admin-Rechten ausgeführt
- Bugfixes
- neuer Icon

---------------------------------

Version 1.0  [13.04.11]

Erste Version von Clearas.

Features:

- aktivieren, 
- deaktivieren und
- löschen von Autostart-Objekten

-------------------------------------------------------------------------------------------------
Clearas wurde unter der D-FSL-Lizenz veröffentlicht und ist somit Open-Source. Der Quelltext kann auf der Website heruntergeladen werden.

Soll Clearas auf eine kommerzielle CD-ROM (mit Magazin) gepresst werden, wäre es nett, mir eine Ausgabe dieser CD-ROM (mit Magazin) zu schicken. Meine Adresse erfahren Sie unter team@pm-codeworks.de.
 