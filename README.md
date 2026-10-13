# Projet XML : observations d'espèces

Mini-projet « Données semi-structurées et XML » (L3 Informatique, Université de Tours).

**Binôme :** BESSAH Rayane, BELHAMRA Mohammed Tahar
**Rendu :** Celene, avant le 18/10/2026 à minuit. **Oral :** 19/10/2026.

## Arborescence

```
projet-xml/
├── v1/      observations_v1.xml, observations.dtd
├── v2/      observations_v2.xml, observations.xsd
├── tests/   fichiers XML volontairement invalides
├── DECISIONS.md
├── valider.sh
└── README.md
```

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