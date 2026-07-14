# Seed: Python Certification Exam Practice

## Gerarchia Topic

```
Programmazione Software (radice)
  └── Python
       └── Fondamenti
            ├── Tipi di dato
            ├── Conversioni di tipo
            ├── Variabili e assegnazione
            ├── Operatori aritmetici
            ├── Operatori di confronto
            ├── Operatori logici
            ├── Strutture condizionali
            ├── Ciclo for
            ├── Ciclo while
            ├── Stringhe
            ├── Formattazione output
            ├── Liste
            ├── Definizione funzioni
            ├── Chiamata funzioni
            ├── Funzioni built-in
            ├── Lettura e scrittura file
            ├── Gestione eccezioni
            ├── Modulo math
            ├── Modulo random
            ├── Modulo datetime
            ├── Modulo os e sys
            ├── Unit testing
            └── Documentazione
```

## Assessment Template

| Campo | Valore |
|---|---|
| Titolo | Python Certification Exam Practice |
| Tipo | CERT_SIMULATION |
| Difficoltà | INTERMEDIATE |
| Timer | 45 minuti |
| Descrizione | Simulazione dell'esame Certified Entry-Level Python Programmer. 35 domande a risposta multipla estratte casualmente da un pool, su fondamenti del linguaggio, tipi di dato, strutture di controllo, funzioni e gestione degli errori. |
| Domande per sessione | 35 (da pool di 67) |
| Punti risposta corretta | +1.00 |
| Punti risposta errata | 0 |
| Punti non risposta | 0 |
| Soglia superamento | 24.50 (70%) |
| Shuffle domande | true |
| Shuffle opzioni | true |

---

## Seeding

L'assessment è **contenuto di prodotto**, non dato demo: viene caricato in *tutti* gli
ambienti, produzione inclusa.

| Changeset | Context | Cosa fa |
|---|---|---|
| `v1.8-001-seed-python-cert` | `prod,dev` | Crea l'assessment template, le 67 domande, i 23 subject e la gerarchia di topic. Il file SQL vive in `db/seed/content/`, non in `db/seed/dev/`. |
| `v1.8-002-cleanup-demo-data` | `dev` | Rimuove il vecchio assessment demo "Programming Basics — Demo", ora superato. |
| `v1.8-003-publish-python-cert-dev` | `dev` | Pubblica uno snapshot dell'assessment e lo assegna alla classe `Demo-2026`, così un database di sviluppo appena creato ha subito un assessment somministrabile. |

In produzione il seed crea solo il **template**: la pubblicazione dello snapshot e
l'assegnazione a una classe restano azioni del docente nell'applicazione, non della
migrazione. Solo in `dev` vengono eseguite automaticamente (`v1.8-003`).

> I file di seed originali del demo (`50`/`60`/`65`/`70`) non vengono modificati: appartengono
> a changeset già applicati e cambiarne il contenuto invaliderebbe i checksum Liquibase sui
> database esistenti. La rimozione avviene quindi con un nuovo changeset che cancella i dati.

---

## Domande

---

### Tipi di dato

---

**Q1** | Subject: Tipi di dato | Difficulty: BEGINNER

Python distingue tra variabili di tipo intero (Integer) e variabili in virgola mobile (Float)?

```python
# Osserva il comportamento di Python con i tipi numerici
x = 10
y = 10.0
print(type(x))  # <class 'int'>
print(type(y))  # <class 'float'>
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, Python distingue sempre tra int e float | **Sì** |
| B | No, Python tratta tutti i numeri allo stesso modo | No |
| C | Solo se si usa la funzione type() | No |
| D | Solo nelle versioni Python 3.10+ | No |

> **Spiegazione:** Python mantiene una distinzione chiara tra int e float. `10` è un intero, `10.0` è un float, e `type()` lo conferma.

---

**Q3** | Subject: Tipi di dato | Difficulty: BEGINNER

Quando si assegna un valore booleano a una variabile in Python, il valore deve iniziare con la lettera maiuscola?

```python
# Test con valori booleani
is_active = True
is_deleted = False
print(is_active, type(is_active))
print(is_deleted, type(is_deleted))
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, `True` e `False` devono avere la prima lettera maiuscola | **Sì** |
| B | No, si può scrivere `true` e `false` in minuscolo | No |
| C | Entrambe le forme sono accettate | No |
| D | I booleani si rappresentano solo con 1 e 0 | No |

> **Spiegazione:** In Python, i letterali booleani sono `True` e `False` con la T e la F maiuscole. Scrivere `true` o `false` genera un `NameError`.

---

### Conversioni di tipo

---

**Q4** | Subject: Conversioni di tipo | Difficulty: BEGINNER

Quale opzione completa correttamente il codice per convertire i tipi di dato?

```python
serialnumber = ______(55555)
amount = ______(44)
message = "Ordine " + serialnumber + " totale: " + str(amount)
print(message)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `int()`, `str()` | No |
| B | `str()`, `float()` | **Sì** |
| C | `float()`, `str()` | No |
| D | `str()`, `int()` | No |

> **Spiegazione:** `serialnumber` viene concatenato con stringhe, quindi serve `str()`. `amount` deve essere un float (importo monetario), quindi serve `float()`. La concatenazione finale usa `str(amount)`.

---

**Q5** | Subject: Conversioni di tipo | Difficulty: BEGINNER

Quale funzione converte correttamente un valore float in un intero troncando la parte decimale?

```python
price = 19.95
whole_price = ______(price)
print(whole_price)  # Output: 19
print(type(whole_price))  # <class 'int'>
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `round` | No |
| B | `int` | **Sì** |
| C | `floor` | No |
| D | `str` | No |

> **Spiegazione:** La funzione `int()` tronca la parte decimale di un float, convertendolo in intero. `round()` arrotonderebbe, `floor()` richiederebbe `math.floor()`, e `str()` convertirebbe in stringa.

---

### Variabili e assegnazione

---

**Q2** | Subject: Variabili e assegnazione | Difficulty: BEGINNER

In Python, quando si dichiara una variabile è necessario specificare il tipo di dato?

```python
# Python usa la tipizzazione dinamica
age = 25
name = "Mario"
price = 19.99
print(age, name, price)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, è obbligatorio specificare il tipo | No |
| B | No, Python usa il tipo dinamico e lo deduce automaticamente | **Sì** |
| C | Solo per i tipi numerici | No |
| D | È obbligatorio solo nelle funzioni | No |

> **Spiegazione:** Python è un linguaggio a tipizzazione dinamica: il tipo viene dedotto automaticamente dal valore assegnato, senza dichiarazione esplicita.

---

**Q12** | Subject: Variabili e assegnazione | Difficulty: INTERMEDIATE

Dopo l'esecuzione del codice, quali sono i valori delle variabili?

```python
a = 5
b = 3
c = b
b = a
print(f"a={a}, b={b}, c={c}")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | a=5, b=5, c=5 | No |
| B | a=5, b=5, c=3 | **Sì** |
| C | a=5, b=3, c=3 | No |
| D | a=5, b=3, c=5 | No |

> **Spiegazione:** `c = b` assegna il valore corrente di `b` (3) a `c`. Poi `b = a` assegna il valore di `a` (5) a `b`. La variabile `c` resta 3 perché la riassegnazione di `b` non la influenza.

---

### Operatori aritmetici

---

**Q6** | Subject: Operatori aritmetici | Difficulty: INTERMEDIATE

