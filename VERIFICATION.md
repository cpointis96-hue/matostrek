# Vérification de cette archive

Les contrôles ci-dessous portent sur le snapshot public du 4 octobre 2026. Ils n'exécutent aucun import et ne contactent pas NocoDB.

| Contrôle | Résultat | Portée |
|---|---|---|
| `npm ci --offline --ignore-scripts` | Réussi, 17 paquets installés depuis le cache | Installation depuis le lockfile, sans scripts ni réseau |
| `npm run build` | Réussi, Vite 7.3.6, 22 modules transformés | Compilation du prototype statique uniquement |
| Lecture avec `JSON.parse` | 42 fichiers JSON valides | Syntaxe, pas véracité des données |
| `sqlite3 :memory: '.read schema.sql' '.tables'` | Cinq tables créées : `brands`, `sleeping_bags`, `tent_specs_extra`, `tent_variants`, `tents` | Syntaxe du schéma, pas compatibilité NocoDB |
| `node --check` sur les deux `.mjs` et `bash -n` sur les quatre `.sh`, fichier par fichier | Réussi | Syntaxe, sans import ni effet sur la base |

La comparaison interactive, les galeries, la navigation par marque, les imports NocoDB, les prix et spécifications historiques ne sont pas validés. La présence des commandes dans cette notice ne constitue pas une validation de ces fonctions.

Les fichiers `DESIGN.md` et exports Claude Design originaux sont déclarés perdus par le propriétaire. Aucune capture du prototype alternatif n'est publiée comme preuve de leur contenu.
