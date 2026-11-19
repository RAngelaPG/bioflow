# -----------------------------------------------------------------------------
# Genera portable/renv.lock: la lista EXACTA de versiones que se distribuye.
#
# Ejecutar desde la carpeta portable/ del repo, en Windows, con la MISMA
# version de R que se va a distribuir (la del workflow de GitHub Actions).
#
# - Para actualizar dependencias: cambia `fecha_cran` y/o vuelve a ejecutar
#   (los paquetes de GitHub -cgiarBase, cgiarPipeline, etc.- se toman del
#   commit actual de su rama principal y quedan fijados por su SHA).
# - Prueba la app (bloque final) ANTES de hacer commit del renv.lock.
# -----------------------------------------------------------------------------

fecha_cran <- "2026-11-01"   # snapshot de CRAN; cambiala solo cuando quieras actualizar

options(repos = c(CRAN = sprintf("https://packagemanager.posit.co/cran/%s", fecha_cran)))

# Libreria limpia y aislada (no usa los paquetes que ya tengas instalados)
lib <- file.path(tempdir(), "lib_bioflow")
dir.create(lib, showWarnings = FALSE)
.libPaths(c(lib, .Library))

install.packages(c("pak", "renv"), lib = lib)

# pak resuelve Remotes (GitHub) y Bioconductor automaticamente
pak::pkg_install("Breeding-Analytics/bioflow", lib = lib, upgrade = FALSE)

# Paquetes de compilacion (LinkingTo: cpp11, RcppEigen...). pak los omite al
# instalar binarios, pero renv los exige y GitHub Actions los necesita si
# compila algun paquete desde el codigo fuente.
instalados <- installed.packages(c(lib, .Library))
linking    <- unique(unlist(tools::package_dependencies(
  rownames(installed.packages(lib)), db = instalados, which = "LinkingTo")))
faltantes  <- setdiff(linking, rownames(instalados))
if (length(faltantes)) pak::pkg_install(faltantes, lib = lib, upgrade = FALSE)

# Guarda TODO lo instalado en esa libreria, con versiones y SHAs
renv::snapshot(
  project  = ".",
  library  = c(lib, .Library),   # .Library incluye Matrix, MASS, lattice, nlme...
  lockfile = "renv.lock",
  type     = "all",
  prompt   = FALSE
)

message("renv.lock generado. Prueba la app con esta misma libreria:")
message("  .libPaths(c('", lib, "', .Library)); bioflow::run_app()")