Qual è il valore di `z` dopo l'esecuzione di questa espressione?

```python
a = 10
b = 5
c = 2
z = a + b * c - a / b
print(z)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | z = 22.0 | No |
| B | z = 18.0 | **Sì** |
| C | z = 8.0 | No |
| D | z = 20.0 | No |

> **Spiegazione:** Per la precedenza degli operatori: `b * c = 10`, `a / b = 2.0`, quindi `z = 10 + 10 - 2.0 = 18.0`. Moltiplicazione e divisione hanno priorità su addizione e sottrazione.

---

**Q7** | Subject: Operatori aritmetici | Difficulty: INTERMEDIATE

Valuta l'espressione: `a = 100 - 70 / 7`. Il risultato è `a == 90`?

```python
a = 100 - 70 / 7
print(a)
print(a == 90)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, `a` vale 90.0 | **Sì** |
| B | No, `a` vale 4.285... | No |
| C | No, `a` vale 100.0 | No |
| D | No, `a` vale 80.0 | No |

> **Spiegazione:** La divisione ha precedenza sulla sottrazione: `70 / 7 = 10.0`, quindi `a = 100 - 10.0 = 90.0`. Il confronto `a == 90` restituisce `True`.

---

**Q8** | Subject: Operatori aritmetici | Difficulty: INTERMEDIATE

Valuta l'espressione: `b = (35 % 15) // 2`. Il risultato è `b == 2.5`?

```python
b = (35 % 15) // 2
print(b)
print(b == 2.5)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, `b` vale 2.5 | No |
| B | No, `b` vale 2 | **Sì** |
| C | No, `b` vale 5 | No |
| D | No, `b` vale 0 | No |

> **Spiegazione:** `35 % 15 = 5` (resto della divisione), poi `5 // 2 = 2` (divisione intera). L'operatore `//` restituisce un intero troncato, non un float.

---

**Q9** | Subject: Operatori aritmetici | Difficulty: INTERMEDIATE

Valuta l'espressione: `c = -3 ** 2`. Il risultato è `c == -9`?

