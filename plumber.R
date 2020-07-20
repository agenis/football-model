# plumber.R

# Read model data.
model.list <- readRDS(file = 'model_list.rds')

#* @param wt
#* @param qsec
#* @param am
#* @post /predict
CalculatePrediction <- function(equipe1, equipe2, is_friendly, where){
  

  is_friendly = as.logical(is_friendly)

  
  X.new <- tibble(equipe1 = equipe1, equipe2 = equipe2, is_friendly = is_friendly, where = where)
  
  y.pred <- model.list$GetNewPredictions(model1 = model.list$model1, 
                                         model2 = model.list$model2, 
                                         newdata = X.new)
  
  return(y.pred)
}

r <- plumb(file = 'plumber.R')

r$run(port = 8080)
