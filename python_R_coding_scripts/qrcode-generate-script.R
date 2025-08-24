# Load required libraries
install.packages(c("readr", "qrcode", "grid", "gridExtra", "png", "dplyr"))

library(readr)
library(qrcode)
library(grid)
library(gridExtra)
library(png)
library(dplyr)

# Use own file paths
# Load the dataset
df <- read_csv("C:/Users/annet/Box/barcoding/printed/Office to print/tap_id_barcodes_busiasiaya.csv")

# Load CLEAN logo
logo_path <- "C:/Users/annet/OneDrive/Documents/GitHub/99-test-code/clean_logo.png" 
logo <- rasterGrob(readPNG(logo_path), interpolate = TRUE)

# Output folder
output_dir <- "C:/Users/annet/OneDrive/Documents/GitHub/99-test-code"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Loop through each column in the dataset
for (colname in colnames(df)) {
  ids <- df[[colname]] %>% as.character() %>% na.omit()
  if (length(ids) == 0) next 
  qr_grobs <- list()
  
  for (i in seq_along(ids)) {
    tf <- tempfile(fileext = ".png")
    
    # Generate QR code PNG
    png(tf, width = 300, height = 300)
    qr <- qr_code(ids[i])
    plot(qr)
    dev.off()
    
    # Read image back into R
    img <- readPNG(tf)
    qr_img <- rasterGrob(img)
    
    # Create label
    label <- textGrob(ids[i], gp = gpar(fontsize = 10, fontface = "bold"))
    
    # Combine label + QR + logo
    card <- arrangeGrob(label, qr_img, logo, ncol = 1, heights = c(1, 5, 1.5))
    qr_grobs[[i]] <- card
  }
  
  # Export to PDF (one file per column)
  if (length(qr_grobs) > 0) {
    pdf_path <- file.path(output_dir, paste0(colname, "_QR_Codes.pdf"))
    pdf(pdf_path, width = 8.27, height = 11.69)
    grid.arrange(grobs = qr_grobs, ncol = 3)
    dev.off()
    
    cat("✅ Exported:", pdf_path, "\n")
  }  
}
