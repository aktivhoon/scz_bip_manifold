rm(list=ls())

libraries <- c("networktools", "IsingFit", "qgraph", "igraph", "bootnet", 
               "NetworkComparisonTest", "haven", "centiserve", "cowplot",
               "dplyr", "patchwork")
sapply(libraries, require, character.only = TRUE)

data_path <- getwd()
data_path <- paste0(data_path, "/data/DIGS.sav")
data1 <- read_sav(data_path)

# dat1: Schziophrenia + Schizoaffective
dat1 <- subset(data1, data1$DXCODE<3, select= c(2, 5, 387, 388, 383, 385, 396, 398,
                                                390,397,392,393,394,399,400,413,414,416,417,418))

# dat2: Bipolar I disorder
dat2 <- subset(data1, data1$DXCODE==3, select= c(2, 5, 387, 388, 383, 385, 396, 398,
                                                 390,397,392,393,394,399,400,413,414,416,417,418))

# Change column names
colnames(dat1) = c("ID", "DXCode", "ah", "vh", "oc", "pho", "ero", "doc",
                   "par", "rfr", "glt", "grn", "rlg", "brd", "ins", "dsr", "frm", "avl", "mut", "anh")

colnames(dat2) = c("ID", "DXCode", "ah", "vh", "oc", "pho", "ero", "doc",
                   "par", "rfr", "glt", "grn", "rlg", "brd", "ins", "dsr", "frm", "avl", "mut", "anh")

## Schizophrenia
# percentage of N/A
dat1_na_summary <- round(colSums(is.na(dat1[,-1:-2]))/nrow(dat1),3)
# percentage of no Sx
dat1_sx_raw_summary <- round(colSums(dat1[,-1:-2]==1, na.rm=TRUE)/(nrow(dat1)-colSums(is.na(dat1[,-1:-2]))),3)
# percentage of no Sx (processed)
dat1_sx_proc_summary <- round(colSums(dat1[,-1:-2]==1)/nrow(dat1),3)

## Bipolar I disorder
# percentage of N/A
dat2_na_summary <- round(colSums(is.na(dat2[,-1:-2]))/nrow(dat2),3)
# percentage of no Sx
dat2_sx_raw_summary <- round(colSums(dat2[,-1:-2]==1, na.rm=TRUE)/(nrow(dat2)-colSums(is.na(dat2[,-1:-2]))),3)
# percentage of no Sx (processed)
dat2_sx_proc_summary <- round(colSums(dat2[,-1:-2]==1)/nrow(dat2),3)

gamma <- 0.1

## Schizophrenia
# Obtain res using `IsingFit()`
res = IsingFit(dat1[,-1:-2], family='binomial', plot=F, gamma=gamma)

# Obtain the graph using `graph_from_adjacency_matrix()` -> this is necessary for obtaining the communities
res_g1 = graph_from_adjacency_matrix(abs(res$weiadj), "undirected", weighted = TRUE, add.colnames = FALSE)
# Use walktrap algorithm to find clusters(communities) in the graph
res_g2 = cluster_walktrap(res_g1)
communities(res_g2) 

# Obtain the graph using `qgraph()`, coloring the groups using `communities(res_g2)`
gra3_1 = qgraph(res$weiadj, layout = "spring", cut = .8, groups = communities(res_g2), legend = F)
# Convert gra3_1 to igraph to obtain 'Katz' centrality.
igra3_1 <- as.igraph(gra3_1)
V(igra3_1)$name <- gra3_1$graphAttributes$Nodes$names
kc_centrality1 <- katzcent(igra3_1)
kc_centrality1 <- kc_centrality1[order(kc_centrality1)]

# Centrality measures obtained using `gra3_1` (Strength, Betweeness, Closeness)
cen = centralityTable(gra3_1,standardized = FALSE)
spl = centrality(res_g1)$ShortestPathLengths
spl = spl[upper.tri(spl)]
aspl = mean(spl)

# Betweeness
betweeness1<-cen[cen$measure=="Betweenness",][, c("value", "node")]
colnames(betweeness1) <- c("values", "ind")
betweeness1[is.na(betweeness1)] <- 0
betweeness1 <- betweeness1[order(betweeness1$values),]
row.names(betweeness1) <- NULL
betweeness1$row_num <- seq_len(nrow(betweeness1))

# Closeness
closeness1<-cen[cen$measure=="Closeness",][, c("value", "node")]
colnames(closeness1) <- c("values", "ind")
closeness1[is.na(closeness1)] <- 0
closeness1 <- closeness1[order(closeness1$values),]
row.names(closeness1) <- NULL
closeness1$row_num <- seq_len(nrow(closeness1))

# Strength
strength1<-cen[cen$measure=="Strength",][, c("value", "node")]
colnames(strength1) <- c("values", "ind")
strength1[is.na(strength1)] <- 0
strength1 <- strength1[order(strength1$values),]
row.names(strength1) <- NULL
strength1$row_num <- seq_len(nrow(strength1))

## Bipolar I disorder
# Obtain res using `IsingFit()`
res = IsingFit(dat2[,-1:-2], family='binomial', plot=F, gamma=gamma)

# Obtain the graph using `graph_from_adjacency_matrix()` -> this is necessary for obtaining the communities
res_g1 = graph_from_adjacency_matrix(abs(res$weiadj), "undirected", weighted = TRUE, add.colnames = FALSE)
# Use walktrap algorithm to find clusters(communities) in the graph
res_g2 = cluster_walktrap(res_g1)
communities(res_g2) 

