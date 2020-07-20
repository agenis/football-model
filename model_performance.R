
set.seed(1234)
df_ = df %>% ungroup() %>% group_by(equipe1, equipe2) %>% mutate(n=n()) %>% filter(n>50)
df_ = df_ %>% ungroup() %>% sample_n(1000)
preds = predict(mymodel_victory, newdata = df_, type="prob") %>% setNames(c("prob_defaite", "prob_nul"," prob_victoire"))
df_ = cbind.data.frame(df_, preds)
df_$pred = predict(mymodel_victory, newdata = df_)
df_$pred[df_$prob_nul>0.3]="nul"

table(df_$victoire, df_$pred)
table(df_$victoire==df_$pred) %>% prop.table()


set.seed(1234)
df_ = df %>% ungroup() %>% group_by(equipe1, equipe2) %>% mutate(n=n()) %>% filter(n>50)
df_ = df_ %>% ungroup() %>% sample_n(1000)
df_$pred = predict(mymodel_buts1, newdata = df_)
df_$pred2 = predict(mymodel_buts2, newdata = df_)

ggplot(df_) + aes(x=buts1, y=pred) + geom_point() + geom_smooth(method="lm") + geom_abline(slope=1, intercept = 0)
ggplot(df_) + aes(x=buts2, y=pred2) + geom_point() + geom_smooth(method="lm") + geom_abline(slope=1, intercept = 0)


RMSE(df_$buts1, df_$pred)
RMSE(df_$buts2, df_$pred2)
ggplot(df%>% ungroup %>%sample_n(10000)) + aes(x=years_passed, y=buts1) + geom_point(alpha=0.2) + geom_smooth(method="loess", size=2)
