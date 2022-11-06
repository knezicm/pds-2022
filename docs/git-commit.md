## Pravila prilikom predaje rješenja zadataka

Prilikom predaje rješenja zadataka tokom izvođenja kursa, potrebno je poštovati određeni skup pravila.

Prvo, svi zadaci se predaju preko _GitHub_ platforme korišćenjem Git alata. Prije nego što se počne sa realizacijom zadatka, student treba da kreira zasebnu granu na kojoj će raditi prilikom realizacije zadatka. Grana se kreira u okviru samog zadatka na _GitHub_ platformi kako je opisano u uputstvu [Proces rada u GitLab okruženju](github-workflow.md). Izvorna grana (**Branch source**) iz koje se izvodi nova grana obavezno treba da bude **assignments** grana. To je takođe grana u koju će se integrisati izmjene (**base**) nakon što se odobri _Pull Request_. Ime privremene radne grane treba da sadrži identifikacioni broj zadatka, kao i neki deskriptivni kratki opis samog zadatka koji student može proizvoljno da definiše (npr. `45-design-full-adder`). Nakon što je kreirana privremena grana za izradu zadatka, važno je napomenuti da student prvo treba da se prebaci na tu granu kako je opisano u uputstvu. Kada se prebaci na granu, student **obavezno** treba da kreira folder unutar foldera `assignments` čije ime odgovara broju zadatka (npr. ako je broj zadatka `#45`, onda ime foldera u kojem se smještaju svi fajlovi mora da bude `45`).

Svaki put kada napravi neke izmjene koje se odnose na realizaciju postavljenog zadatka, student treba da ih komituje (komandom `git commit`) i pošalje na udaljeni repozitorijum (komandom `git push`). Važno je napomenuti da se može koristiti više komitovanja prije nego što se postigne konačno rješenje zadatka (npr. ako ste napravili neku inicijalnu verziju, koju kasnije planirate proširiti ostalim funkcionalnostima, ali bi željeli da sačuvate trenutne izmjene).

**Važno:** Svaki komit treba da bude jednoobrazno strukturiran i da sadrži minimalno sljedeće elemente:

- U prvom redu naslov komita (koji treba da bude u formatu `Issue #No : IssueTitle`, gdje `No` predstavlja identifikator zadatka, a `IssueTitle` naslov zadatka.
- U drugom i narednim redovima kao lista opisno navedeno šta je urađeno u datom komitu.

Primjer zadovoljavajućeg komita je dat ispod.

```
Issue #45 : Design four-bit adder using data flow description

- Added entity definition for the design
- Added initial code for architecture
- Created an initial testbench code for the design
```

Preporučuje se korišćenje engleskog jezika u opisu komita, ali to nije obavezno.

Kada je zadovoljan krajnjim rješenjem, student treba da otvori zahtjev za integraciju izmjena u glavnu **assignments** granu (_Pull Request_) i da u njegovom naslovu koristi prvi red komita (`Issue #No : IssueTitle`), pri čemu je obavezno koristiti definisani broj zadatka i izvorni naziv definisanog zadatka bez ikakvih dodataka. Ukoliko je automatizovana provjera prošla kako treba, student treba prebaciti zadatak u _Review_ kolonu u okviru radne ploče.

Nakon toga, zadatak će biti pregledan i integrisan u **assignments** granu od strane predmetnog nastavnika ako zadovoljava kriterijume prihvatanja (zadatak se tada prebacuje u kolonu _Done_). Ako je neophodno, predmetni nastavnik može vratiti zadatak na doradu, pri čemu će u tom slučaju ostaviti komentare u okviru _Pull Request_ polja za komentare.