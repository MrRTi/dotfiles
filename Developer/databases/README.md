# Local databases

Postgres, MySQL, MongoDB and Redis in Docker, shared by all local projects.

| Service  | Port  | Auth                                      |
| -------- | ----- | ----------------------------------------- |
| postgres | 5432  | `POSTGRES_USER` / `POSTGRES_PASSWORD`     |
| mysql    | 3306  | `root` / `MYSQL_ROOT_PASSWORD`            |
| mongo    | 27017 | `MONGO_ROOT_USER` / `MONGO_ROOT_PASSWORD` |
| redis    | 6379  | none                                      |

All ports bind `127.0.0.1`, so other machines on the network can't reach them.

## Credentials

`fnox.toml` holds 1Password references (vault `env`), not values. They resolve
through a 1Password service account with read-only access to `env` only. Its
token is in `fnox.local.toml`, which isn't in the repo, age-encrypted to a
Secure Enclave key (`~/.config/fnox/age.txt`, made by `age-plugin-se`), so each
run asks for Touch ID once and nothing stays unlocked afterwards. If Touch ID is cancelled, `if_missing = "error"` stops the
command instead of starting containers with blank credentials; fnox reports it
as "No matching keys found".

## Setup

After `chezmoi apply`, trust the task file once and create `fnox.local.toml`
from its template:

```sh
cd ~/Developer/databases
mise trust
cp fnox.local.toml.example fnox.local.toml
fnox -c fnox.local.toml set OP_SERVICE_ACCOUNT_TOKEN --provider age
```

On a new Mac, the Secure Enclave key can't be copied over. Create a new key
with `age-plugin-se keygen -o ~/.config/fnox/age.txt`, put its `age1se1…`
public key in `recipients`, and set the token as above.

## Usage

```sh
mise run run_d            # start all services in the background
mise run run_d postgres   # start one service
mise run run              # start in the foreground
mise run stop [service]   # stop
```

`db-create` and `db-connect` read the same variables, so run them through fnox
from this folder:

```sh
fnox exec -- db-create postgres myapp_dev
```
