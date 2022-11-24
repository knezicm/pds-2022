## Primjena pravila formatiranja opisa u VHDL jeziku

Opis svakog dizajna u VHDL jeziku treba da bude uniformno stilizovan korišćenjem smjernica definisanih u okviru *VHDL coding style* koji je dio [*Open Hardware Repository*](https://ohwr.org/project/vhdl-style/wikis/home) projekta. Ove smjernice su dostupne u vidu [HTML stranice](https://ohwr.org/project/vhdl-style/blob/master/doc/vhdl-coding-style.adoc), a mogu i da se preuzmu kao [PDF dokument](https://ohwr.org/project/vhdl-style/uploads/823c24f03c53997f62dad2ed1dbe78ea/vhdl-coding-style.pdf). Ova pravila je potrebno striktno pratiti za svaki modul koji čini neki projekat opisan VHDL jezikom (uključujući *testbench* fajlove).

Jedan od propisanih elemenata, koji se obavezno mora zadovoljiti, je zaglavlje fajla (`[FileHeader]` pravilo). U smjernicama je dat ogledni primjer (*template*) za zaglavlje, a u projektima za ovaj kurs, zaglavlje treba da ima izgled ekvivalentan zaglavlju datom ispod (s tim da elementi `unit name` i `description` trebaju da budu prilagođeni samom dizajnu).

```
-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2022
-- https://github.com/knezicm/pds-2022/
-----------------------------------------------------------------------------
--
-- unit name:     NAND2
--
-- description:
--
--   This file implements a simple NAND2 logic.
--
-----------------------------------------------------------------------------
-- Copyright (c) 2022 Faculty of Electrical Engineering
-----------------------------------------------------------------------------
-- The MIT License
-----------------------------------------------------------------------------
-- Copyright 2022 Faculty of Electrical Engineering
--
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom
-- the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
-- THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE
-----------------------------------------------------------------------------
```

Za provjeru zadovoljenosti pravila u dizajnu možemo koristiti specifično kreiran alat `vhdllint-ohwr`, koji je dostupan na pomenutom repozitorijumu. Ovaj alat se može preuzeti u binarnoj formi za izvršavanje na *Windows* platformi i sastavni je dio repozitorijuma kursa (nalazi se u folderu `vhdllint-ohwr`).

Iako možete da ga koristite direktno, u repozitorijumu kursa se nalazi i skripta `check-files.bat` za provjeru svih fajlova koji se nalaze u folderu čiji je naziv određen brojem zadatka. Ovu skriptu koristimo na sljedeći način (uz pretpostavku da smo otvorili *Command Prompt* u folderu repozitorijuma):

```
cd vhdllint-ohwr
.\check-files.bat <issue_no> path\to\assignments\dir\
```

**Napomena:** Skrećemo pažnju da se direktorijumi u putanji kod *Windows* okruženja razdvajaju `\` karakterom.

U prvom koraku se premještamo u folder gdje je smješten alat za provjeru, a onda pozivamo skriptu kojoj prosljeđujemo broj zadatka (iz *GitHub* platforme) `<issue_no>` i putanju do foldera gdje se naš zadatak nalazi. Na primjer, ako želimo da provjerimo fajlove za zadatak čiji je broj 55, a sam folder u kojem su smješteni svi fajlovi zadatka se nalazi u folderu `assignments` repozitorijuma, koristimo sljedeću sintaksu:

```
.\check-files.bat 55 ..\assignments\
```

Prilikom provjere u okviru *Windows* platforme, vjerovatno ćete se susresti sa problemom koji se odnosi na formatiranje kraja linije. Naime, *Windows* konvencija podrazumijeva da se svaka linija u fajlu završava kombinacijom karaktera `<CR><LF>`, dok se kod *Unix* platformi u tu svrhu koristi samo `<LF>` karakter. Pravilom `[EndOfLine]`, propisano je da se prati *Unix* konvencija. Kada radimo u *Windows* okruženju, ovo može da dovede do grešaka pri provjeri stila. Jedno rješenje je da ignorišete greške koje se odnose na ovo pravilo, ali da prilikom predaje fajlova na repozitorijum, zamijenite `<CR><LF>` karaktere `<LF>` karakterom. Ovo se može automatizovati u okviru *Git* alata podešavanjem `autocrlf` parametra u konfiguraciji sljedećom komandom:

```
git config --global core.autocrlf true
```

Ova konfiguracija će prilikom svakog komitovanja fajlova, prilagoditi završetak linije *Unix* konvenciji, dok će prilikom svakog preuzimanja fajlova sa repozitorijuma završetak linije prilagoditi *Windows* konvenciji. Na taj način garantujemo da će fajlovi na udaljenom repozitorijumu biti ispravno formatirani. Više o drugim opcijama konfiguracije, možete pročitati u dokumentu [GitHub line endings configuration](https://docs.github.com/en/get-started/getting-started-with-git/configuring-git-to-handle-line-endings).

Ukoliko ipak želite da i lokalna provjera prođe bez bilo kakvih grešaka, onda možete da otvorite svaki fajl u editoru *Notepad++* i da u meniju odaberete opciju **Edit&rarr;EOL Conversion&rarr;Unix (LF)**. Na taj način ćete obezbijediti da sve linije budu terminisane po *Unix* konvenciji.
