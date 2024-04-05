## 2. Création des tables

### 2.

> Définissez la variable d'environnement `DATABASE_URL`.

```bash
export DATABASE_URL="postgres://sql_user:iut@localhost/iut"
```

### 3.

> Créez la migration initiale

```bash
sqlx migrate add create_blog_schema
```

### 4.

> Dans le fichier [`./migrations/YYYYMMDDHHMMSS_create_blog_schema.sql`](./migrations/20240405081615_create_blog_schema.sql) ainsi créé, écrivez le code SQL pour créer le schéma `blog` et la table `articles` suivante :
> | Colonne | Type | Collationnement | NULL-able |
> | ------- | ---- | --------------- | --------- |
> | `article_id` | `integer` | | not null |
> | `author` | `text` | | |
> | `title` | `text` | | not null |
> | `body` | `text` | | |
> 
> ```console
> Index :
>     "articles_pkey" PRIMARY KEY, btree (article_id)
> ```

```sql
CREATE SCHEMA blog;

CREATE TABLE blog.articles (
    article_id SERIAL PRIMARY KEY,
    author TEXT,
    title TEXT NOT NULL,
    body TEXT
);
```

### 5.

> Une fois que votre code SQL est prêt, lancez la migration.

```bash
sqlx migrate run
```

### 6.

> Relancez la migration.

Rien ne se passe, et vous n'avez pas d'erreur non plus.

Le système de migrations est *idempotent*.

### 7.

> Pour voir la différence, réexécutez ce code avec `psql < ./migrations/*_create_blog_schema.sql`

```console
ERROR:  schema "blog" already exists
ERROR:  relation "articles" already exists
```

### 8.

> Dans votre fichier SQL, ajoutez une colonne `provisoire` de type `TEXT` à la table `blog.articles`.

```sql
CREATE TABLE blog.articles (
    article_id SERIAL PRIMARY KEY,
    author TEXT,
    title TEXT NOT NULL,
    body TEXT,
    provisoire TEXT
);
```

### 9.

> Relancez la migration avec `sqlx migrate run`.

On a une erreur car les migrations ne sont pas modifiables.

### 10.

> Remettez votre fichier SQL dans l'état où il était lors de la migration (i.e. sans la colonne `provisoire`).

```sql
CREATE TABLE blog.articles (
    article_id SERIAL PRIMARY KEY,
    author TEXT,
    title TEXT NOT NULL,
    body TEXT
);
```

### 11.

> Relancez la migration : cela doit fonctionner.

```bash
sqlx migrate run
```

### 12.

> Pour éviter tout ennui, retirez-vous le droit d'écrire dans le fichier de migration.

```bash
chmod -w ./migrations/*_create_blog_schema.sql
```

## 3. Insertion

### 1.

> Créez un fichier `insert_blog_data.sql`.

*Voir [`insert_blog_data.sql`](./insert_blog_data.sql).*

### 2.

> Ecrivez-y le code SQL insérant en une fois dans la table `articles` les valeurs du tableaux ci-dessous.
> 
> | `article_id` | `title` | `body` | `author` |
> | ------------ | ------- | ------ | -------- |
> | ... | Disparition de Tux | La planète Linux est en alerte. | Linus |
> | ... | La blague du jour | Windows 11. | Tux |
> | ... | Météo | Sale temps sur Seattle. | |
> | ... | Editorial | | Richard |

```sql
INSERT INTO blog.articles (title, body, author) 
VALUES 
    ('Disparition de Tux', 'La planète Linux est en alerte.', 'Linus'),
    ('La blague du jour', 'Windows 11.', 'Tux'),
    ('Météo', 'Sale temps sur Seattle.', NULL),
    ('Editorial', NULL, 'Richard');
```

### 3.

> Une fois que votre code SQL est prêt, soumettez-le au serveur.

```console
$ psql < ./insert_blog_data.sql
INSERT 0 4
```

### 4.

> Vérifiez le contenu de votre table.

On va dans `psql`.

```console
iut=# SELECT * from blog.articles;
 article_id | author  |       title        |              body               
------------+---------+--------------------+---------------------------------
          1 | Linus   | Disparition de Tux | La planète Linux est en alerte.
          2 | Tux     | La blague du jour  | Windows 11.
          3 |         | Météo              | Sale temps sur Seattle.
          4 | Richard | Editorial          | 
(4 rows)
```

On trouve bien nos 4 articles.

### 5.

> Essayez d'insérer un article sans tire.

Toujours dans `psql`.

```console
iut=# INSERT INTO blog.articles (title, body, author) VALUES (NULL, 'Mikkel', 'Un article sans titre !');
ERROR:  null value in column "title" of relation "articles" violates not-null constraint
DETAIL:  Failing row contains (5, Un article sans titre !, null, Mikkel).
```

On obtient une erreur car la valeur du titre est `NULL`.

## 4. Migration

