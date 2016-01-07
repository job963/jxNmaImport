# jxUpdate Manual

## Introduction

jxUpdate allows to update any number of existing articles of a shop at once by importing a CSV file.

## How it works
Eine CSV Datei besteht in der Regel aus mehreren Spalten und Zeilen, vergleichbar mit einer Excel Tabelle.

Die erste Spalte enthält den Identifikationswert, also den Text/Wert mit dem ein Artikel identifiziert werden kann. Die nachfolgenden Spalten enthalten die Aktualisierungsdaten. Die Datei kann mehrere Aktualisierungsspalten enthalten.

Die erste Zeile der CSV Datei enthält die Festlegung der Datenbankfelder, die aktualisiert werden sollen. Die restlichen Zeilen enthalten die eigentlichen Aktualisierungsdaten.

## Examples

#### Import file for a simple deactivation
    oxartnum
    3503
    1302
    400-03
  
#### Import file for updating the EANs
    oxartnum,oxean
    3503;4010281030821
    3504;3057640349263
    400-01;5449000017888
  
#### Import file for updating the buy and sell price
    oxartnum,oxbprice,oxprice
    3503;15.5;29.75
    3504;12.5;24.75
    400-01;3.5;7.75