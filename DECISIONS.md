# Projet XML : observations d'espèces

Mini-projet « Données semi-structurées et XML » (L3 Informatique, Université de Tours).

**Binôme :** BESSAH Rayane, BELHAMRA Mohammed Tahar

Ce document regroupe : (1) la liste des fichiers rendus et la façon de les valider, (2) le contrat de nommage et le jeu de données communs, (3) les choix de conception et leurs justifications, dans l'ordre du barème du sujet.

---

## Fichiers rendus

| Fichier | Rôle | Partie du barème |
|---|---|---|
| `observations_v1.xml` | Première forme de document (au moins 12 observations, descriptions répétées) | 20 % |
| `observations.dtd` | DTD de la première forme | 20 % |
| `observations_v2.xml` | Deuxième forme de document (lieux et espèces décrits une seule fois, puis référencés) | 20 % |
| `observations.xsd` | Schéma XML Schema de la deuxième forme | 40 % |
| `README.md` | Ce document (explications des choix, contrat de nommage, jeu de données) | |

Les quatre fichiers `.xml`, `.dtd` et `.xsd` sont commentés.

## Validation

Avec `xmllint` (libxml2), depuis le dossier contenant les fichiers :

```
# v1 contre la DTD
xmllint --noout --valid observations_v1.xml

# v2 contre le XML Schema
xmllint --noout --schema observations.xsd observations_v2.xml
```

Une validation réussie affiche `... validates` (pour le XSD) ou rien (pour la DTD avec `--noout`).

Hors rendu, nous disposons d'un script `valider.sh` qui lance ces deux validations, et d'un dossier `tests/` contenant des fichiers XML **volontairement invalides** (un par contrainte). Nous en ferons la démonstration à l'oral (voir §4.7).

---

## Contrat de nommage