# Obtain the graph using `qgraph()`, coloring the groups using `communities(res_g2)`
gra3_2 = qgraph(res$weiadj, layout = "spring", cut = .8, groups = communities(res_g2), legend = F)
# Convert gra3_2 to igraph to obtain 'Katz' centrality.
igra3_2 <- as.igraph(gra3_2)
V(igra3_2)$name <- gra3_2$graphAttributes$Nodes$names
kc_centrality2 <- katzcent(igra3_2)
kc_centrality2 <- kc_centrality2[order(kc_centrality2)]

# Centrality measures obtained using `gra3_1` (Strength, Betweeness, Closeness)
cen2 = centralityTable(gra3_2, standardized = FALSE)
spl = centrality(res_g1)$ShortestPathLengths
spl = spl[upper.tri(spl)]
aspl = mean(spl)

# Betweeness
betweeness2<-cen2[cen2$measure=="Betweenness",][, c("value", "node")]
colnames(betweeness2) <- c("values", "ind")
betweeness2[is.na(betweeness2)] <- 0
betweeness2 <- betweeness2[order(betweeness2$values),]
row.names(betweeness2) <- NULL
betweeness2$row_num <- seq_len(nrow(betweeness2))

# Closeness
closeness2<-cen2[cen2$measure=="Closeness",][, c("value", "node")]
colnames(closeness2) <- c("values", "ind")
closeness2[is.na(closeness2)] <- 0
closeness2 <- closeness2[order(closeness2$values),]
row.names(closeness2) <- NULL
closeness2$row_num <- seq_len(nrow(closeness2))

# Strength
strength2<-cen2[cen2$measure=="Strength",][, c("value", "node")]
colnames(strength2) <- c("values", "ind")
strength2[is.na(strength2)] <- 0
strength2 <- strength2[order(strength2$values),]
row.names(strength2) <- NULL
strength2$row_num <- seq_len(nrow(strength2))

## For plot
scz_katz_plot <- ggplot(stack(kc_centrality1), aes(x=values, y=ind, group=1)) +
  geom_line(color="#063A5B") + geom_point(color="#063A5B") +
  labs(title="Katz",x="Centrality", y = "Symptoms")+
  scale_color_brewer(palette="Paired") + 
  theme_classic(base_size = 13) + theme(plot.title=element_text(hjust=0.5))

scz_betweeness_plot <- ggplot(betweeness1, aes(x=values, y=reorder(ind, row_num), group=1)) +
  geom_line(color="#063A5B") + geom_point(color="#063A5B") +
  labs(title="Betweeness",x="Centrality", y = "")+
  scale_color_brewer(palette="Paired") + 
  theme_classic(base_size = 13) + theme(plot.title=element_text(hjust=0.5))

scz_closeness_plot <- ggplot(closeness1, aes(x=values, y=reorder(ind, row_num), group=1)) +
  geom_line(color="#063A5B") + geom_point(color="#063A5B") +
  labs(title="Closeness",x="Centrality", y = "")+
  scale_color_brewer(palette="Paired") + 
  theme_classic(base_size = 13) + theme(plot.title=element_text(hjust=0.5))

scz_strength_plot <- ggplot(strength1, aes(x=values, y=reorder(ind, row_num), group=1)) +
  geom_line(color="#063A5B") + geom_point(color="#063A5B") +
  labs(title="Strengths",x="Centrality", y = "")+
  scale_color_brewer(palette="Paired") + 
  theme_classic(base_size = 13) + theme(plot.title=element_text(hjust=0.5))

bip_katz_plot <- ggplot(stack(kc_centrality2), aes(x=values, y=ind, group=1)) +
  geom_line(color="#aa0c3e") + geom_point(color="#aa0c3e") +
  labs(title="Katz",x="Centrality", y = "Symptoms")+
  scale_color_brewer(palette="Paired") + 
  theme_classic(base_size = 13) + theme(plot.title=element_text(hjust=0.5))

bip_betweeness_plot <- ggplot(betweeness2, aes(x=values, y=reorder(ind, row_num), group=1)) +
  geom_line(color="#aa0c3e") + geom_point(color="#aa0c3e") +
  labs(title="Betweeness",x="Centrality", y = "")+
  scale_color_brewer(palette="Paired") + 
  theme_classic(base_size = 13) + theme(plot.title=element_text(hjust=0.5))

bip_closeness_plot <- ggplot(closeness2, aes(x=values, y=reorder(ind, row_num), group=1)) +
  geom_line(color="#aa0c3e") + geom_point(color="#aa0c3e") +
  labs(title="Closeness",x="Centrality", y = "")+
  scale_color_brewer(palette="Paired") + 
  theme_classic(base_size = 13) + theme(plot.title=element_text(hjust=0.5))

bip_strength_plot <- ggplot(strength2, aes(x=values, y=reorder(ind, row_num), group=1)) +
  geom_line(color="#aa0c3e") + geom_point(color="#aa0c3e") +
  labs(title="Strengths",x="Centrality", y = "")+
  scale_color_brewer(palette="Paired") + 
  theme_classic(base_size = 13) + theme(plot.title=element_text(hjust=0.5))

scz_katz_plot + scz_betweeness_plot + scz_closeness_plot + scz_strength_plot +  
  plot_layout(ncol = 4)

bip_katz_plot + bip_betweeness_plot + bip_closeness_plot + bip_strength_plot +
  plot_layout(ncol = 4)

write.csv(dat1, "./data/scz.csv")
write.csv(dat2, "./data/bip.csv")