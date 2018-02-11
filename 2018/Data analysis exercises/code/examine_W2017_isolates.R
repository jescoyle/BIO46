# Exploring BIO46 W2017 isolates

fungi <- read.csv("data/BIO46_W2017_fungi.csv")

library(tidyr)
library(dplyr)
library(ggplot2)

isolates <- fungi %>%
  select(-ITS_sequence) %>% # drop the ITS_sequence column
  filter(TaxonID != "") # filter to rows whose TaxonID is not ""


taxa <- isolates %>%
  group_by(TaxonID) %>%
  summarise(num_isolates = n(),
            num_lichens = length(unique(LichenID)),
            growth_mean = mean(Growth_rate_mm_day, na.rm =TRUE),
            growth_sd = sd(Growth_rate_mm_day, na.rm =TRUE)
  )

replicate_taxa <- taxa %>%
  filter(num_lichens > 2) 


replicate_isolates <- isolates %>%
  filter(TaxonID %in% replicate_taxa$TaxonID) %>%
  
  
  
  
  
ggplot(replicate_isolates, aes(x = TaxonID, y = Growth_rate_mm_day)) +
  geom_bar(data = replicate_taxa, aes(y = growth_mean), stat = "identity") +
  geom_point(color = "grey") +
  labs(x = "",
       y = expression("Growth rate"~(mm~day^-1))
  ) +
  theme(axis.text.x = element_text(angle = 90))

ggplot(replicate_isolates, aes(x = TaxonID, y = Growth_rate_mm_day)) +
  geom_bar(data = replicate_taxa, aes(y = growth_mean), stat = "identity") +
  geom_point(color = "grey") +
  labs(x = "",
       y = expression("Growth rate"~(mm~day^-1))
  ) +
  coord_flip()


ggplot(replicate_isolates, aes(x = TaxonID, y = Growth_rate_mm_day)) +
  geom_boxplot() +
  geom_point(color = "grey") +
  labs(x = "",
       y = expression("Growth rate"~(mm~day^-1))
  ) +
  coord_flip()


replicate_isolates <- isolates %>%
  filter(TaxonID %in% replicate_taxa$TaxonID)

write.csv(replicate_isolates, "data/replicate_isolates.csv", row.names =F)


lichen_summary <- fungi %>%
  group_by(LichenID) %>%
  summarise(num_isolates = n(),
            num_taxa = length(unique(TaxonID))
  )

six_sp_lichens <- lichen_summary %>%
  filter(num_taxa == 6)

diverse_lichens <- fungi %>%
  filter(LichenID %in% six_sp_lichens$LichenID)

write.csv(diverse_lichens, "data/diverse_lichens.csv")


lichenXfungi <- table(fungi$LichenID, fungi$TaxonID)>0

taxa_mat <- matrix(lichen_summary$num_taxa, 
                   nrow = nrow(lichen_summary),
                   ncol = ncol(lichenXfungi))

cooccurance <- data.frame(lichenXfungi * taxa_mat)[, -1]
cooccurance$LichenID <- rownames(cooccurance)


spdiv <- cooccurance %>%
  gather(key = "TaxonID", value = "num_taxa", -LichenID) %>%
  filter(num_taxa > 0)


spdiv_mean <- spdiv %>%
  group_by(TaxonID) %>%
  summarise(num_taxa = mean(num_taxa))

spdiv$TaxonID <- factor(spdiv$TaxonID, levels = spdiv_mean$TaxonID[order(spdiv_mean$num_taxa)])

ggplot(spdiv, aes(x = TaxonID, y = num_taxa)) +
  geom_point() +
  geom_point(data = spdiv_mean, color = "red") +
  coord_flip()

