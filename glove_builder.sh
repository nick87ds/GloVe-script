#!/bin/bash
set -e

############ Parameters ###############

LANG=it

SHUTDOWN=1 # Alla fine spegne il PC altrimenti glove/eval/python/distance.py

RESET_CORPUS=0 # Se = 1 rimuove il file corrispondente alla variabile CORPUS

RESET_GLOVE=0  # Se = 1 rimuove i files generati dall'algoritmo GloVe

##### GloVe parameters

CORPUS=text8
VOCAB_FILE=vocab.txt
COOCCURRENCE_FILE=cooccurrence.bin
COOCCURRENCE_SHUF_FILE=cooccurrence.shuf.bin
BUILDDIR=glove/build
SAVE_FILE=vectors
VERBOSE=2
MEMORY=8.0
VOCAB_MIN_COUNT=5
VECTOR_SIZE=100
MAX_ITER=15
WINDOW_SIZE=15
BINARY=2
NUM_THREADS=8
X_MAX=15

#######################################

RED=$(tput setaf 1)
NORMAL=$(tput sgr0)

WIKI_LINK="https://dumps.wikimedia.org/${LANG}wiki/latest/${LANG}wiki-latest-pages-articles.xml.bz2"
WIKI_FILE="${LANG}wiki-latest-pages-articles.xml.bz2"

WIKI_ARCHIVE_MILESTONE=wiki_end
WIKI_CORPUS_MILESTONE=wiki_corpus

if [ ! -e $WIKI_FILE ]; then

  # Se non è presente il file di wikipedia allora lo scarica

  printf "${RED}Download Wikipedia dump file \n${NORMAL}"
  wget $WIKI_LINK

fi


if [ ! -e wikiextractor/wikiextractor/WikiExtractor.py ]; then

  # Se non è presente il WikiExtractor allora clona il repository

  printf "Clone WikiExtractor repository \n"
  git clone https://github.com/attardi/wikiextractor.git

fi


if [ ! -e glove/build/glove ]; then

  # Se non è presente lo script per il GloVe 
  # allora clona il repository e procede all'installazione

  printf "${RED}Clone and install GloVe \n${NORMAL}"
  git clone https://github.com/stanfordnlp/GloVe.git
  cd glove && make
  cd ..
  
fi

if [ $RESET_CORPUS == 1 ]; then

  printf "${RED}Reset Corpus \n${NORMAL}"
  
  rm $CORPUS

fi


if [ $RESET_GLOVE == 1 ]; then

  printf "${RED}Reset solo GloVe \n${NORMAL}"
  
  rm $VOCAB_FILE
  rm "$SAVE_FILE.txt"
  rm "$SAVE_FILE.bin"

fi



if [ ! -e  $WIKI_ARCHIVE_MILESTONE ]; then

  # Se non è presente il file $WIKI_ARCHIVE_MILESTONE
  # allora procede alla costruzione dell'archivio json.
  # Successivamente crea il file $WIKI_ARCHIVE_MILESTONE che funge da 'milestone'.

  printf "${RED}Start data extraction from wikipedia dump file \n${NORMAL}"
  python3 -m wikiextractor.wikiextractor.WikiExtractor -o output --processes 8 --json  itwiki-latest-pages-articles.xml.bz2 
  touch $WIKI_ARCHIVE_MILESTONE

fi

if [ ! -e  $WIKI_CORPUS_MILESTONE ]; then

  # Se non è presente il file $WIKI_CORPUS_MILESTONE
  # allora procede al preprocessing tramite lo script in python
  # Successivamente crea il file $WIKI_CORPUS_MILESTONE che funge da 'milestone'.

  printf "${RED}Start data preprocessing \n${NORMAL}"

  python3 corpus_cleaner.py >> $CORPUS

  touch $WIKI_CORPUS_MILESTONE

fi

if [ ! -e  $VOCAB_FILE ]; then

  # Se non è presente il file $VOCAB_FILE allora 
  # procede all'elaborazione del GloVe

  printf "${RED}Start GloVe \n${NORMAL}"

echo

echo "$ $BUILDDIR/vocab_count -min-count $VOCAB_MIN_COUNT -verbose $VERBOSE < $CORPUS > $VOCAB_FILE"
$BUILDDIR/vocab_count -min-count $VOCAB_MIN_COUNT -verbose $VERBOSE < $CORPUS > $VOCAB_FILE

echo "$ $BUILDDIR/cooccur -memory $MEMORY -vocab-file $VOCAB_FILE -verbose $VERBOSE -window-size $WINDOW_SIZE < $CORPUS > $COOCCURRENCE_FILE"
$BUILDDIR/cooccur -memory $MEMORY -vocab-file $VOCAB_FILE -verbose $VERBOSE -window-size $WINDOW_SIZE < $CORPUS > $COOCCURRENCE_FILE

echo "$ $BUILDDIR/shuffle -memory $MEMORY -verbose $VERBOSE < $COOCCURRENCE_FILE > $COOCCURRENCE_SHUF_FILE"
$BUILDDIR/shuffle -memory $MEMORY -verbose $VERBOSE < $COOCCURRENCE_FILE > $COOCCURRENCE_SHUF_FILE

echo "$ $BUILDDIR/glove -save-file $SAVE_FILE -threads $NUM_THREADS -input-file $COOCCURRENCE_SHUF_FILE -x-max $X_MAX -iter $MAX_ITER -vector-size $VECTOR_SIZE -binary $BINARY -vocab-file $VOCAB_FILE -verbose $VERBOSE"
$BUILDDIR/glove -save-file $SAVE_FILE -threads $NUM_THREADS -input-file $COOCCURRENCE_SHUF_FILE -x-max $X_MAX -iter $MAX_ITER -vector-size $VECTOR_SIZE -binary $BINARY -vocab-file $VOCAB_FILE -verbose $VERBOSE


fi

if [ $SHUTDOWN == 1 ]; then

  printf "${RED}Spegnimento \n${NORMAL}"
  shutdown

else

  printf "${RED}Caricamento script di testing \n${NORMAL}"
  python3 glove/eval/python/distance.py

fi
