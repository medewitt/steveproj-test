log_info("Starting Analysis")
Data <- readRDS("data/Data.rds")


# building models ---------------------------------------------------------
Mods <- list()
log_info("Running Models")

Mods$"Default" <- lm(immigsent ~ agea + female + eduyrs + uempla + hinctnta + lrscale, data=Data)
Mods$"Default + Noise" <- lm(immigsent ~ agea + female + eduyrs + uempla + hinctnta + lrscale + noise, data=Data)


# models completed --------------------------------------------------------

log_info("Models Completed")

saveRDS(Mods, "data/Mods.rds")
