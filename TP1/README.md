# R2.06 - TP1: Administation PostgreSQL

## 1. Environnement de travail

> Les identifiants de la VM `NixOS` sont `iut:iut`.

```bash
# On clone le dépôt
git clone https://git.unilim.fr/almonteringau1/R2.06
# On navigue dans le dossier
cd R2.06

# On configure les information sur le commiter avec git
git config user.name "Mikkel RINGAUD"
git config user.email "mikkel.almonteringaud@etu.unilim.fr"
```

Pour accèder à PostgreSQL, on va utiliser le CLI en utilisant la commande `psql`.

## 2. Rôles

### 1.

> Listez les roles.

On peut lister ses rôles en utilisant la commande `\dg`.

```console
iut=# \dg
                                   List of roles
 Role name |                         Attributes                         | Member of 
-----------+------------------------------------------------------------+-----------
 iut       | Superuser                                                  | {}
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 sql_user  |                                                            | {}
```

### 2.

> Vérifiez qui vous êtes.

On peut vérifier qui l'on est en utilisant la commande `\c`.

### 3.

> Créez des rôles nommés `my_role_1`, `my_role_2` et `my_role_3` selon le modèle suivant :
>
> ```sql
> CREATE ROLE my_role_1 LOGIN PASSWORD 'iut1';
> ```

```sql
CREATE ROLE my_role_1 LOGIN PASSWORD 'iut1';
CREATE ROLE my_role_2 LOGIN PASSWORD 'iut1';
CREATE ROLE my_role_3 LOGIN PASSWORD 'iut1';
```

### 4.

> Créez un autre rôle nommé `my_super_role` avec en plus la propriété `SUPERUSER`

```sql
CREATE ROLE my_super_role LOGIN PASSWORD 'iut1' SUPERUSER;
```

### 5.

> Vérifiez que vos nouveaux rôles existent.

```console
iut=# \dg
                                     List of roles
   Role name   |                         Attributes                         | Member of 
---------------+------------------------------------------------------------+-----------
 iut           | Superuser                                                  | {}
 my_role_1     |                                                            | {}
 my_role_2     |                                                            | {}
 my_role_3     |                                                            | {}
 my_super_role | Superuser                                                  | {}
 postgres      | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 sql_user      |                                                            | {}
```

### 6.

> Supprimez le rôle `my_role_3`.

```sql
DROP ROLE my_role_3;
```

### 7.

```console
iut=# \dg
                                     List of roles
   Role name   |                         Attributes                         | Member of 
---------------+------------------------------------------------------------+-----------
 iut           | Superuser                                                  | {}
 my_role_1     |                                                            | {}
 my_role_2     |                                                            | {}
 my_super_role | Superuser                                                  | {}
 postgres      | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 sql_user      |                                                            | {}
```

## 3. Sauvegarde et restauration

Pour sauvegarder les rôles que nous avons crée dans la base de données dans un fichier de "dump", on va utiliser la commande `pg_dumpall` ainsi que l'argument `--roles-only` pour uniquement obtenir un dump des rôles.

```bash
pg_dumpall --roles-only > roles.sql
```