| Objet | Forme |
|---|---|
| Lieu | `<lieu id="L01">` contenant `nom` puis `position` (`latitude`, `longitude`) |
| Espèce | `<espece id="E01">` contenant `nom` puis `description` |
| Observation | `<observation>` contenant `espece`, `lieu`, `annee`, `nombre`, dans cet ordre |
| Identifiants | lieux : `L` + 2 chiffres ; espèces : `E` + 2 chiffres |
| Noms de balises | en français, minuscules, sans accent (`espece` est imposé par l'énoncé) |
| Fichiers | `observations_v1.xml` + `observations.dtd` (v1) ; `observations_v2.xml` + `observations.xsd` (v2) |

## Jeu de données commun

Les lieux et les espèces proviennent de France. Les espèces sont issues de la liste rouge de l'UICN ([iucnredlist.org](https://www.iucnredlist.org)), qui donne leur statut et leur répartition mais pas d'observations année par année. **Les nombres d'individus sont donc fictifs**, comme l'énoncé le permet. Les coordonnées sont approximatives.

### Espèces (3)

| id | Nom | Statut UICN | Pourquoi ce choix |
|---|---|---|---|
| E01 | Desman des Pyrénées (*Galemys pyrenaicus*) | En danger (EN) | Reclassé « en danger » lors d'une mise à jour de la liste rouge, avec une forte contraction de son aire, dont plus de 60 % dans les Pyrénées françaises. |
| E02 | Gypaète barbu (*Gypaetus barbatus*) | Quasi menacé (NT) | Classé « préoccupation mineure » en 2004, « quasi menacé » depuis 2014. |
| E03 | Bouquetin des Alpes (*Capra ibex*) | Préoccupation mineure (LC) | Espèce réintroduite dans les Alpes, aujourd'hui abondante. |

Trois statuts différents rendent le jeu de données plus parlant à l'oral.

Le contrat n'a pas de balise « statut » : il est écrit dans la balise `<description>`.

| id | Contenu de `<description>` |
|---|---|
| E01 | Petit mammifère semi-aquatique des torrents pyrénéens. Statut UICN : en danger (EN). |
| E02 | Grand rapace charognard qui se nourrit surtout d'os. Statut UICN : quasi menacé (NT). |
| E03 | Ongulé de montagne réintroduit dans les Alpes. Statut UICN : préoccupation mineure (LC). |

### Lieux (3 parcs nationaux)

| id | Nom | latitude | longitude |
|---|---|---|---|
| L01 | Parc national des Pyrénées | 42.85 | -0.15 |
| L02 | Parc national du Mercantour | 44.10 | 7.00 |
| L03 | Parc national de la Vanoise | 45.40 | 6.80 |

Ces lieux sont cohérents avec le gypaète barbu, dont les sites Natura 2000 français incluent la Vanoise, le Mercantour et le cirque de Gavarnie.

### Observations (14)

| Lieu | Espèce | Années | Nombres (fictifs) |
|---|---|---|---|
| L01 | E01 Desman | 2020, 2021, 2022, 2023 | 42, 38, 35, 31 |
| L01 | E02 Gypaète | 2021, 2022, 2023 | 18, 21, 24 |
| L02 | E02 Gypaète | 2022, 2023 | 6, 8 |
| L02 | E03 Bouquetin | 2021, 2022, 2023 | 210, 225, 218 |
| L03 | E03 Bouquetin | 2022, 2023 | 540, 560 |

Total : 4 + 3 + 2 + 3 + 2 = **14 observations**.

Les nombres du desman baissent et ceux du gypaète augmentent, pour que les évolutions année par année racontent quelque chose de réaliste.

---

# Choix de conception et justifications

Cette partie suit le barème du sujet :

| Partie | Sujet | Poids |
|---|---|---|
| 1 | Première forme de document (`observations_v1.xml`) | 20 % |
| 2 | Première DTD (`observations.dtd`) | 20 % |
| 3 | Deuxième forme de document (`observations_v2.xml`) | 20 % |
| 4 | Schéma XML Schema (`observations.xsd`) | 40 % |

Le contrat de nommage commun (balises, identifiants, ordre des éléments) et le jeu de données sont décrits dans les sections « Contrat de nommage » et « Jeu de données commun » ci-dessus. Ici, on explique **pourquoi** on a fait ces choix.

---

## 0. Principes communs aux deux versions

**Un seul vocabulaire.** Les deux versions utilisent les mêmes noms de balises (`observations`, `observation`, `espece`, `lieu`, `nom`, `description`, `position`, `latitude`, `longitude`, `annee`, `nombre`). Ainsi, la v2 est une *restructuration* de la v1 et non un nouveau langage : on peut passer de l'une à l'autre sans changer le sens des données.

**Noms de balises en français, minuscules, sans accent.** Le sujet est en français et `espece` est imposé par l'énoncé. Sans accent, car les accents dans les noms de balises sont permis par XML mais compliquent les outils et les échanges avec des partenaires.

**Même jeu de données.** 3 espèces, 3 lieux, 14 observations (le sujet en demande au moins 12). Les deux versions contiennent exactement les mêmes informations, ce qui permet de les comparer honnêtement (voir §3.4).

**Pourquoi ces données.**
- Les 3 espèces viennent de la liste rouge de l'UICN et ont **3 statuts différents** (EN, NT, LC), ce qui rend le jeu plus parlant à l'oral.
- Les lieux sont 3 parcs nationaux français, cohérents avec la répartition réelle des espèces (par exemple le gypaète barbu en Vanoise, Mercantour et Pyrénées).
- Les nombres d'individus sont **fictifs** : l'UICN donne un statut et une répartition, pas des relevés année par année. L'énoncé autorise de choisir les valeurs librement.
- **Séries temporelles.** L'énoncé exige plusieurs observations de la même espèce dans le même lieu sur des années successives, pour tracer des courbes. C'est le cas pour 5 couples (espèce, lieu) : 4 ans pour le desman à L01, 3 ans pour le gypaète à L01, 2 ans pour le gypaète à L02, 3 ans pour le bouquetin à L02 et 2 ans pour le bouquetin à L03. Les valeurs racontent une histoire plausible : le desman baisse (42 → 31), le gypaète augmente (18 → 24).

---

## 1. Première forme de document : `observations_v1.xml` (20 %)

### 1.1 Structure choisie

Document « à plat » : une racine `<observations>` contenant 14 `<observation>`. Chaque observation contient, dans cet ordre :

```xml
<observation>
  <espece id="E01"> <nom>…</nom> <description>…</description> </espece>
  <lieu id="L01">   <nom>…</nom> <position><latitude>…</latitude><longitude>…</longitude></position> </lieu>
  <annee>2020</annee>
  <nombre>42</nombre>
</observation>
```

### 1.2 Pourquoi cette forme

- **Chaque observation est autonome.** On peut l'extraire, la copier ou l'envoyer à un partenaire sans rien d'autre. C'est la forme la plus simple à produire pour un partenaire (une ligne de relevé = un bloc) et la plus simple à lire.
- **Elle répond directement au sujet** : un lieu est « un identifiant, un nom, une position », une espèce est « un identifiant, un nom, une description », une observation « l'espèce, le lieu, l'année, le nombre ». Chaque observation contient ces quatre informations, sans notion de renvoi.
- **Pas de contrainte d'ordre global** entre lieux, espèces et observations : il n'y a qu'un seul type de bloc à répéter.

### 1.3 Choix de modélisation (valables aussi pour la v2)

| Choix | Justification |
|---|---|
| `id` en **attribut** | Un identifiant est une métadonnée qui désigne l'élément, pas une donnée du domaine. C'est aussi ce qui permettra de le référencer en v2 (`ref`). |
| `nom`, `description`, `annee`, `nombre` en **éléments** | Ce sont des données du domaine. Les éléments restent extensibles (on peut ajouter des sous-éléments plus tard, pas à un attribut). |
| `position` regroupe `latitude` et `longitude` | Les deux valeurs n'ont de sens qu'ensemble. Les regrouper permet de les traiter comme un tout (et de remplacer plus tard `position` par un autre système de coordonnées sans toucher au reste). |
| Latitude/longitude en **degrés décimaux** | Format standard (WGS84), directement exploitable par un outil cartographique, plus simple que degrés/minutes/secondes. Coordonnées approximatives (centre des parcs). |
| Statut UICN dans `<description>` | Le sujet n'impose qu'une « description textuelle ». Une balise `statut` ne figure pas dans le contrat commun ; on l'a donc écrit dans le texte. C'est une limite assumée (voir §4.6). |
| Un commentaire en tête du fichier | Le sujet demande des fichiers *commentés*. Le commentaire annonce que cette version répète volontairement les descriptions et que les nombres sont fictifs. |
| Référence à la DTD via `<!DOCTYPE observations SYSTEM "observations.dtd">` | Le document est validable directement, par `xmllint --valid`. |

### 1.4 Limite de cette forme (le motif de la v2)

Les descriptions sont **répétées** : la description du desman apparaît 4 fois, celle du Parc des Pyrénées 7 fois, etc. Au total, on a 14 descriptions d'espèces et 14 descriptions de lieux pour seulement 3 + 3 informations distinctes. Conséquences :

- **Taille** : plus lourd (voir §3.4).
- **Risque d'incohérence** : si on corrige une description ou une coordonnée, il faut le faire à 4, 7 ou 8 endroits. Une oubliée, et le fichier se contredit, sans que la DTD puisse le détecter.
- **Mise à jour difficile** : pas d'endroit unique où se trouve « la » description d'une espèce.

C'est exactement ce que demande de corriger l'étape 3 du sujet.

---

## 2. Première DTD : `observations.dtd` (20 %)

### 2.1 Contenu

```dtd
<!ELEMENT observations (observation*)>
<!ELEMENT observation (espece, lieu, annee, nombre)>
<!ELEMENT espece (nom, description)>
<!ELEMENT lieu (nom, position)>
<!ELEMENT position (latitude, longitude)>
<!ELEMENT nom (#PCDATA)>  <!-- idem description, latitude, longitude, annee, nombre -->
<!ATTLIST espece id CDATA #REQUIRED>
<!ATTLIST lieu id CDATA #REQUIRED>
```

### 2.2 Choix et justifications

**Séquences ordonnées (`,`) et non choix (`|`).** L'ordre `espece, lieu, annee, nombre` est fixé par le contrat de nommage. Un ordre unique simplifie la production et la lecture par tous les partenaires, et une DTD sait très bien l'imposer.

**`observation*` à la racine.** Une collection d'observations peut légitimement être vide (un partenaire qui n'a encore rien relevé). Choix plus tolérant que `observation+`, assumé : le *minimum de 12 observations* est une exigence du **jeu de données de l'exercice**, pas une règle du langage d'échange. (Le XSD de la v2 est plus strict sur ce point, voir §4.3.)

