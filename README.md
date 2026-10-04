# MatosTrek

## En bref

**Ce que c’est :** une archive de prototype de catalogue de matériel de randonnée ultralégère.

**À quoi il sert :** explorer une interface de catalogue et préparer une base de données de fiches produit pour un futur comparateur.

**Ce qui a été réalisé :** interface React autonome, 42 fiches JSON historiques, schéma SQL de référence et scripts d’import conservés pour reprise.

**Technologies :** React, Node.js, SQLite/SQL, JSON et scripts d’import NocoDB.

Le service NocoDB et le comparateur complet ne sont pas livrés. Les designs Claude Design originaux ont été perdus ; la notice le distingue du prototype alternatif conservé.

## Provenance et statut du design

Le plan conservé dans [`docs/history/2026-05-16-bootstrap-plan.md`](docs/history/2026-05-16-bootstrap-plan.md) établit qu'un travail MatosTrek était documenté en mai 2026. Sa copie publique anonymise un chemin local et l'identifiant de la base NocoDB. C'est un plan historique, pas une preuve que toutes ses étapes ont été réalisées. La date de ce plan ne date pas nécessairement chaque fichier de cette archive.

Le propriétaire indique que les fichiers `DESIGN.md` et les exports originaux de Claude Design ont été perdus. Ils ne sont pas reconstitués ici. L'interface dans `App.jsx`, libellée « Big Four Atlas » à l'écran, est un prototype alternatif existant, non retenu comme maquette originale. Ses anciennes captures ont été écartées ; cette publication ne contient aucune capture de remplacement. Les cartes, prix, avantages et affirmations visibles dans cette interface sont codés en dur et ne doivent pas être compris comme une comparaison validée.

## Lancer le prototype

Node.js 20.19+ ou 22.12+ et npm sont requis. L'installation peut demander l'accès au registre npm ; l'interface lancée ne dépend pas de NocoDB.

```sh
npm ci --ignore-scripts
npm run dev -- --port 4183 --strictPort
```

Ouvrir `http://127.0.0.1:4183`. Pour produire un bundle statique :

```sh
npm run build
```

La page affiche six cartes statiques et des emplacements d'image vides. La comparaison interactive, la navigation par marque, les galeries et le chargement des fiches JSON ne sont pas implémentés. Ce prototype ne permet pas de choisir du matériel sur la base d'une comparaison vérifiée.

## Contenu

| Fichier | Rôle | Limite |
|---|---|---|
| `App.jsx`, `index.html` | Interface React/CSS actuelle | Prototype alternatif non retenu ; données à l'écran codées en dur |
| `raw_data/` | 42 JSON, 21 tentes et 21 sacs de couchage, plus une note de champs manquants | Captures historiques ; exactitude et actualité non revérifiées pour cette publication |
| `schema.sql` | Cinq tables logiques SQLite | Référence, pas export de la base NocoDB originale |
| `scripts/` | Imports, synchronisations et migrations anciens | API/identifiants historiques ; exécution non validée |
| `docs/history/` | Plan initial daté du 16 mai 2026 | Document d'intention, pas état livré |

La base originale et les fichiers d'environnement ne sont pas inclus. Les JSON peuvent différer de corrections effectuées dans cette base. Les références URL dans les fiches indiquent les sources relevées alors ; elles n'attestent pas leur contenu actuel.

## Scripts historiques

Les scripts de synchronisation peuvent créer, modifier ou supprimer des lignes NocoDB. Certains remplacent des variantes et des spécifications sans transaction couvrant toute l'opération. Ne les exécuter que sur une base jetable après adaptation et vérification des identifiants, de la version API et des entrées. Aucun de ces scripts n'est lancé par `npm ci`, `dev` ou `build`.

Les scripts Zpacks parcourent un dossier qui mélange tentes et sacs de couchage ; leurs hypothèses sur le format d'entrée demandent une revue avant tout import. `import_tent_images.sh` est conservé comme code historique, sans les images ni autorisation de redistribution des photos fabricant.

Les contrôles réellement effectués pour cette copie sont consignés dans [VERIFICATION.md](VERIFICATION.md).

## Dépôt et téléchargement

[Dépôt public](https://github.com/cpointis96-hue/matostrek) · [Télécharger les sources ZIP](https://github.com/cpointis96-hue/matostrek/archive/HEAD.zip). Aucun binaire ni design Claude original complet n’est inclus.
