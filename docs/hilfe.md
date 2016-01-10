# jxUpdate Anleitung

## Einleitung

jxUpdate erlaubt die Aktualisierung beliebig vieler, vorhandener Artikel eines Shops auf einmal durch Importieren von CSV Dateien.

## Funktionsweise
Eine CSV Datei besteht in der Regel aus mehreren Spalten und Zeilen, vergleichbar mit einer Excel Tabelle.

Die erste Spalte enthält den Identifikationswert, also den Text/Wert mit dem ein Artikel identifiziert werden kann. Die nachfolgenden Spalten enthalten die Aktualisierungsdaten. Die Datei kann mehrere Aktualisierungsspalten enthalten.

Die erste Zeile der CSV Datei enthält die Festlegung der Datenbankfelder, die aktualisiert werden sollen. Die restlichen Zeilen enthalten die eigentlichen Aktualisierungsdaten.

## Beispiele

#### Import-Datei für eine einfache Deaktivierung
    oxartnum
    3503
    1302
    400-03
  
#### Import-Datei für Aktualisierung der EANs
    oxartnum,oxean
    3503,4010281030821
    3504,3057640349263
    400-01,5449000017888
  
#### Import-Datei für Aktualisierung des EK- und VK-Preis
    oxartnum;oxbprice;oxprice
    3503;15.5;29.75
    3504;12.5;24.75
    400-01;3.5;7.75
  
#### Import-Datei für Aktualisierung der EK-Preise mit Text-Begrenzungszeichen
    "oxartnum","oxbprice"
    "3503","15.5"
    "3504","12.5"
    "400-01","3.5"

## Mögliche Datenbankfelder

Für die Aktualisierung können folgende Datenbankfelder verwendet werden

* **OXACTIVE** - Aktiv/Inaktiv  
0 = Deaktiviert  
1 = Aktiviert
* **OXEAN** - EAN-Nummer
* **OXDISTEAN** - Hersteller EAN-Nummer
* **OXPRICE** - Verkaufspreis
* **OXBPRICE** - Einkaufspreis
* **OXTPRICE** - UVP Preis
* **OXSTOCK** - Lagerbestand
* **OXSTOCKFLAG** - Lieferstatus  
1 = Standard  
2 = Wenn ausverkauft offline  
3 = Wenn ausverkauft nicht bestellbar  
4 = Fremdlager
* **OXDELIVERY** - Wieder lieferbar am (im Format _YYYY-MM-DD_)
* **OXMINDELTIME** - Minimale Lieferzeit
* **OXMAXDELTIME** - Maximale Lieferzeit
* **OXDELTIMEUNIT** - Einheit der Lieferzeit  
DAY = Tage  
WEEK = Wochen  
MONTH = Monate
* **OXREMINDACTIVE** - Erinnerungsmail, falls Lagerbestand unter _OXREMINDAMOUNT_ sinkt
* **OXREMINDAMOUNT** - Grenzwert für Erinnerungsmail
* **OXSTOCKTEXT_ _n_** - Info falls Artikel auf Lager, für Sprache Nr. _n_ 
* **OXNOSTOCKTEXT_ _n_** - Info falls Artikel nicht auf Lager, für Sprache Nr. _n_ 

## Einstellungen

Die Art der Aktualisierung der Artikel und des Datenimports kann im Shop Admin unter _Erweiterungen_ - _Module_ - _jxUpdate_ - _Einstell._ eingestellt werden.  
![Einstellungen](https://github.com/job963/jxUpdate/raw/master/docs/img/settings-de.png)

#### Spalten-Trennzeichen
Die Datenfelder / Spalten der CSV-Datei können durch drei verschiedene Zeichen  (Komma, Semikolon oder Tabulator) voneinander getrennt werden. Dadurch kann verhindert werden, dass in den Spalten enthaltene Zeichen, z.B. ein Komma, als Spaltentrenner fälschlicherweise interprätiert werden.

#### Text-Begrezungszeichen
Wird das Spalten-Trennzeichen in den Werten der Datenspalten verwendet, so kann mit dem Text-Trennzeichen ein Zeichen festgelegt werden, das vor und nach jeder Spalte als Begrenzung verwendet wird.

#### Identifikationsfeld
Der in dieser Spalte enthaltene Wert kann mit verschiedenen Datenfeldern des Artikelstamms verglichen werden. 
Derzeit werden die Felder _Artikelnummer_, _Hersteller-Artikelnummer_, _EAN_ und _Hersteller EAN_ unterstüzt.

#### Vergleichsart
Der in der Spalte _Identifikationsfeld_ enthaltene Wert kann mit den Möglichkeiten _gleich_, _beginnt mit_, _endet mit_ oder _enthält_ verglichen werden.

**Beispiele:**  
gleich: 123 = 123  
beginnt mit: 123XYZ = 123  
endet mit: ABC123 = 123  
enthälz: ABC123XYZ = 123

#### Deaktivierte Artikel einschließen
Mit dieser Option kann gesteuert werden, ob deaktivierte Artikel bei der Aktualisierung berücksichtigt oder ignoriert werden.