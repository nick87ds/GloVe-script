# Glove-script: an all-inclusive script
Download corpus, preprocessing data and training GloVe all-in-one

## Introduzione

Il GloVe è un algoritmo non supervisionato, realizzato da [Stanford NLP Group](https://nlp.stanford.edu/), per ottenere una rappresentazione vettoriale delle parole.
I vettori fanno in modo che parole simili si trovino vicino in termini di distanza spaziale, viceversa vale per le parole diverse.
Il GloVe cattura sia statistiche globali che locali di un "corpus". Il metodo deriva da un'importante idea: Si può derivare la relazione semantica tra parole dalla matrice di co-occorrenza.

Lo script realizzato racchiude i tre step principali:
* Download del corpus degli articoli [Wikimedia](https://dumps.wikimedia.org);
* Estrazione e preprocessing dei dati;
* Training del GloVe.

Ogni step genera un file usato come "milestone" che permette allo script di *non* dover ricominciare da capo ogni volta. Inoltre tutti i passaggi sono facilmente personalizzabili.

Le prime righe dello script contengono i parametri per il download del corpus nella lingua desiderata **LANG**, mentre gli altri parametri riguardano i parametri per il training dell'algoritmo.

Dopo il download c'è l'estrazione ed archivizione in formato json degli articoli che avviene tramite lo script [WikiExtractor](https://github.com/attardi/wikiextractor) scritto in Python.

Successivamente si avvia lo script in Python che estrae e processa (cleaning) i singoli articoli archiviati in json. Lo script di cleaning, realizzato in Python, è facilmente personalizzabile.

Alla fine lo script avvia lo shutdown (impostazione di default) oppure lancia uno script per interagire con il modello appena creato (impostando la variabile SHUTDOWN del file glove_builder.sh con un valore diverso da 1).

## Installazione ed avvio

```
git clone https://github.com/nick87ds/GloVe-script.git

chmod +x glove_builder.sh

./glove_builder.sh
```