**`#PCDATA` pour tous les éléments feuilles.** Une DTD ne sait pas typer le texte : tout est « du texte ». C'est un choix subi, pas voulu (voir limites).

**`id` : `CDATA #REQUIRED` et non `ID`.** C'est le choix le plus important de la DTD, et il est volontaire :
- Le type `ID` impose que la valeur soit **unique dans tout le document**.
- Or, en v1, `<espece id="E01">` apparaît 4 fois avec le *même* identifiant (une fois par observation). Avec `ID`, le document serait **invalide**.
- On utilise donc `CDATA` (texte libre), et `#REQUIRED` oblige au moins à fournir l'identifiant.

L'`id` sert ici à *reconnaître* qu'une description est celle de la même espèce ou du même lieu, pas à garantir l'unicité.

**Attributs déclarés séparément (`ATTLIST`).** Un `ATTLIST` par élément porteur d'attribut : lisible et conforme à la syntaxe DTD.

**Ordre des déclarations.** On déclare du plus général au plus particulier (racine, observation, puis éléments composés, puis feuilles). Cela se lit comme un plan du document.

### 2.3 Ce que la DTD ne sait pas faire (et pourquoi on passe à XML Schema)

| Besoin | Pourquoi la DTD ne peut pas |
|---|---|
| `annee` est un entier à 4 chiffres, `nombre` un entier ≥ 0 | Pas de types de données : tout est `#PCDATA`. `<nombre>beaucoup</nombre>` est accepté. |
| Latitude entre -90 et 90 | Pas de bornes de valeurs. |
| Identifiant de la forme `L01` / `E01` | Pas de motif (`CDATA` accepte n'importe quoi). |
| Unicité des identifiants, intégrité des références | Seul `ID`/`IDREF` existe, et il est inutilisable en v1 (voir ci-dessus). |
| Texte non vide | Un élément `#PCDATA` peut être vide. |
| Même nom d'élément avec deux contenus selon le contexte (v2) | Une DTD déclare **un seul** contenu par nom d'élément, globalement. C'est le point décisif pour l'étape 3 : `lieu` et `espece` ne peuvent pas être à la fois « description » et « référence » dans une même DTD. |

Ce dernier point justifie aussi que le sujet demande un **XML Schema** pour la seconde version, et non une seconde DTD.

---

## 3. Deuxième forme de document : `observations_v2.xml` (20 %)

### 3.1 Structure choisie

Le document est organisé en **trois blocs** sous la racine, dans cet ordre :

1. les `<lieu>` : chacun décrit une seule fois (`id`, `nom`, `position`) ;
2. les `<espece>` : chacune décrite une seule fois (`id`, `nom`, `description`) ;
3. les `<observation>` : qui ne contiennent plus que des **renvois** :

```xml
<observation>
  <espece ref="E01"/>
  <lieu ref="L01"/>
  <annee>2020</annee>
  <nombre>42</nombre>
</observation>
```

### 3.2 Réponse à la contrainte du sujet

> « ne renseigner qu'une seule fois la description d'un lieu et une seule fois la description d'une espèce, en utilisant les noms d'élément `<lieu>` et `<espece>` à la fois pour décrire … et pour mentionner … dans une observation. »

- **Une seule fois** : 3 descriptions de lieux et 3 descriptions d'espèces, jamais répétées.
- **Mêmes noms d'éléments** : `<lieu id="L01">…</lieu>` (description, contient `nom` et `position`) et `<lieu ref="L01"/>` (mention, élément vide). Idem pour `espece`.
- **Distinction description / mention** : par l'attribut. `id` = « je définis », `ref` = « je renvoie à ». Le nom d'attribut dit clairement le rôle, et un renvoi est un **élément vide** : on ne peut pas y recopier une description par erreur.

### 3.3 Choix de conception

| Choix | Justification |
|---|---|
| Renvoi par **attribut `ref`** portant l'identifiant | Mécanisme classique (clé / référence), vérifiable par un schéma (voir §4.4). |
| Lieux, puis espèces, puis observations | Une référence est écrite **après** ce qu'elle désigne : le fichier se lit de haut en bas sans avance. Ordre imposé aussi par le schéma pour que tous les partenaires produisent la même forme. |
| On **garde** `espece, lieu, annee, nombre` dans l'observation | Même ordre qu'en v1, donc passage v1 → v2 mécanique. |
| Commentaires de section dans le fichier | Le sujet demande des fichiers commentés ; ils annoncent les trois blocs. |
| Pas de DTD en v2 | Impossible : une DTD ne peut pas donner deux contenus au même nom d'élément (voir §2.3). Le fichier déclare son schéma par `xsi:noNamespaceSchemaLocation="observations.xsd"`. |
| Pas d'espace de noms (namespace) cible | Projet à un seul vocabulaire, interne au binôme : un namespace alourdirait sans bénéfice. Un vrai échange entre partenaires en demanderait un (voir §4.6). |

### 3.4 Comparaison v1 / v2

| | v1 (à plat) | v2 (référencée) |
|---|---|---|
| Descriptions d'espèces | 14 | **3** |
| Descriptions de lieux | 14 | **3** |
| Taille du fichier | ≈ 6,9 Ko | ≈ 3,3 Ko (**environ 2 fois plus petit**) |
| Correction d'une description | jusqu'à 8 endroits | **1 endroit** |
| Risque de contradiction interne | oui, non détectable | **supprimé** |
| Observation autonome | oui | non : il faut le fichier entier pour la lire |
| Lecture / production | plus simple | demande de gérer des identifiants |

La v2 est meilleure pour **stocker et maintenir** des données ; la v1 pour **extraire ou transmettre** une observation isolée. Pour un partenaire qui envoie un lot complet, la v2 est le bon choix ; pour un échange unitaire, la v1 reste utilisable.

---

## 4. Schéma XML Schema : `observations.xsd` (40 %)

C'est la partie la plus importante du barème ; elle est donc détaillée. Le sujet demande d'« exploiter les capacités de XML Schema à décrire les types des valeurs » et d'ajouter les contraintes pertinentes, « comme des personnes sachant ce que gérer des données veut dire ».

### 4.1 Architecture : types nommés, éléments à la fin

Le schéma est construit en trois étages :
1. **Types simples** (restrictions de types prédéfinis) ;
2. **Types complexes** nommés (réutilisables) ;
3. **Un seul élément global** : la racine `observations`, avec ses contraintes d'intégrité.

On a choisi des **types nommés** plutôt qu'imbriqués (« Russian doll ») : chaque type a un rôle clair, est testable séparément et peut être réutilisé (par exemple `PositionType` pourrait servir ailleurs). Seule la racine, qui est un cas unique, a un type anonyme.

Les éléments internes sont des **déclarations locales** et non globales : seul `observations` peut être racine d'un document. Un fichier dont la racine serait `lieu` est refusé.

### 4.2 Types simples : pourquoi chaque restriction

| Type | Base | Restriction | Justification |
|---|---|---|---|
| `IdLieu` | `xs:string` | motif `L[0-9]{2}` | Impose le contrat de nommage (`L` + 2 chiffres). Rejette `l1`, `L001`, `X01`. |
| `IdEspece` | `xs:string` | motif `E[0-9]{2}` | Idem pour les espèces. Deux types distincts : **impossible de référencer un lieu à la place d'une espèce** (`<espece ref="L01"/>` est refusé). |
| `Texte` | `xs:string` | `minLength = 1` | Un nom ou une description vide n'a aucun sens. |
| `Latitude` | `xs:decimal` | -90 à 90 | Bornes géographiques réelles. `decimal` (et non `double`) : valeurs exactes en base 10, sans notation scientifique ni `NaN`/`INF`. |
| `Longitude` | `xs:decimal` | -180 à 180 | Idem. |
| `Annee` | `xs:integer` | 1900 à 2100 | Une année est un entier, pas une date. Bornes larges : on rejette les fautes de frappe (`20201`, `0202`) sans bloquer d'éventuelles données historiques. |
| `nombre` | `xs:nonNegativeInteger` | (type prédéfini) | Un nombre d'individus est un entier **≥ 0**. `0` est accepté volontairement : « observé, aucun individu vu » est une information utile pour une espèce en danger, à ne pas confondre avec « pas d'observation ». |

On a préféré `xs:integer` à `xs:gYear` pour `annee` : `integer` se compare et se trie directement, ce qui sert pour tracer des courbes.

### 4.3 Types complexes et structure

- **`PositionType`, `LieuType`, `EspeceType`** : des `xs:sequence` (ordre imposé, comme dans la DTD), avec l'attribut `id` obligatoire (`use="required"`) typé `IdLieu` / `IdEspece`.
- **`LieuRefType`, `EspeceRefType`** : types *sans contenu*, avec un seul attribut `ref` obligatoire. Un renvoi est donc **forcément un élément vide** : on ne peut pas y glisser de description.
- **`ObservationType`** : `espece, lieu, annee, nombre` en séquence, l'espèce et le lieu étant du type *renvoi*.
- **La racine** : séquence `lieu+`, `espece+`, `observation+` (`minOccurs="1"`, `maxOccurs="unbounded"`). Un fichier doit contenir au moins un lieu, une espèce et une observation. C'est plus strict que la DTD (`observation*`), car en v2 un document sans aucune donnée n'a pas d'intérêt.

### 4.4 L'élément clé : le même nom pour deux sens (`lieu` et `espece`)

C'est la difficulté demandée par le sujet. XML Schema la résout par les **déclarations locales** :

- Dans `observations` : `<xs:element name="lieu" type="LieuType">` (description).
- Dans `observation` : `<xs:element name="lieu" type="LieuRefType">` (renvoi).

Un même nom avec deux types différents est permis parce que les deux déclarations sont dans des **contextes (parents) différents**. C'est exactement ce que la DTD ne permettait pas. Le validateur choisit le bon type selon l'endroit où l'élément apparaît.

### 4.5 Contraintes d'intégrité (le cœur du schéma)

Placées sur l'élément racine, elles apportent ce que `ID`/`IDREF` d'une DTD ne pouvait pas offrir.

1. **`xs:key` `cleLieu` et `cleEspece`** : unicité **et** présence des identifiants. Deux lieux avec `id="L01"` sont refusés, et un `id` manquant aussi (une `key` l'exige, contrairement à `unique`).

2. **`xs:keyref` `refLieu` et `refEspece`** : **intégrité référentielle**. Chaque `<lieu ref="…"/>` d'une observation doit désigner un `<lieu id="…">` existant. Une observation qui renvoie à `L09` inexistant est refusée.

3. **`xs:unique` `uniqueObservation`** : un seul relevé par triplet **(espèce, lieu, année)**. Sinon, deux valeurs contradictoires pour le même point de la courbe d'évolution (par exemple deux nombres pour le desman à L01 en 2021).

**Pourquoi `key`/`keyref` plutôt que `xs:ID`/`xs:IDREF` ?**
- `xs:ID` et `xs:IDREF` partagent un **espace de noms unique** dans tout le document : un lieu `L01` et une espèce `E01` doivent être distincts entre eux, et surtout ils ne distinguent pas la *nature* de la cible. Un `IDREF` peut pointer vers n'importe quel `ID`, y compris un lieu là où on attend une espèce.
- `key`/`keyref` ciblent **un ensemble précis** (`lieu` pour `refLieu`, `espece` pour `refEspece`), avec un XPath explicite.
- `xs:ID` impose aussi le format NCName (pas de motif libre), alors que nos types `IdLieu`/`IdEspece` sont plus précis.

### 4.6 Choix assumés, limites et pistes d'amélioration

Par honnêteté, voici ce que le schéma **ne fait pas** et pourquoi.

| Limite | Explication / piste |
|---|---|
| Année « pas dans le futur » | XSD 1.0 ne peut pas comparer à la date du jour. XSD 1.1 le permettrait avec `xs:assert`, mais `xmllint` ne gère que XSD 1.0. On a donc retenu des bornes fixes (1900 à 2100). |
| « Plusieurs années successives » pour chaque série | Exigence de l'énoncé sur le **jeu de données**, pas une règle de structure : un schéma ne peut pas imposer qu'un couple (espèce, lieu) ait au moins deux années consécutives. Elle est respectée dans nos données (voir §0). |
| Format `L` + 2 chiffres : maximum 99 lieux et 99 espèces | Choix de simplicité fixé par le contrat de nommage. Passer à `L[0-9]+` suffirait si le volume augmentait. |
| `Texte` accepte une chaîne d'espaces seulement | On pourrait ajouter un motif `\S.*` ou `xs:whiteSpace collapse`. Non fait, pour rester lisible. |
| Statut UICN noyé dans `description` | En production, on ajouterait un attribut `statut` énuméré (`EX, EW, CR, EN, VU, NT, LC, DD`) avec `xs:enumeration` : c'est là que XSD brille. Non fait ici, car le contrat commun du binôme ne le prévoit pas. |
| Pas d'espace de noms cible | Voir §3.3. Pour un standard d'échange réel, on définirait un `targetNamespace`. |
| Pas de cohérence d'unité ni de méthode de comptage | Dépasse le cadre « simple » demandé. |
| Les lieux/espèces non référencés sont acceptés | Une description qu'aucune observation n'utilise est permise (le catalogue peut être plus large que les observations). |

### 4.7 Vérification : comment on sait que ça marche

- La v1 est validée contre la DTD (`xmllint --noout --valid`) et la v2 contre le XSD (`xmllint --noout --schema`), voir la section « Validation » en tête de ce document. Notre script `valider.sh` lance ces deux validations.
- Notre dossier `tests/` contient des fichiers **volontairement invalides** (un par contrainte : id mal formé, latitude hors bornes, `nombre` négatif, référence inexistante, identifiant dupliqué, observation en double…). Le script vérifie que chacun est **refusé** ; il signale un « PROBLÈME » si l'un passe. Un schéma qui n'a jamais rejeté de document n'est pas prouvé : ces tests montrent que chaque contrainte *mord* vraiment.
- Ces deux éléments ne font pas partie des fichiers rendus (limite de 5 fichiers) ; nous en ferons la démonstration à l'oral.

---

## 5. Synthèse : de la v1 à la v2

| Étape | Apport | Problème résolu | Problème restant |
|---|---|---|---|
| v1 + DTD | Structure et ordre validés, simple | Document bien formé et correctement structuré | Données répétées, aucun typage, pas de contrôle de cohérence |
| v2 + XSD | Aucune répétition, types, bornes, clés, références, unicité | Redondance, valeurs absurdes, références cassées, doublons | Règles métier fines (statut énuméré, année ≤ aujourd'hui) |

**Idée à retenir** : la v1 est facile à écrire mais fragile, car elle répète et ne vérifie que la forme. La v2 impose une discipline (identifiants, références), et XML Schema permet de la **vérifier automatiquement**. C'est le passage d'un document « qui a la bonne forme » à des données « dont on peut se servir ».
