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

Pour sauvegarder les rôles que nous avons crée dans la base de données dans un fichier de "dump", on va utiliser la commande `pg_dumpall` ainsi que l'argument `--roles-only` pour uniquement obtenir un dump des rôles :
```bash
pg_dumpall --roles-only > roles.sql
```

Pour importer dans la base de données à partir d'un fichier, on peut utiliser cette commande (en passant le fichier `.sql`) :
```bash
psql < roles.sql
```

## 4.1 Création de base de données 

### 1.

> Basculez sur le rôle `my_role_1`

```
\c - my_role_1
```

### 2.

> Listez les bases de données.

```console
iut=> \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 iut       | iut      | UTF8     | fr_FR.utf8 | fr_FR.utf8 | =Tc/iut              +
           |          |          |            |            | iut=CTc/iut          +
           |          |          |            |            | sql_user=CTc/iut
 postgres  | postgres | UTF8     | fr_FR.utf8 | fr_FR.utf8 | 
 template0 | postgres | UTF8     | fr_FR.utf8 | fr_FR.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | fr_FR.utf8 | fr_FR.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)
```

### 3.

> Essayez de créer une base de données `my_database_1`. Que se passe t-il ?

```console
iut=> CREATE DATABASE my_database_1;
ERROR:  permission denied to create database
```

On a pas la permission de créer la base de données.

### 4.

> Basculez sur le rôle `my_super_role`.

```
\c - my_super_role
```

### 5.

> Essayez de créer une base de données `my_database_1`. Que se passe t-il ?

```sql
CREATE DATABASE my_database_1;
```

La base de données est crée sans aucun problème.

### 6.

> Basculez sur le rôle `my_role_2`.

```
\c - my_role_2
```

### 7.

> Essayez de créer une base de données `my_database_2`. Que se passe t-il ?

```console
iut=> CREATE DATABASE my_database_2;
ERROR:  permission denied to create database
```

On a pas les droits non plus de créer la base de données.

### 8.

> Basculez sur le rôle `my_super_role` et ajoutez la propriété `CREATEDB` à `my_role_2` :
> ```sql
> ALTER ROLE my_role_2 CREATEDB;
> ```

```console
iut=> \c - my_super_role
You are now connected to database "iut" as user "my_super_role".
```

```sql
ALTER ROLE my_role_2 CREATEDB;
```

On vient de donner les droits de création de base de données au rôle `my_role_2`.

### 9.

> Basculez sur le rôle `my_role_2`.

```console
iut=# \c - my_role_2
You are now connected to database "iut" as user "my_role_2".
```

### 10.

> Essayez de créer une base de données `my_database_2`. Que se passe-t-il ?

```sql
CREATE DATABASE my_database_2;
```

La base de données est créée avec succès.

## 4.2 Propriété des base de données

### 1.

> Vérifiez l'état des bases de données.

### 2.

> Qui est le propriétaire de la base `my_database_1`

### 3.

> Basculez sur le rôle `my_super_role`.

### 4.

> Changez le propriétaire de `my_database_1` en `my_role_1`.

### 5.

> Créez une copie de la base `my_database_2`, appelée `my_database_2_bis` :
> ```sql
> CREATE DATABASE my_database_2_bis WITH TEMPLATE my_database_2;
> ```

### 6.

> Qui est le propriétaire de la copie ?

### 7.

> Renommez la base `my_database_2_bis` en `my_database_3`.

### 8.

> Vérifiez l'état des bases de données.

### 9.

> Supprimez la base `my_database_3`.

### 10.

> Vérifiez l'état des bases de données.

## 4.3 Permissions des bases de données

### 1.

> Basculez sur le rôle `my_role_1` dans la base `my_database_2`.

### 2.

> Essayez de créer un schéma `my_schema_1` dans la base `my_database_2`. Que se passe-t-il ?


