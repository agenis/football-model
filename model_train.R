setwd("~/ADMIN/The Nuum Factory/foot")
library(tidyverse)

df = read.csv("data.csv", stringsAsFactors = F) %>% tbl_df
df$date = lubridate::ymd(df$date)

df$is_friendly = df$tournament=="Friendly"
df$years_passed = 2020-lubridate::year(df$date) + 10

df1 = df %>% setNames(c("date", "equipe1", "equipe2", "buts1", "buts2", 
                        "tournament", "city", "country", "neutral", "is_friendly", "years_passed")) %>%
  mutate(where = "home")
df2 = df %>% setNames(c("date", "equipe2", "equipe1", "buts2", "buts1", 
                        "tournament", "city", "country", "neutral", "is_friendly", "years_passed")) %>% 
  mutate(where="away") %>% select(c("date", "equipe1", "equipe2", "buts1", "buts2", 
                                    "tournament", "city", "country", "neutral", "is_friendly", "years_passed", "where"))
df = rbind(df1, df2)

df$victoire = "victoire"
df$victoire[df$buts1==df$buts2] = "nul"
df$victoire[df$buts1<df$buts2] = "defaite"

df$victoire = factor(df$victoire)

df$weights = 1/(df$years_passed-10)

df = df %>% group_by(equipe1, equipe2) %>% mutate(n=n()) %>% filter(n>50)

#df$equipe1 = factor(df$equipe1)
#df$equipe2 = factor(df$equipe2)

ctrl = trainControl(method="none")
library(caret)
mymodel_victory = train(victoire~equipe1+equipe2+is_friendly+where, data=df, method="knn", trControl =ctrl, weights = df$weights, tuneGrid = expand.grid(k = 7))
mymodel_buts1 = train(buts1~equipe1+equipe2+is_friendly+where, data=df, method="knn", trControl =ctrl, tuneGrid = expand.grid(k = 3), weights = df$weights)
mymodel_buts2 = train(buts2~equipe1+equipe2+is_friendly+where, data=df, method="knn", trControl =ctrl, tuneGrid = expand.grid(k = 3),  weights = df$weights)

topredict = data.frame("equipe1"="France", "equipe2"="England", "is_friendly"=TRUE, "where"="away")
topredict = data.frame("equipe1"="England", "equipe2"="France", "is_friendly"=TRUE, "where"="away")
topredict = data.frame("equipe1"="France", "equipe2"="Estonia", "is_friendly"=TRUE, "where"="away")

predict(mymodel_victory, newdata = topredict)
predict(mymodel_buts1, newdata = topredict)
predict(mymodel_buts2, newdata = topredict)

GetNewPredictions <- function(model1, model2, newdata){
  
  #newdata.transformed <- predict(object = transformer, newdata = newdata)
  
  new.predictions1 <- predict(object = model1, newdata = newdata)#.transformed)
  new.predictions2 <- predict(object = model2, newdata = newdata)#.transformed)
  
  return(paste0("resultat match: ", newdata$equipe1, " ", round(new.predictions1, 1), " - ",
                round(new.predictions2, 1), " ", newdata$equipe2))
  
}


# Define Output object.
model.list <- vector(mode = 'list')
# Save fitted model.
model.list$model1 <- mymodel_buts1
model.list$model2 <- mymodel_buts2
# Save transformation function. 
model.list$GetNewPredictions <- GetNewPredictions

saveRDS(object = model.list, file = 'model_list.rds')




