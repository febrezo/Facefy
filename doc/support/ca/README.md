# Ajuda en línia

## Sobre la tecnologia ...

### ¿Facefy utilitza una plataforma en el núvol per a realitzar les recerques?

No. Una vegada descarregada i instal·lada, tota la feina es desenvolupa en el teu equip. Personalment, odio el paradigma de Service as a Software Substitute fins al punt que intento fer amb el meu treball _software_ que sigui usable de forma independent per tothom.

### ¿Així que mai s'envia cap fotografia a cap proveïdor del núvol?

No.

### Això està bé! Llavors, has escrit un sistema de reconeixement facial complet?

No. Facefy és una aplicació que inclou les capacitats de tecnologies conegudes com `Dlib` i` face_recognition` utilitzant un dimoni JSON RPC personalitzat i creat ad hoc en Python 3.6+ (anomenat` pyfaces`) i un entorn d'escriptori basat en GTK .

### On puc trobar imatges de prova per provar-ho?

Hi ha una base de dades oberta de cares etiquetades punt per utilitzar [aquí](http://vis-www.cs.umass.edu/lfw/).

### Per què utilitzar Python per JSON RPC?

Perquè "face_recognition" està escrit en Python i tinc soltesa amb el llenguatge de programació.

### ¿I per què no fer servir Python per a la GUI?

Perquè m'agrada Vala per crear aplicacions d'escriptori en els entorns d'escriptori que ús, principalment elementary OS i altres sistemes operatius basats en Gnome.

### Però anem! Gairebé ningú coneix a Vala!

Ningú impedeix escriure la teva pròpia interfície gràfica sobre `pyfaces` o sobre` face_recognition`.

### M'he adonat que `pyfaces` fa servir el sistema de fitxers per emmagatzemar els detalls. Això és força lent!

És veritat. Però actualment no necessito una mica més complex perquè funcioni. De totes maneres, el _backoffice_ pot usar MongoDB o SQLite per emmagatzemar la informació. Si es manté la compatibilitat amb el client de servidor JSON RPC utilitzat en Vala, és molt possible que això no sigui una feina difícil.

## Sobre l'ètica ...

### Llavors, quin és l'objectiu si la major part de el codi central no és teu?

Tan simple com fer que el reconeixement facial estigui disponible per a qualsevol que faci servir un parell de comandaments usant una rutina d'empaquetat a punt per utilitzar. Per tant, podem crear consciència sobre l'estat de la tecnologia per a qualsevol persona, fins i tot quan s'utilitzen els motors de reconeixement facial disponibles.

### Però, si vols crear consciència, fer públic el codi font no permetria que les persones dolentes facin coses dolentes amb ell?

Aquest és un punt, però aquesta és una forma de fer que la gent sigui conscient del prop que està aquesta tecnologia de nosaltres. No és el futur sinó el present.

### He sentit alguna cosa que els sistemes de reconeixement facial tenen cert biaix racial. No m'agrada implicar-me amb la tecnologia d'aquesta manera!

Tens raó. La tecnologia té algunes problemes i s'ha observat que els models actuals funcionen millor amb persones d'alguns grups ètnics. En el cas de `face_recognition` s'explica el perquè [aquí](https://github.com/ageitgey/face_recognition/wiki/Face-Recognition-Accuracy-Problems#question-face-recognition-works-well-with-european-individuals-but-overall-accuracy-is-lower-with-asian-individuals) i està associat a el conjunt de dades utilitzat per entrenar els models.

## Sobre com es distribueix ...

### Per què Flatpak i no Snap?

Perquè tots dos comparteixen enfocaments d'aïllament d'aplicacions i es poden executar en sistemes GNU / Linux, però Flatpak no està vinculat a un repositori concret com ho fa Canonical amb Snap Store. Hi ha problemes similars als de les botigues centralitzades que ja han implicat a alguns videojocs com [Fortnite] (https://www.youtube.com/watch?v=85Q3D-qIwVw).

### ¿Aquesta aplicació estarà disponible per a sistemes Windows?

De cap manera.

### Per què?

Perquè requereix molta feina mantenir les versions de múltiples sistemes operatius i fer que les coses es compilen de forma creuada.

### Però sóc usuari de Windows i m'agradaria executar l'aplicació. Què puc fer?

Pots executar en un entorn virtualitzat utilitzant VirtualBox o un programa similar si l'eficiència no és un problema per a tu. En qualsevol cas, la comunitat GNU/Linux t'ajudarà en el teu trànsit a entorns d'escriptori i plataformes boniques i flexibles. Si el teu principal raó per a romandre en Windows és la compatibilitat amb Microsoft Office, planteja't si això és una mera coincidència.

### ¿I per a usuaris de MacOS?

El mateix problema. Les mateixes respostes.

### ¿I què hi ha de fer-ho mòbil? Seria genial!

De fet, pot ser mòbil usant telèfons basats en GNU / Linux. Molts projectes estan treballant en això ja com [Pinepphone de Pine64](https://www.pine64.org/pinephone/) i [Librem 5 de Purism](https://puri.sm/products/librem-5/). Dóna'ls una oportunitat.

### Doncs, tinc una sol·licitud per a una nova funcionalitat. On puc proposar-la?

Això és genial! Obre un tiquet nou a la pàgina de el projecte de [Github](https://github.com/febrezo/Facefy/issues).

### Quant de temps trigarà a incloure’s?

Depèn de si hi ha algú que vulgui afrontar-ho. Però cal tenir-ho clar: no esperis que ningú pugui codificar gratuïtament si no necessita la funció.
