# Lanzador de bioflow portable. Lo ejecuta iniciar.bat; no hace falta abrirlo.

.libPaths(c(normalizePath("library"), .Library))   # solo la libreria incluida
options(golem.app.prod = TRUE)

# Pandoc incluido en el zip (necesario para los reportes de rmarkdown)
if (file.exists("pandoc/pandoc.exe")) Sys.setenv(RSTUDIO_PANDOC = normalizePath("pandoc"))

# --- Aviso de version nueva (no instala nada; solo avisa) -------------------
local <- tryCatch(readLines("version.txt", warn = FALSE)[1], error = function(e) "")
api   <- "https://api.github.com/repos/Breeding-Analytics/bioflow/releases/latest"
rel   <- tryCatch(jsonlite::fromJSON(api), error = function(e) NULL)   # sin internet: se omite

if (!is.null(rel) && nzchar(local) && !identical(rel$tag_name, local)) {
  message("\n*** Hay una version nueva de bioflow: ", rel$tag_name,
          " (tienes ", local, ").")
  message("*** Descargala desde: ", rel$html_url, "\n")
  try(utils::browseURL(rel$html_url), silent = TRUE)
}

# --- Iniciar la app ----------------------------------------------------------
bioflow::run_app()   # abre el navegador en http://127.0.0.1:1410
