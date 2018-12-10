## CLEAN DATA SET

## settings
## check your RStudio working dictionary
## getwd()

## if you want to change working dictionary use setwd() function

## copy your data set named all_summary.csv to this folder
## you can add some additional folder inside and put file there
## remember about correcting file path

file_path <- paste(getwd(), "all_summary.csv", sep = "/");

## libraries
library(dplyr);

## Load initial data
initial_data <- read.csv(file_path, sep=";", header = TRUE, stringsAsFactors = FALSE, comment.char = "", nrows = 100);

## get all names of columns
columns_names <- colnames(initial_data);

## remove initial data from memeory
rm(initial_data);

## define ours column names
available_columns_names <- c("title", "pdb_code", "res_name", "res_id", "chain_id",
                             "local_BAa", "local_NPa", "local_Ra", "local_RGa", "local_SRGa",
                             "local_CCSa", "local_CCPa", "local_ZOa", "local_ZDa", "local_ZD_minus_a",
                             "local_ZD_plus_a", "local_res_atom_count", "local_res_atom_non_h_count", "local_res_atom_non_h_occupancy_sum", "local_res_atom_non_h_electron_sum",
                             "local_res_atom_non_h_electron_occupancy_sum", "local_res_atom_C_count", "local_res_atom_N_count", "local_res_atom_O_count", "local_res_atom_S_count",
                             "dict_atom_non_h_count", "dict_atom_non_h_electron_sum", "dict_atom_C_count", "dict_atom_N_count", "dict_atom_O_count",
                             "dict_atom_S_count", "blob_electron_sum", "blob_volume_sum", "blob_parts", "shape",
                             "density", "O3", "O4", "O5", "FL",
                             "I1", "I2", "I3", "I4", "I5",
                             "I6", "M000", "E1", "E2", "E3",
                             "norm", "scaled", "local_volume", "local_electrons", "local_mean",
                             "local_std", "local_min", "local_max", "local_skewness", "local_parts",
                             "TwoFoFc_mean", "TwoFoFc_std", "TwoFoFc_square_std", "TwoFoFc_min", "TwoFoFc_max", 
                             "Fo_mean", "Fo_std", "Fo_square_std", "Fo_min", "Fo_max",
                             "FoFc_mean", "FoFc_std", "FoFc_square_std", "FoFc_min FoFc_max", "Fc_mean",
                             "Fc_std", "Fc_square_std", "Fc_min", "Fc_max", "fo_col",
                             "fc_col", "weight_col", "grid_space", "solvent_radius", "solvent_opening_radius",
                             "resolution", "solvent_mask_count", "void_mask_count", "modeled_mask_count", "solvent_ratio",
                             "TwoFoFc_bulk_mean", "TwoFoFc_bulk_std", "TwoFoFc_void_mean", "TwoFoFc_void_std", "TwoFoFc_modeled_mean",
                             "TwoFoFc_modeled_std", "Fo_bulk_mean", "Fo_bulk_std", "Fo_void_mean", "Fo_void_std",
                             "Fo_modeled_mean", "Fo_modeled_std", "Fc_bulk_mean", "Fc_bulk_std", "Fc_void_mean",
                             "Fc_void_std", "Fc_modeled_mean", "Fc_modeled_std", "FoFc_bulk_mean", "FoFc_bulk_std",
                             "FoFc_void_mean", "FoFc_void_std", "FoFc_modeled_mean", "FoFc_modeled_std", "TwoFoFc_void_fit_binormal_mean1",
                             "TwoFoFc_void_fit_binormal_std1", "TwoFoFc_void_fit_binormal_mean2", "TwoFoFc_void_fit_binormal_std2", "TwoFoFc_void_fit_binormal_scale", "TwoFoFc_solvent_fit_normal_mean",
                             "TwoFoFc_solvent_fit_normal_std", "part_step_FoFc_std_min", "part_step_FoFc_std_max", "part_step_FoFc_std_step"); 

part_columns_names <- columns_names[starts_with("part_", ignore.case = TRUE, columns_names)];

project_columns_names <- c(tolower(available_columns_names), tolower(part_columns_names));
project_columns_names <- columns_names[which(tolower(columns_names) %in% project_columns_names)];

## get ALL data from file
raw_data <- read.csv(file_path, sep=";", header = TRUE, stringsAsFactors = FALSE, comment.char = "", nrows = 600000);

## get only data with attributes from project 
selected_data <- select(raw_data, project_columns_names);

## remove raw_data from memory
rm(raw_data);

## res_name to be deleted
res_names_to_deleted <- c("UNK", "UNX", "UNL", "DUM", "N",
                          "BLOB", "ALA", "ARG", "ASN", "ASP",
                          "CYS", "GLN", "GLU", "GLY", "HIS",
                          "ILE", "LEU", "LYS", "MET", "MSE",
                          "PHE", "PRO", "SEC", "SER", "THR",
                          "TRP", "TYR", "VAL", "DA", "DG",
                          "DT", "DC", "DU", "A","G",
                          "T", "C", "U", "HOH", "H20", "WAT");

filtered_data <- filter(selected_data, !(res_name %in% res_names_to_deleted));

## remove selected_data from memory
rm(selected_data);

## missing values
check_na_values <- sapply(filtered_data, function(x) { if (sum(is.na(x)) == nrow(filtered_data)) { TRUE } else { FALSE } });

## column weight_col has only NAs values so all data set would be deleted
filtered_data$weight_col <- 0;

## remove rest of missing values
clean_data <- na.omit(filtered_data);

## remove filtered_data from memory
rm(filtered_data);

## and others unnecessary variables
rm(columns_names);
rm(available_columns_names);
rm(part_columns_names);
rm(project_columns_names);
rm(res_names_to_deleted);
rm(check_na_values);
rm(file_path);

## SAVE ENVIRONMENT
save(clean_data, file = "CleanData.RData");