```python
c = -3 ** 2
print(c)
print(c == -9)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, `c` vale -9 | **Sì** |
| B | No, `c` vale 9 | No |
| C | No, `c` vale -6 | No |
| D | No, genera un errore | No |

> **Spiegazione:** L'operatore `**` ha precedenza maggiore del segno negativo `-`. Quindi Python valuta prima `3 ** 2 = 9`, poi applica il negativo: `-9`. Per ottenere 9, bisognerebbe scrivere `(-3) ** 2`.

---

**Q11** | Subject: Operatori aritmetici | Difficulty: BEGINNER

Dati `a = 10` e `b = 3`, quale espressione restituisce il risultato della divisione intera?

```python
a = 10
b = 3
print(a + b)    # 13
print(a - b)    # 7
print(a / b)    # 3.333...
print(a // b)   # ?
print(a % b)    # 1
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `a / b` restituisce 3 | No |
| B | `a // b` restituisce 3 | **Sì** |
| C | `a % b` restituisce 3 | No |
| D | `a // b` restituisce 3.333 | No |

> **Spiegazione:** L'operatore `//` esegue la divisione intera (floor division), troncando il risultato. `10 // 3 = 3`. L'operatore `/` restituisce un float: `10 / 3 = 3.333...`.

---

**Q15** | Subject: Operatori aritmetici | Difficulty: INTERMEDIATE

In un'espressione complessa, quale operazione viene eseguita per prima secondo la precedenza degli operatori Python?

```python
result = 5 + 3 * 2 ** 2 - 8 / 4
print(result)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | L'addizione `5 + 3` | No |
| B | La moltiplicazione `3 * 2` | No |
| C | L'esponente `2 ** 2` | **Sì** |
| D | La divisione `8 / 4` | No |

> **Spiegazione:** La precedenza degli operatori in Python è: `**` (esponente) > `*`, `/`, `//`, `%` > `+`, `-`. Quindi `2 ** 2 = 4` viene valutato per primo, poi `3 * 4 = 12` e `8 / 4 = 2.0`, infine `5 + 12 - 2.0 = 15.0`.

---

**Q16** | Subject: Operatori aritmetici | Difficulty: INTERMEDIATE

Quale espressione rappresenta correttamente l'ordine delle operazioni per calcolare il costo totale?

```python
carLoan = 300
licenseFee = 50
intRate = 0.05
# Calcola: (carLoan + licenseFee) * intRate
total = ?
print(total)  # 17.5
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `total = carLoan + licenseFee * intRate` | No |
| B | `total = carLoan * intRate + licenseFee` | No |
| C | `total = intRate * carLoan + licenseFee` | No |
| D | `total = (carLoan + licenseFee) * intRate` | **Sì** |

> **Spiegazione:** Le parentesi forzano l'addizione prima della moltiplicazione: `(300 + 50) * 0.05 = 350 * 0.05 = 17.5`. Senza parentesi, la moltiplicazione avrebbe precedenza.

---

**Q17** | Subject: Operatori aritmetici | Difficulty: INTERMEDIATE

Valuta le espressioni con gli operatori di assegnazione composta. Dopo l'esecuzione, `c == 3`?

```python
a = 5
b = 2
c = 3
a *= b   # a = a * b
b *= c   # b = b * c
a //= b  # a = a // b
print(f"a={a}, b={b}, c={c}")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, `c` vale 3 e non è stata modificata | **Sì** |
| B | No, `c` vale 6 | No |
| C | No, `c` vale 0 | No |
| D | No, `c` vale 1 | No |

> **Spiegazione:** `c` non viene mai riassegnata, quindi resta 3. `a *= b` → `a = 10`, `b *= c` → `b = 6`, `a //= b` → `a = 10 // 6 = 1`.

---

**Q18** | Subject: Operatori aritmetici | Difficulty: INTERMEDIATE

Dopo le operazioni di assegnazione composta, qual è il valore di `b`?

```python
a = 5
b = 2
c = 3
a *= b   # a = 5 * 2 = 10
b *= c   # b = 2 * 3 = ?
a //= b  # a = 10 // b
print(b)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | b = 2 | No |
| B | b = 6 | **Sì** |
| C | b = 10 | No |
| D | b = 3 | No |

> **Spiegazione:** `b *= c` equivale a `b = b * c = 2 * 3 = 6`. L'operatore `*=` moltiplica e riassegna.

---

**Q19** | Subject: Operatori aritmetici | Difficulty: INTERMEDIATE

Dopo tutte le operazioni, qual è il valore finale di `a`?

```python
a = 5
b = 2
c = 3
a *= b   # a = 10
b *= c   # b = 6
a //= b  # a = ?
print(a)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | a = 2 | No |
| B | a = 1 | **Sì** |
| C | a = 0 | No |
| D | a = 10 | No |

> **Spiegazione:** `a //= b` equivale a `a = a // b = 10 // 6 = 1`. La divisione intera di 10 per 6 dà 1 con resto 4.

---

### Operatori di confronto

---

**Q10** | Subject: Operatori di confronto | Difficulty: BEGINNER

Quale operatore di confronto completa correttamente le condizioni sui voti?

```python
grade = 85
if grade ______ 100:
    print("Voto perfetto")
if grade ______ 60:
    print("Promosso")
if grade ______ 50:
    print("Non sufficiente")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `!=`, `>`, `<` | No |
| B | `==`, `>=`, `<=` | **Sì** |
| C | `is`, `>=`, `<=` | No |
| D | `==`, `>`, `<` | No |

> **Spiegazione:** Per il voto perfetto serve uguaglianza stretta (`==`), per "promosso" serve maggiore o uguale (`>=`), e per "non sufficiente" serve minore o uguale (`<=`).

---

**Q13** | Subject: Operatori di confronto | Difficulty: INTERMEDIATE

Quale delle seguenti affermazioni è vera dopo l'esecuzione del codice?

```python
a = 5
b = 3
c = b
b = a
print(a == b)   # ?
print(b == 3)   # ?
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `a == b` è True e `b == 3` è True | No |
| B | `a == b` è True e `b == 3` è False | **Sì** |
| C | `a == b` è False e `b == 3` è True | No |
| D | `a == b` è False e `b == 3` è False | No |

> **Spiegazione:** Dopo `b = a`, sia `a` che `b` valgono 5, quindi `a == b` è True. `b` ora vale 5, non più 3, quindi `b == 3` è False.

---

**Q14** | Subject: Operatori di confronto | Difficulty: BEGINNER

Quale operatore verifica se una sottostringa è presente all'interno di una stringa?

```python
quote = "To be or not to be"
word = "nine"
result = word ______ quote
print(result)  # False
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `==` | No |
| B | `is` | No |
| C | `in` | **Sì** |
| D | `has` | No |

> **Spiegazione:** L'operatore `in` verifica se una sottostringa è contenuta in una stringa. `"nine" in quote` restituisce False perché "nine" non è presente nella frase.

---

### Operatori logici

---

**Q20** | Subject: Operatori logici | Difficulty: ADVANCED

Quale dei seguenti risultati è corretto per le espressioni booleane?

```python
a = 10
b = 7
c = 5
print(a > b and b > c)
print(a >= c and not(b + c > a))
print(a + b * c == 85 or a - b * c == 15)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | True, True, True | No |
| B | True, False, False | **Sì** |
| C | True, True, False | No |
| D | True, False, True | No |

> **Spiegazione:** (1) `10>7 and 7>5` → True. (2) `10>=5` è True ma `not(12>10)` è False, quindi False. (3) `10+35=45≠85` e `10-35=-25≠15`, quindi False.

---

### Strutture condizionali

---

**Q25** | Subject: Strutture condizionali | Difficulty: INTERMEDIATE

Qual è l'output del seguente programma di vendite mensili?

```python
month_sales = 15000
if month_sales > 10000:
    print("Obiettivo raggiunto!")
    print(f"Bonus: ${month_sales * 0.1:.2f}")
else:
    print("Obiettivo non raggiunto")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `Obiettivo non raggiunto` | No |
| B | `Obiettivo raggiunto!` seguito da `Bonus: $1500.00` | **Sì** |
| C | Solo `Obiettivo raggiunto!` | No |
| D | Errore di sintassi | No |

> **Spiegazione:** `15000 > 10000` è True, quindi entrambe le istruzioni nel blocco `if` vengono eseguite. Il bonus è `15000 * 0.1 = 1500.00`.

---

**Q26** | Subject: Strutture condizionali | Difficulty: INTERMEDIATE

Quale opzione completa correttamente la funzione che assegna i voti?

```python
def get_grade(score):
    if ______:
        grade = "A"
    elif ______:
        grade = "B"
    elif ______:
        grade = "C"
    else:
        ______
    return grade
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `score > 90`, `score > 80`, `score > 70`, `grade = "F"` | No |
| B | `score >= 90`, `score >= 80`, `score >= 70`, `grade = "F"` | **Sì** |
| C | `score == 90`, `score == 80`, `score == 70`, `grade = "F"` | No |
| D | `score >= 90`, `score >= 80`, `score >= 70`, `grade = "D"` | No |

> **Spiegazione:** Le soglie dei voti usano `>=` per includere il valore limite (es. 90 merita "A"). Il blocco `else` cattura tutti i punteggi sotto 70 assegnando "F".

---

**Q27** | Subject: Strutture condizionali | Difficulty: ADVANCED

Qual è l'output del seguente programma con if annidati?

```python
sales = 150000
region = "Nord"
season = "Natale"
if sales > 100000:
    if region == "Nord" and season == "Natale":
        print("Bonus premium: 15%")
    elif region == "Nord":
        print("Bonus standard: 10%")
    else:
        print("Bonus base: 5%")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `Bonus base: 5%` | No |
| B | `Bonus standard: 10%` | No |
| C | `Bonus premium: 15%` | **Sì** |
| D | Nessun output | No |

> **Spiegazione:** `sales > 100000` è True, poi `region == "Nord" and season == "Natale"` è True, quindi viene stampato il bonus premium del 15%.

---

**Q67** | Subject: Strutture condizionali | Difficulty: INTERMEDIATE

Quale modifica corregge l'errore di sintassi nel seguente codice?

```python
# Codice con errore:
score = 85
if score >= 90
    print("Eccellente")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Aggiungere le parentesi: `if (score >= 90)` | No |
| B | Aggiungere i due punti: `if score >= 90:` | **Sì** |
| C | Aggiungere il punto e virgola: `if score >= 90;` | No |
| D | Aggiungere le parentesi graffe: `if score >= 90 { }` | No |

> **Spiegazione:** In Python, i due punti `:` sono obbligatori alla fine delle istruzioni `if`, `elif`, `else`, `for`, `while`, `def`, `class`, ecc. Senza i due punti si genera un `SyntaxError`.

---

### Ciclo for

---

**Q29** | Subject: Ciclo for | Difficulty: BEGINNER

Qual è l'output di questo ciclo for con range?

```python
for week in range(1, 6):
    print(f"Settimana {week}")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Stampa "Settimana 1" fino a "Settimana 5" | **Sì** |
| B | Stampa "Settimana 1" fino a "Settimana 6" | No |
| C | Stampa "Settimana 0" fino a "Settimana 5" | No |
| D | Stampa "Settimana 0" fino a "Settimana 6" | No |

> **Spiegazione:** `range(1, 6)` genera i numeri da 1 a 5 (estremo superiore escluso). Quindi il ciclo stampa da "Settimana 1" a "Settimana 5".

---

**Q31** | Subject: Ciclo for | Difficulty: INTERMEDIATE

Qual è l'output del ciclo for con `break`?

```python
cities = ["Roma", "Milano", "Napoli", "Torino", "Firenze"]
for city in cities:
    if city == "Napoli":
        break
    print(city)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Roma, Milano, Napoli, Torino, Firenze | No |
| B | Roma, Milano | **Sì** |
| C | Roma, Milano, Napoli | No |
| D | Napoli | No |

> **Spiegazione:** Il ciclo stampa ogni città finché non incontra "Napoli". Quando `city == "Napoli"`, `break` interrompe il ciclo prima del `print`, quindi vengono stampate solo "Roma" e "Milano".

---

**Q33** | Subject: Ciclo for | Difficulty: INTERMEDIATE

Quale opzione completa correttamente il ciclo for con `continue`?

```python
______ day in range(1, ______):
    if day == 15 or day == 30:
        ______
    print(f"Giorno lavorativo: {day}")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `for`, `31`, `continue` | **Sì** |
| B | `while`, `31`, `break` | No |
| C | `for`, `30`, `pass` | No |
| D | `for`, `32`, `stop` | No |

> **Spiegazione:** `for` itera sui giorni, `range(1, 31)` copre i giorni da 1 a 30, e `continue` salta la stampa per i giorni 15 e 30 passando direttamente all'iterazione successiva.

---

**Q34** | Subject: Ciclo for | Difficulty: ADVANCED

Qual è l'output del seguente codice con cicli for annidati?

```python
days = 7
students = 10
total = days * students
print(f"Presenze totali da registrare: {total}")
for day in range(1, 3):
    for student in range(1, 4):
        print(f"G{day}-S{student}", end=" ")
    print()
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Stampa `Presenze totali da registrare: 70` e poi 6 combinazioni su 2 righe | **Sì** |
| B | Stampa `Presenze totali da registrare: 17` e poi 70 combinazioni | No |
| C | Stampa solo `Presenze totali da registrare: 70` | No |
| D | Genera un errore per i cicli annidati | No |

> **Spiegazione:** `7 * 10 = 70` presenze totali. I cicli annidati stampano le combinazioni per i giorni 1-2 e studenti 1-3: `G1-S1 G1-S2 G1-S3` (prima riga) e `G2-S1 G2-S2 G2-S3` (seconda riga).

---

### Ciclo while

---

**Q28** | Subject: Ciclo while | Difficulty: BEGINNER

Quale opzione completa correttamente il ciclo while con condizione di uscita?

```python
scheduledEvent = 1
______  scheduledEvent <= 5:
    if scheduledEvent == 3:
        ______
    print(f"Evento {scheduledEvent}")
    ______
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `for`, `continue`, `scheduledEvent += 1` | No |
| B | `while`, `break`, `scheduledEvent += 1` | **Sì** |
| C | `while`, `stop`, `scheduledEvent++` | No |
| D | `loop`, `break`, `scheduledEvent += 1` | No |

> **Spiegazione:** `while` crea il ciclo condizionale, `break` interrompe il ciclo quando l'evento è 3, e `scheduledEvent += 1` incrementa il contatore. Python non ha `++`.

---

**Q30** | Subject: Ciclo while | Difficulty: BEGINNER

A cosa serve la keyword `pass` in Python?

```python
for i in range(5):
    if i == 3:
        pass  # TODO: gestire caso speciale
    print(i)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Termina il ciclo immediatamente | No |
| B | Serve come segnaposto e non esegue nessuna operazione | **Sì** |
| C | Salta all'iterazione successiva del ciclo | No |
| D | Stampa il valore corrente | No |

> **Spiegazione:** `pass` è un'istruzione nulla che non fa niente. Si usa come segnaposto quando la sintassi richiede un blocco di codice ma non si vuole ancora implementare la logica.

---

**Q32** | Subject: Ciclo while | Difficulty: INTERMEDIATE

Quale opzione completa il codice di validazione input con un ciclo while?

```python
user_input = ""
while user_input == "":
    user_input = input("Inserisci il tuo nome: ")
    if user_input == "":
        print("Il campo non può essere vuoto!")
print(f"Benvenuto, {user_input}!")
```

Cosa succede se l'utente inserisce una stringa vuota due volte e poi "Mario"?

| Opzione | Testo | Corretta |
|---|---|---|
| A | Stampa "Benvenuto, !" e termina | No |
| B | Mostra il messaggio di errore due volte, poi stampa "Benvenuto, Mario!" | **Sì** |
| C | Genera un errore dopo il primo tentativo vuoto | No |
| D | Il ciclo non termina mai | No |

> **Spiegazione:** Il ciclo while continua finché `user_input` è vuoto. Ad ogni stringa vuota stampa l'avviso. Quando l'utente inserisce "Mario", la condizione diventa False e il ciclo termina.

---

### Stringhe

---

**Q21** | Subject: Stringhe | Difficulty: INTERMEDIATE

Quale notazione di slicing inverte correttamente una stringa in Python?

```python
greeting = "Hello World"
reversed_greeting = greeting[______]
print(reversed_greeting)  # "dlroW olleH"
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `[-1:0]` | No |
| B | `[::-1]` | **Sì** |
| C | `[0:-1]` | No |
| D | `[-1:]` | No |

> **Spiegazione:** La notazione `[::-1]` usa lo step negativo per attraversare la stringa dall'ultimo al primo carattere, invertendola completamente.

---

**Q24** | Subject: Stringhe | Difficulty: BEGINNER

Quale carattere si usa per continuare un'istruzione Python sulla riga successiva?

```python
total = 100 + 200 + 300 ______
        400 + 500
print(total)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `&` | No |
| B | `_` | No |
| C | `\` | **Sì** |
| D | `>>` | No |

> **Spiegazione:** Il backslash `\` alla fine di una riga indica che l'istruzione continua sulla riga successiva. È utile per mantenere il codice leggibile quando le righe sono troppo lunghe.

---

### Formattazione output

---

**Q22** | Subject: Formattazione output | Difficulty: BEGINNER

Quale prefisso si usa in Python per creare una f-string (stringa formattata)?

```python
name = "Alice"
age = 30
message = ______"Ciao {name}, hai {age} anni"
print(message)  # "Ciao Alice, hai 30 anni"
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `r` | No |
| B | `b` | No |
| C | `f` | **Sì** |
| D | `s` | No |

> **Spiegazione:** Il prefisso `f` prima delle virgolette crea una f-string, che permette di inserire espressioni Python tra parentesi graffe `{}` direttamente nella stringa.

---

### Liste

---

**Q35** | Subject: Liste | Difficulty: INTERMEDIATE

Qual è l'output corretto dell'iterazione su una tupla?

```python
products = ("Laptop", "Mouse", "Tastiera")
for product in products:
    print(product)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Stampa ogni prodotto su una riga separata: Laptop, Mouse, Tastiera | **Sì** |
| B | Stampa `("Laptop", "Mouse", "Tastiera")` | No |
| C | Genera un TypeError perché le tuple non sono iterabili | No |
| D | Stampa gli indici 0, 1, 2 | No |

> **Spiegazione:** Le tuple in Python sono iterabili. Il ciclo `for product in products` itera su ogni elemento della tupla, stampando "Laptop", "Mouse" e "Tastiera" su righe separate.

---

**Q36** | Subject: Liste | Difficulty: INTERMEDIATE

Qual è l'output del seguente codice che manipola una lista?

```python
animals = ["gatto", "cane", "coniglio"]
animals.append("pappagallo")
animals.sort()
print(animals)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `['gatto', 'cane', 'coniglio', 'pappagallo']` | No |
| B | `['cane', 'coniglio', 'gatto', 'pappagallo']` | **Sì** |
| C | `['pappagallo', 'gatto', 'coniglio', 'cane']` | No |
| D | `['coniglio', 'cane', 'gatto', 'pappagallo']` | No |

> **Spiegazione:** `append()` aggiunge "pappagallo" alla lista, poi `sort()` ordina alfabeticamente: cane, coniglio, gatto, pappagallo.

---

**Q37** | Subject: Liste | Difficulty: INTERMEDIATE

Data la lista di pezzi degli scacchi ordinata, quale istruzione stampa "torre"?

```python
pieces = ["alfiere", "cavallo", "pedone", "re", "regina", "torre"]
# La lista è già ordinata alfabeticamente
print(pieces[______])  # Deve stampare "torre"
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `pieces[4]` | No |
| B | `pieces[5]` | **Sì** |
| C | `pieces[-2]` | No |
| D | `pieces[6]` | No |

> **Spiegazione:** In una lista ordinata alfabeticamente, "torre" è l'ultimo elemento. Con 6 elementi (indici 0-5), `pieces[5]` accede all'ultimo elemento. `pieces[-1]` funzionerebbe ugualmente.

---

### Funzioni built-in

---

**Q38** | Subject: Funzioni built-in | Difficulty: BEGINNER

Quali funzioni built-in restituiscono il valore massimo e minimo di una lista?

```python
temperatures = [22, 18, 35, 12, 28]
highest = ______(temperatures)
lowest = ______(temperatures)
print(f"Max: {highest}, Min: {lowest}")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `maximum`, `minimum` | No |
| B | `max`, `min` | **Sì** |
| C | `high`, `low` | No |
| D | `top`, `bottom` | No |

> **Spiegazione:** `max()` e `min()` sono funzioni built-in di Python che restituiscono rispettivamente il valore massimo e minimo di un iterabile.

---

### Definizione funzioni

---

**Q39** | Subject: Definizione funzioni | Difficulty: INTERMEDIATE

Quale opzione completa correttamente la definizione della funzione?

```python
______ calcSubtotal(amount, salesTaxRate):
    subtotal = amount + (amount * salesTaxRate)
    ______ subtotal

result = calcSubtotal(100, 0.22)
print(result)  # 122.0
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `function`, `give` | No |
| B | `def`, `return` | **Sì** |
| C | `define`, `yield` | No |
| D | `func`, `output` | No |

> **Spiegazione:** In Python, `def` dichiara una funzione e `return` restituisce il valore al chiamante. Senza `return`, la funzione restituirebbe `None`.

---

**Q40** | Subject: Definizione funzioni | Difficulty: ADVANCED

Qual è il valore di `order1`?

```python
def calcTotal(member, subtotal, tax, discount):
    if member == "Yes":
        total = subtotal - (subtotal * discount)
        return total
    elif member == "No":
        pass

order1 = calcTotal("No", 500, 0.07, 0)
print(order1)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | 500 | No |
| B | 535.0 | No |
| C | 0 | No |
| D | None | **Sì** |

> **Spiegazione:** Quando `member == "No"`, il blocco `elif` esegue solo `pass` senza alcun `return`. In Python, una funzione che non esegue `return` restituisce implicitamente `None`.

---

**Q42** | Subject: Definizione funzioni | Difficulty: INTERMEDIATE

Qual è l'output quando si chiama una funzione con un parametro di default?

```python
def area(width, height=12):
    return width * height

print(area(5))
print(area(5, 8))
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Errore: manca un argomento | No |
| B | `60` e `60` | No |
| C | `60` e `40` | **Sì** |
| D | `17` e `13` | No |

> **Spiegazione:** `area(5)` usa il valore di default per height (12): `5 * 12 = 60`. `area(5, 8)` sovrascrive il default: `5 * 8 = 40`. I parametri con default sono opzionali nella chiamata.

---

### Chiamata funzioni

---

**Q41** | Subject: Chiamata funzioni | Difficulty: BEGINNER

Quale istruzione chiama correttamente la funzione e salva il risultato?

```python
def subtotal(amount, tax_rate):
    return amount + (amount * tax_rate)

______ = subtotal(500, 0.07)
print(order_total)  # 535.0
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `subtotal(500, 0.07)` | No |
| B | `return subtotal(500, 0.07)` | No |
| C | `order_total` | **Sì** |
| D | `def order_total` | No |

> **Spiegazione:** Per salvare il risultato di una funzione, basta assegnarlo a una variabile: `order_total = subtotal(500, 0.07)`. La variabile `order_total` riceve il valore restituito dalla funzione.

---

### Lettura e scrittura file

---

**Q44** | Subject: Lettura e scrittura file | Difficulty: INTERMEDIATE

Quale opzione completa correttamente il codice per aprire e leggere un file?

```python
file = open("prodotti.txt", "______")
content = file.______()
print(content)
file.close()
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `"w"`, `write` | No |
| B | `"r"`, `read` | **Sì** |
| C | `"a"`, `append` | No |
| D | `"x"`, `scan` | No |

> **Spiegazione:** La modalità `"r"` apre il file in sola lettura (read-only). Il metodo `read()` legge l'intero contenuto del file come stringa.

---

**Q46** | Subject: Lettura e scrittura file | Difficulty: INTERMEDIATE

Usando il costrutto `with`, perché non è necessario chiamare `close()`?

```python
with open('log.txt', 'w') as f:
    f.write("Operazione completata")
# Il file è già chiuso qui
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Il costrutto `with` chiude automaticamente il file all'uscita del blocco | **Sì** |
| B | Python chiude tutti i file alla fine del programma | No |
| C | Il metodo `write()` chiude il file dopo la scrittura | No |
| D | La modalità `'w'` chiude il file automaticamente | No |

> **Spiegazione:** Il costrutto `with` (context manager) garantisce che il file venga chiuso automaticamente quando l'esecuzione esce dal blocco `with`, anche in caso di eccezioni.

---

### Gestione eccezioni

---

**Q48** | Subject: Gestione eccezioni | Difficulty: INTERMEDIATE

Quale opzione completa correttamente la struttura try/except/else/finally?

```python
______:
    result = 10 / 2
______ ZeroDivisionError:
    print("Divisione per zero!")
______:
    print(f"Risultato: {result}")
______:
    print("Operazione terminata")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `try`, `except`, `else`, `finally` | **Sì** |
| B | `begin`, `catch`, `then`, `end` | No |
| C | `try`, `catch`, `else`, `finally` | No |
| D | `try`, `except`, `then`, `cleanup` | No |

> **Spiegazione:** Python usa `try/except/else/finally`: `try` contiene il codice da provare, `except` gestisce le eccezioni, `else` si esegue se non ci sono eccezioni, `finally` si esegue sempre.

---

**Q49** | Subject: Gestione eccezioni | Difficulty: INTERMEDIATE

Quale opzione completa il codice per lanciare un'eccezione e gestirla?

```python
def validate_age(age):
    if age < 0:
        ______ Exception("L'età non può essere negativa")
    return age

try:
    validate_age(-5)
except Exception as e:
    print(f"Errore: {e}")
______:
    print("Validazione completata")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `throw`, `end` | No |
| B | `raise`, `finally` | **Sì** |
| C | `raise`, `else` | No |
| D | `throw`, `finally` | No |

> **Spiegazione:** `raise` lancia un'eccezione in Python. `finally` esegue il codice di pulizia indipendentemente dal fatto che si sia verificata un'eccezione o meno.

---

**Q50** | Subject: Gestione eccezioni | Difficulty: BEGINNER

Quale opzione completa correttamente il blocco try/except base?

```python
______:
    number = int(input("Inserisci un numero: "))
    print(f"Hai inserito: {number}")
______ ValueError:
    print("Input non valido!")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `try`, `except` | **Sì** |
| B | `begin`, `catch` | No |
| C | `do`, `handle` | No |
| D | `check`, `error` | No |

> **Spiegazione:** `try` delimita il blocco di codice che potrebbe generare eccezioni, `except ValueError` cattura specificamente l'eccezione di valore non valido (es. input non numerico per `int()`).

---

**Q51** | Subject: Gestione eccezioni | Difficulty: INTERMEDIATE

Quali affermazioni sui blocchi try/except/else/finally sono corrette? Il blocco `else` viene eseguito solo se il blocco `try` non genera eccezioni?

```python
try:
    x = int("42")
except ValueError:
    print("Errore di conversione")
else:
    print("Conversione riuscita")
finally:
    print("Fine operazione")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, `else` viene eseguito solo quando `try` ha successo | **Sì** |
| B | No, `else` viene eseguito sempre | No |
| C | No, `else` viene eseguito solo quando c'è un'eccezione | No |
| D | `else` e `finally` si escludono a vicenda | No |

> **Spiegazione:** Il blocco `else` si esegue solo se nessuna eccezione viene sollevata nel `try`. Il blocco `finally` si esegue sempre, indipendentemente dalle eccezioni.

---

**Q52** | Subject: Gestione eccezioni | Difficulty: INTERMEDIATE

Il blocco `finally` viene eseguito anche se si verifica un'eccezione non gestita?

```python
try:
    result = 10 / 0
except TypeError:
    print("Errore di tipo")
finally:
    print("Pulizia risorse")
# ZeroDivisionError non è gestita da except TypeError
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, `finally` viene eseguito sempre, anche con eccezioni non gestite | **Sì** |
| B | No, `finally` viene saltato se l'eccezione non è gestita | No |
| C | No, il programma termina prima di `finally` | No |
| D | Solo se si usa `except Exception` generico | No |

> **Spiegazione:** Il blocco `finally` è garantito essere eseguito in ogni caso: successo, eccezione gestita o eccezione non gestita. È il posto ideale per operazioni di pulizia.

---

**Q53** | Subject: Gestione eccezioni | Difficulty: BEGINNER

Un `IndexError` in Python è classificato come quale tipo di errore?

```python
fruits = ["mela", "banana", "arancia"]
try:
    print(fruits[5])
except IndexError as e:
    print(f"Errore: {e}")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Errore di sintassi (Syntax Error) | No |
| B | Errore a runtime (Runtime Error) | **Sì** |
| C | Errore logico (Logic Error) | No |
| D | Errore di compilazione (Compile Error) | No |

> **Spiegazione:** `IndexError` è un errore a runtime: il codice è sintatticamente corretto ma fallisce durante l'esecuzione quando si tenta di accedere a un indice inesistente nella lista.

---

### Modulo math

---

**Q54** | Subject: Modulo math | Difficulty: INTERMEDIATE

Quale opzione completa correttamente l'uso del modulo `math`?

```python
______ math

rounded_up = math.______(4.2)
rounded_down = math.______(4.8)
truncated = ______(4.9)
print(rounded_up, rounded_down, truncated)  # 5 4 4
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `import`, `ceil`, `floor`, `int` | **Sì** |
| B | `include`, `round_up`, `round_down`, `int` | No |
| C | `import`, `ceiling`, `flooring`, `truncate` | No |
| D | `using`, `ceil`, `floor`, `round` | No |

> **Spiegazione:** `import math` importa il modulo. `math.ceil()` arrotonda per eccesso, `math.floor()` per difetto, e `int()` tronca semplicemente la parte decimale.

---

**Q56** | Subject: Modulo math | Difficulty: INTERMEDIATE

Quale modulo standard contiene il metodo `ceil()` per arrotondare per eccesso?

```python
import ______
result = ______.ceil(3.2)
print(result)  # 4
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `os` | No |
| B | `sys` | No |
| C | `math` | **Sì** |
| D | `io` | No |

> **Spiegazione:** Il metodo `ceil()` appartiene al modulo `math`. I moduli standard hanno scopi diversi: `os` per il sistema operativo, `sys` per l'interprete, `io` per le operazioni di I/O.

---

**Q58** | Subject: Modulo math | Difficulty: INTERMEDIATE

Qual è l'output del seguente programma che calcola l'area di un cerchio?

```python
import math

pi = math.pi
radius = float(input("Raggio: "))  # L'utente inserisce: 5
area = pi * radius ** 2
print(f"Area: {area:.2f}")
```

Se l'utente inserisce `5`, qual è l'output?

| Opzione | Testo | Corretta |
|---|---|---|
| A | `Area: 78.54` | **Sì** |
| B | `Area: 31.42` | No |
| C | `Area: 157.08` | No |
| D | `Area: 25.00` | No |

> **Spiegazione:** `math.pi ≈ 3.14159`, `radius = 5.0`, `area = 3.14159 * 25 = 78.5398...`. Con `:.2f` viene formattato a 2 decimali: `78.54`.

---

### Modulo random

---

**Q55** | Subject: Modulo random | Difficulty: INTERMEDIATE

Quale opzione completa correttamente l'uso del modulo `random`?

```python
import random

colors = ["rosso", "blu", "verde", "giallo"]
picked = random.______(colors)
random.______(colors)
sample = random.______(colors, 2)
print(picked, colors, sample)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `choice`, `shuffle`, `sample` | **Sì** |
| B | `pick`, `mix`, `select` | No |
| C | `choose`, `randomize`, `take` | No |
| D | `select`, `sort`, `slice` | No |

> **Spiegazione:** `random.choice()` seleziona un elemento casuale, `random.shuffle()` mescola la lista in-place, e `random.sample()` restituisce un campione di n elementi senza ripetizione.

---

**Q61** | Subject: Modulo random | Difficulty: INTERMEDIATE

Quale opzione completa il gioco di indovinare il numero?

```python
______ random ______ randint

secret = ______(1, 10)
guess = int(input("Indovina (1-10): "))
if guess == secret:
    print("Hai indovinato!")
else:
    print(f"Era {secret}")
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `from`, `import`, `randint` | **Sì** |
| B | `import`, `use`, `random` | No |
| C | `include`, `get`, `randint` | No |
| D | `from`, `import`, `random` | No |

> **Spiegazione:** `from random import randint` importa direttamente la funzione `randint`, permettendo di usarla senza il prefisso del modulo. `randint(1, 10)` genera un intero casuale tra 1 e 10 inclusi.

---

### Modulo datetime

---

**Q59** | Subject: Modulo datetime | Difficulty: INTERMEDIATE

Quale metodo del modulo `datetime` restituisce la data e ora corrente?

```python
import datetime

now = datetime.datetime.______()
print(now)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `today()` o `now()` — entrambi sono validi | **Sì** |
| B | Solo `current()` | No |
| C | Solo `getTime()` | No |
| D | Solo `timestamp()` | No |

> **Spiegazione:** Sia `datetime.datetime.today()` che `datetime.datetime.now()` restituiscono la data e ora corrente. `now()` accetta un parametro opzionale per il fuso orario.

---

**Q60** | Subject: Modulo datetime | Difficulty: INTERMEDIATE

Quale opzione completa correttamente l'uso del modulo datetime per la formattazione?

```python
______ datetime

now = datetime.datetime.______()
formatted = now.strftime("______")
day_name = now.______
print(formatted)  # Es: "06/24/2026"
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `import`, `now`, `%m/%d/%Y`, `weekday` | **Sì** |
| B | `include`, `today`, `dd/mm/yyyy`, `day` | No |
| C | `import`, `current`, `%D/%M/%Y`, `dayOfWeek` | No |
| D | `using`, `now`, `MM/DD/YYYY`, `weekday` | No |

> **Spiegazione:** `import datetime` importa il modulo, `now()` ottiene la data corrente, `%m/%d/%Y` è il formato mese/giorno/anno, e `weekday` restituisce il giorno della settimana (0=lunedì).

---

### Modulo os e sys

---

**Q45** | Subject: Modulo os e sys | Difficulty: INTERMEDIATE

Quale opzione completa il codice per verificare l'esistenza del file e leggerne una riga?

```python
import os
if os.path.______(workFile):
    f = open(workFile, "r")
    line = f.______()
    print(line)
    f.close()
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `exists`, `read` | No |
| B | `isfile`, `readline` | **Sì** |
| C | `isdir`, `readlines` | No |
| D | `check`, `getline` | No |

> **Spiegazione:** `os.path.isfile()` verifica se il percorso è un file esistente. `readline()` legge una singola riga dal file. `exists()` controlla anche le directory, `isfile()` è più specifico.

---

**Q47** | Subject: Modulo os e sys | Difficulty: INTERMEDIATE

Cosa rappresenta `sys.argv[0]` quando si esegue uno script Python dalla riga di comando?

```python
import sys
print(sys.argv[0])
# Esecuzione: python script.py arg1 arg2
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Il primo argomento passato (`arg1`) | No |
| B | Il nome del file script (`script.py`) | **Sì** |
| C | Il percorso dell'interprete Python | No |
| D | Il numero totale di argomenti | No |

> **Spiegazione:** `sys.argv` è una lista degli argomenti della riga di comando. `sys.argv[0]` è sempre il nome dello script, `sys.argv[1]` è il primo argomento, ecc.

---

**Q57** | Subject: Modulo os e sys | Difficulty: INTERMEDIATE

Quale associazione tra modulo e metodo è corretta?

```python
import io, math, os, sys

# Quale modulo contiene quale metodo?
# open() → ?    ceil() → ?    mkdir() → ?    exit() → ?
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | io→open, math→ceil, os→mkdir, sys→exit | **Sì** |
| B | os→open, math→ceil, io→mkdir, sys→exit | No |
| C | sys→open, io→ceil, os→mkdir, math→exit | No |
| D | io→open, sys→ceil, math→mkdir, os→exit | No |

> **Spiegazione:** Ogni modulo ha il suo scopo: `io` gestisce gli stream (open), `math` le funzioni matematiche (ceil), `os` il sistema operativo (mkdir), `sys` l'interprete Python (exit).

---

### Unit testing

---

**Q62** | Subject: Unit testing | Difficulty: INTERMEDIATE

Quale opzione completa correttamente lo unit test?

```python
import ______

class TestMath(______.TestCase):
    def test_addition(self):
        self.______(2 + 2, 4)

if ______ == "__main__":
    unittest.main()
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `unittest`, `unittest`, `assertEqual`, `__name__` | **Sì** |
| B | `testing`, `testing`, `assertSame`, `__file__` | No |
| C | `pytest`, `pytest`, `assertEquals`, `__name__` | No |
| D | `unittest`, `unittest`, `assertMatch`, `__module__` | No |

> **Spiegazione:** Il modulo `unittest` è lo standard per i test in Python. Si crea una classe che eredita da `unittest.TestCase`, si usa `assertEqual` per le asserzioni, e `__name__` per l'esecuzione diretta.

---

**Q63** | Subject: Unit testing | Difficulty: ADVANCED

Quale metodo di asserzione verifica che due variabili puntino allo stesso oggetto in memoria?

```python
import unittest

class TestIdentity(unittest.TestCase):
    def test_same_object(self):
        a = [1, 2, 3]
        b = a
        self.______(a, b)

    def test_different_objects(self):
        a = [1, 2, 3]
        b = [1, 2, 3]
        self.assertIsNot(a, b)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `assertEqual` | No |
| B | `assertTrue` | No |
| C | `assertIn` | No |
| D | `assertIs` | **Sì** |

> **Spiegazione:** `assertIs(a, b)` verifica che `a` e `b` siano lo stesso oggetto in memoria (equivalente a `a is b`). `assertEqual` verifica solo l'uguaglianza dei valori.

---

### Documentazione

---

**Q23** | Subject: Documentazione | Difficulty: BEGINNER

Quale carattere si usa in Python per inserire un commento su una singola riga?

```python
______ Questo è un commento
price = 29.99  ______ prezzo del prodotto
print(price)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `//` | No |
| B | `/* */` | No |
| C | `#` | **Sì** |
| D | `--` | No |

> **Spiegazione:** In Python il carattere `#` indica un commento. Tutto ciò che segue `#` sulla stessa riga viene ignorato dall'interprete.

---

**Q43** | Subject: Documentazione | Difficulty: INTERMEDIATE

Quale opzione completa correttamente il codice per definire e accedere a una docstring?

```python
def area(width, height):
    ______ Calcola l'area di un rettangolo. ______
    return width * height

print(area.______)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | `#`, `#`, `doc` | No |
| B | `"""`, `"""`, `__doc__` | **Sì** |
| C | `'''`, `'''`, `help` | No |
| D | `//`, `//`, `__doc__` | No |

> **Spiegazione:** Le docstring in Python sono racchiuse tra triple virgolette `"""..."""` e si accedono tramite l'attributo `__doc__`. Sono la documentazione standard delle funzioni.

---

**Q64** | Subject: Documentazione | Difficulty: BEGINNER

Quale delle seguenti affermazioni su pydoc in Python è vera? Pydoc genera automaticamente documentazione dal codice sorgente?

```python
# Per generare documentazione:
# python -m pydoc math
# python -m pydoc -w math  (genera HTML)
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, pydoc genera documentazione leggendo le docstring del codice | **Sì** |
| B | No, la documentazione deve essere scritta separatamente | No |
| C | Pydoc funziona solo con moduli della libreria standard | No |
| D | Pydoc richiede un file di configurazione separato | No |

> **Spiegazione:** Pydoc è uno strumento integrato che genera automaticamente documentazione estraendo le docstring dal codice sorgente Python. Funziona con qualsiasi modulo.

---

**Q65** | Subject: Documentazione | Difficulty: BEGINNER

Pydoc può generare documentazione in formato HTML?

```python
# Generazione documentazione HTML
# python -m pydoc -w mymodule
# Questo crea mymodule.html nella directory corrente
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, con il flag `-w` genera file HTML | **Sì** |
| B | No, genera solo testo in console | No |
| C | Solo con plugin aggiuntivi | No |
| D | Solo per i moduli built-in | No |

> **Spiegazione:** Il comando `python -m pydoc -w modulo` genera un file HTML con la documentazione del modulo specificato. Il flag `-w` sta per "write" e crea il file nella directory corrente.

---

**Q66** | Subject: Documentazione | Difficulty: BEGINNER

La sintassi di pydoc nella shell Python è `help(modulo)`?

```python
# Nella shell interattiva Python:
import math
help(math)
# Oppure dalla riga di comando:
# python -m pydoc math
```

| Opzione | Testo | Corretta |
|---|---|---|
| A | Sì, `help()` usa pydoc internamente per mostrare la documentazione | **Sì** |
| B | No, `help()` e pydoc sono completamente indipendenti | No |
| C | `help()` funziona solo con le stringhe | No |
| D | Bisogna importare pydoc prima di usare `help()` | No |

> **Spiegazione:** La funzione built-in `help()` usa pydoc internamente per generare e mostrare la documentazione interattiva di moduli, classi, funzioni e metodi.

---

---

## Riepilogo domande per subject

| Subject | Domande | Quantità |
|---|---|---|
| Tipi di dato | Q1, Q3 | 2 |
| Conversioni di tipo | Q4, Q5 | 2 |
| Variabili e assegnazione | Q2, Q12 | 2 |
| Operatori aritmetici | Q6, Q7, Q8, Q9, Q11, Q15, Q16, Q17, Q18, Q19 | 10 |
| Operatori di confronto | Q10, Q13, Q14 | 3 |
| Operatori logici | Q20 | 1 |
| Strutture condizionali | Q25, Q26, Q27, Q67 | 4 |
| Ciclo for | Q29, Q31, Q33, Q34 | 4 |
| Ciclo while | Q28, Q30, Q32 | 3 |
| Stringhe | Q21, Q24 | 2 |
| Formattazione output | Q22 | 1 |
| Liste | Q35, Q36, Q37 | 3 |
| Definizione funzioni | Q39, Q40, Q42 | 3 |
| Chiamata funzioni | Q41 | 1 |
| Funzioni built-in | Q38 | 1 |
| Lettura e scrittura file | Q44, Q46 | 2 |
| Gestione eccezioni | Q48, Q49, Q50, Q51, Q52, Q53 | 6 |
| Modulo math | Q54, Q56, Q58 | 3 |
| Modulo random | Q55, Q61 | 2 |
| Modulo datetime | Q59, Q60 | 2 |
| Modulo os e sys | Q45, Q47, Q57 | 3 |
| Unit testing | Q62, Q63 | 2 |
| Documentazione | Q23, Q43, Q64, Q65, Q66 | 5 |
| **Totale** | | **67** |

## Distribuzione per difficoltà

| Difficoltà | Quantità | Percentuale |
|---|---|---|
| BEGINNER | 22 | 33% |
| INTERMEDIATE | 40 | 60% |
| ADVANCED | 5 | 7% |
| **Totale** | **67** | 100% |

## Mappatura Topic → Subject

Ogni subject appartiene al topic **"Fondamenti"**, che è figlio di **"Python"**, figlio di **"Programmazione Software"** (radice).

| Topic | Subject | Position |
|---|---|---|
| Fondamenti | Tipi di dato | 1 |
| Fondamenti | Conversioni di tipo | 2 |
| Fondamenti | Variabili e assegnazione | 3 |
| Fondamenti | Operatori aritmetici | 4 |
| Fondamenti | Operatori di confronto | 5 |
| Fondamenti | Operatori logici | 6 |
| Fondamenti | Strutture condizionali | 7 |
| Fondamenti | Ciclo for | 8 |
| Fondamenti | Ciclo while | 9 |
| Fondamenti | Stringhe | 10 |
| Fondamenti | Formattazione output | 11 |
| Fondamenti | Liste | 12 |
| Fondamenti | Definizione funzioni | 13 |
| Fondamenti | Chiamata funzioni | 14 |
| Fondamenti | Funzioni built-in | 15 |
| Fondamenti | Lettura e scrittura file | 16 |
| Fondamenti | Gestione eccezioni | 17 |
| Fondamenti | Modulo math | 18 |
| Fondamenti | Modulo random | 19 |
| Fondamenti | Modulo datetime | 20 |
| Fondamenti | Modulo os e sys | 21 |
| Fondamenti | Unit testing | 22 |
| Fondamenti | Documentazione | 23 |

## Mappatura Domande → Subject

Ogni domanda è collegata a **un solo subject** con weight 1.00 (tabella `question_template_subject`).

| Subject | Domande | Tot |
|---|---|---|
| Tipi di dato | Q1, Q3 | 2 |
| Conversioni di tipo | Q4, Q5 | 2 |
| Variabili e assegnazione | Q2, Q12 | 2 |
| Operatori aritmetici | Q6, Q7, Q8, Q9, Q11, Q15, Q16, Q17, Q18, Q19 | 10 |
| Operatori di confronto | Q10, Q13, Q14 | 3 |
| Operatori logici | Q20 | 1 |
| Strutture condizionali | Q25, Q26, Q27, Q67 | 4 |
| Ciclo for | Q29, Q31, Q33, Q34 | 4 |
| Ciclo while | Q28, Q30, Q32 | 3 |
| Stringhe | Q21, Q24 | 2 |
| Formattazione output | Q22 | 1 |
| Liste | Q35, Q36, Q37 | 3 |
| Definizione funzioni | Q39, Q40, Q42 | 3 |
| Chiamata funzioni | Q41 | 1 |
| Funzioni built-in | Q38 | 1 |
| Lettura e scrittura file | Q44, Q46 | 2 |
| Gestione eccezioni | Q48, Q49, Q50, Q51, Q52, Q53 | 6 |
| Modulo math | Q54, Q56, Q58 | 3 |
| Modulo random | Q55, Q61 | 2 |
| Modulo datetime | Q59, Q60 | 2 |
| Modulo os e sys | Q45, Q47, Q57 | 3 |
| Unit testing | Q62, Q63 | 2 |
| Documentazione | Q23, Q43, Q64, Q65, Q66 | 5 |
| **Totale** | | **67** |

## Mappatura Assessment Template → Subject

L'assessment **"Python Certification Exam Practice"** copre tutti i 23 subject (tabella `assessment_template_subject`).

| assessment_template | subject |
|---|---|
| Python Certification Exam Practice | Tipi di dato |
| Python Certification Exam Practice | Conversioni di tipo |
| Python Certification Exam Practice | Variabili e assegnazione |
| Python Certification Exam Practice | Operatori aritmetici |
| Python Certification Exam Practice | Operatori di confronto |
| Python Certification Exam Practice | Operatori logici |
| Python Certification Exam Practice | Strutture condizionali |
| Python Certification Exam Practice | Ciclo for |
| Python Certification Exam Practice | Ciclo while |
| Python Certification Exam Practice | Stringhe |
| Python Certification Exam Practice | Formattazione output |
| Python Certification Exam Practice | Liste |
| Python Certification Exam Practice | Definizione funzioni |
| Python Certification Exam Practice | Chiamata funzioni |
| Python Certification Exam Practice | Funzioni built-in |
| Python Certification Exam Practice | Lettura e scrittura file |
| Python Certification Exam Practice | Gestione eccezioni |
| Python Certification Exam Practice | Modulo math |
| Python Certification Exam Practice | Modulo random |
| Python Certification Exam Practice | Modulo datetime |
| Python Certification Exam Practice | Modulo os e sys |
| Python Certification Exam Practice | Unit testing |
| Python Certification Exam Practice | Documentazione |

## Mappatura Assessment Template → Topic

L'assessment è collegato al topic **"Fondamenti"** (tabella `assessment_template_topic`).

| assessment_template | topic |
|---|---|
| Python Certification Exam Practice | Fondamenti |

---

## Note di conversione

Le 56 domande originali sono state espanse a 67 domande a causa delle seguenti trasformazioni:

- **True/False table** (Q1, Q8, Q11, Q41, Q42, Q47, Q52): ogni affermazione è diventata una domanda separata MULTIPLE_CHOICE con opzioni Sì/No + 2 distrattori
- **Fill-in-the-blank**: convertite in "quale opzione completa correttamente il codice" con 4 opzioni
- **Choose-two**: selezionata la risposta principale e convertita in MULTIPLE_CHOICE
- **Drag-and-drop / ordering**: riscritte come "qual è l'output" o "quale istruzione va nella posizione X"
- Tutte le domande hanno esattamente 4 opzioni con 1 sola risposta corretta
- Il codice è sempre in un blocco separato con contesto realistico di 4-6 righe
