# Coocook

A modern web application for collecting recipes, creating food plans, and efficiently managing ingredient and shopping lists for groups or individuals.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Main Features](#main-features)
- [Demo and Screenshots](#demo-and-screenshots)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Clone and Setup](#clone-and-setup)
  - [Configuration](#configuration)
  - [Running the Application](#running-the-application)
  - [Running with Docker](#running-with-docker)
- [Usage Examples](#usage-examples)
- [Testing](#testing)
- [Developer Notes](#developer-notes)
- [Terminology](#terminology)
- [Contributing](#contributing)
- [Mailing List](#mailing-list)
- [Author & Contributors](#author--contributors)
- [License](#license)

---

## Project Overview

**Coocook** is an open-source web application that helps users organize recipes, plan meals, generate shopping lists, and more—ideal for families, organizations, or food enthusiasts. It emphasizes simplicity, group collaboration, and automation of repetitive kitchen planning tasks.

---

## Main Features

- **Collect and curate recipes** with flexible ingredient lists and cooking instructions.
- **Plan meals**: Easily schedule dishes into meal plans and adjust quantities for any group size.
- **Automated purchase/shopping lists**: Aggregate ingredients needed from multiple meals, with unit conversions to summarize items for efficient shopping.
- **Print views** for whole projects or per-day plans, including all recipes, ingredients, and instructions.
- **Shelf life & pre-ordering**: Set max shelf life/advance order limits for articles.
- **Prep-ahead cues**: Mark ingredients or steps to be done during earlier meals.
- **Collaboration-ready**: Organize by projects (e.g., family, club, event cooking).
- Designed to be self-hosted, privacy-friendly, and extensible.

---

## Demo and Screenshots

_(Add demo URL and screenshots here if available)_

---

## Getting Started

### Prerequisites

- **Perl 5** (latest recommended) with [cpanm](https://metacpan.org/pod/App::cpanminus)
- **Database**: [SQLite](https://www.sqlite.org/) (default), or [PostgreSQL](https://www.postgresql.org/) (optional for advanced setups)
- UNIX-like Operating System preferred for full support (Windows may have limitations)
- Basic C toolchain (for Perl modules with XS/C-extensions)

##### On Debian/Ubuntu:

```console
sudo apt-get update
sudo apt-get install cpanminus sqlite3 build-essential \
  libssl-dev zlib1g-dev libexpat1-dev libncurses-dev \
  libreadline-dev libpq-dev
```

---

### Clone and Setup

```console
git clone https://gitlab.com/coocook/coocook.git
cd coocook/
```

---

### Configuration

A **database connection** is the only required config for development.

1. **Copy sample configs:**

   ```console
   cp share/examples/dbic.yaml ./
   cp share/examples/coocook.yaml ./
   ```

   - Edit `dbic.yaml` to match your DB location/credentials.
   - Edit `coocook.yaml` for further app-level config if desired.

2. **See also:** default settings in [`lib/Coocook.pm`](lib/Coocook.pm).

---

### Running the Application

#### Native Perl (Recommended for Dev):

1. **Install Perl dependencies:**

   ```console
   cpanm --installdeps .
   # Optionally, also:
   cpanm --installdeps --with-develop --with-recommends --with-suggests .
   ```

2. **Set up the database and start server:**

   ```console
   script/coocook_deploy.pl --connection_name 'development' install
   script/coocook_server.pl --debug
   # (Visit http://0:3000/ in your browser)
   ```

   - Use `--restart` with `coocook_server.pl` for auto-reloading in development (requires `Catalyst::Restarter`).

#### Running with Docker

See [hub.docker.com/r/coocook/coocook-dev](https://hub.docker.com/r/coocook/coocook-dev) for a ready-to-go environment. After pulling the image, follow container startup instructions as per the Docker Hub page.

---

## Usage Examples

- **Add a Recipe:** Use the web interface to enter ingredients, instructions, and categorize the dish.
- **Create a Food Plan:** Drag recipes/dishes onto the calendar or meal plan grid to schedule.
- **Generate Shopping List:** After building a meal plan, click the "purchase list" view to see aggregated, unit-converted ingredients to buy.
- **Print/Export:** Use built-in print views for daily or project-wide cooking.

(To contribute more usage examples, please open a pull request!)

---

## Testing

- Automated test suite available in the `t/` directory.
- Run all tests:

  ```console
  prove -l
  ```

- For specific tests (e.g., deployment, DB, or logic):

  ```console
  perl t/controller_User.t
  ```

---

## Developer Notes

- **Codebase overview:**
  - Major scripts in `script/`
  - Core app logic in `lib/`
  - Frontend templates in `root/templates/`
  - Static assets in `root/static/`
  - Database schema and entity docs: `doc/entities.md`
- **Style and static checks:** See `t/perltidy.t` (style), `t/perlcritic.t` (lint)
- **Utilities:** See `util/perltidy.sh` for formatting.

---

## Terminology

| Name      | Description                                 | Example                        |
| --------- | ------------------------------------------- | ------------------------------ |
| Project   | Self-contained data collection in Coocook   | Paris vacation                 |
| Meal      | Occasion for food on a date                 | Lunch at August 15th           |
| Dish      | Recipe scheduled for a specific meal        | Apple pie for lunch 15 Aug     |
| Recipe    | Scalable template used for dishes           | Apple pie                      |
| Ingredient| Article quantity needed for a dish/recipe   | 1kg of apples                  |
| Article   | Single sort of food (buyable)               | Apples                         |
| Unit      | Measurement type                            | Kilograms                      |

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) (or open an issue for guidance).

- Fork the repo and submit Merge Requests/Pull Requests.
- Check formatting and basic tests before submitting (`prove -l`).
- Join the mailing list to discuss ideas or issues.

---

## Mailing List

- coocook@lists.coocook.org
- Subscribe: [lists.coocook.org/mailman/listinfo/coocook](https://lists.coocook.org/mailman/listinfo/coocook)
- Or email `subscribe` to [coocook-request@lists.coocook.org](mailto:coocook-request@lists.coocook.org?subject=subscribe)

---

## Author & Contributors

- **Author:** Daniel Böhmer (<post@daniel-boehmer.de>)
- **Core Contributors:**
  - [@ChristinaSi](https://github.com/ChristinaSi) Christina Sixtus
  - [@moseschmiedel](https://gitlab.com/moseschmiedel) Mose Schmiedel
  - [@rico-hengst](https://github.com/rico-hengst) Rico Hengst
  - [@kuro610](https://gitlab.com/kuro610) Kurt Roscher
  - [@tjfoerster](https://gitlab.com/tjfoerster) Timon Förster

---

## License

This software is copyright (c) 2015-2023 by Daniel Böhmer.

This web application is free software, licensed under the
[GNU Affero General Public License, Version 3, 19 November 2007](LICENSE).
