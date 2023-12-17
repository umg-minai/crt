# Observational study of central venous catheter-related thrombosis (CRT)

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.10396907.svg)](https://doi.org/10.5281/zenodo.10396907)

We use [guix](https://guix.gnu.org) to ensure an reproducible computing environment.

## Bootstrap

### Guix on debian

```bash
sudo apt install make git guix
```

### Fetch sources

```bash
git clone git@github.com:umg-minai/crt.git
```

## Build manuscript

Running `make` the first time will take some time because
`guix` hast to download the given state and build the image.

```bash
make
```

## Modify the manuscript

All the work has to be done in the `sections/*.Rmd` files.

## Make targets

- `make` or `make manuscript` produces an `.html` file in `output/`.
- `make dist` produces a `.docx` in `distribute/` which could be send to the
  co-authors.
- `make gh-pages` updates the `gh-pages` branch to the latest manuscript.
- `make clean` removes all generated files.

## Update data

If the raw data changed, you have to call `make regenerate-data` manually
(The data file doesn't depend on the raw data to avoid errors if
others who don't own the raw data checkout the repository.)

## Contact/Contribution

You are welcome to:

- submit suggestions and bug-reports at: <https://github.com/umg-minai/crt/issues>
- send a pull request on: <https://github.com/umg-minai/crt/>
- compose an e-mail to: <mail@sebastiangibb.de>

We try to follow:

- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [Semantic Line Breaks](https://sembr.org/)
