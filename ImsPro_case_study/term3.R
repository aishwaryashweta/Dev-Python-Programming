
setwd("C:/Users/Dell 1/Desktop/data science/TERM 3/Project/Term End Project/Term End Project")

library(ggplot2)
#TERM 3 PROJECT

cust = read.csv("train_data.csv",sep = ",",stringsAsFactors = T,na.strings = "")
summary(cust)
attach(cust)
str(cust)
sapply(cust, function(x){sum(is.na(x))})
cust2 = cust
#cust3 = cust[-10]

#check unique values and convert to factors
unique(cust$ID)
unique(cust$Warehouse_block)
unique(cust$Mode_of_Shipment)
unique(cust$Product_importance)
unique(cust$Gender)

unique(cust$Customer_care_calls)
cust$Customer_care_calls = as.factor(cust$Customer_care_calls)

unique(cust$Customer_rating)
cust$Customer_rating = as.factor(cust$Customer_rating)

unique(cust$Cost_of_the_Product) #no outliers
boxplot(cust$Cost_of_the_Product)
boxplot.stats(cust$Cost_of_the_Product)

unique(cust$Prior_purchases)
boxplot(cust$Prior_purchases)
cust$Prior_purchases = as.factor(cust$Prior_purchases)

unique(cust$Discount_offered) #too many outliers
boxplot(cust$Discount_offered)
out = boxplot.stats(cust$Discount_offered)
out
out$stats
geom_boxplot(cust,mapping = aes(x=cust$Discount_offered))
plot(cust$Discount_offered)
hist(cust$Discount_offered)
table(cust$Discount_offered)

#Check the quantile to find out the outlier limit
quantile(cust$Discount_offered, c(0,0.05,0.1,0.25,0.5,0.75,0.90,0.95,0.99,0.995,1))

unique(cust$Weight_in_gms) #no outliers
boxplot(cust$Weight_in_gms)
boxplot.stats(cust$Weight_in_gms)
plot(cust$Weight_in_gms)

unique(cust$Reached.on.Time_Y.N)
cust$Reached.on.Time_Y.N = as.factor(cust$Reached.on.Time_Y.N)

str(cust)
table(cust$Reached.on.Time_Y.N)
4436/(10999)

#cor,pairs ,cov
plot(cust[,c(6,10:11)])
cop = cor(cust[,c(6,10:11)])
cop
cor(cust[,c(6,10:11)], method = "kendall")
cor(cust[,c(6,10:11)], method = "spearman")
cov(cust[,c(6,10:11)])
pairs(cust[,c(6,10:11)])

ggplot(data = cust, mapping = aes(x = cust$Product_importance , y = cust$Discount_offered)) + geom_boxplot()

library(corrplot)
corrplot(cop)
corrplot(cop,method = "pie")
corrplot(cop,method = "color")
corrplot(cop,method = "number")
corrplot(cop,method = "number",type = "lower")

library(usdm)
vifstep(cust[,c(6,10:11)],th = 5)

#Data partition
library(caret)
set.seed(10)
train <- createDataPartition(cust$Reached.on.Time_Y.N, p=0.7, list=FALSE)
training <- cust[ train, ]
testing <- cust[ -train, ]

library(usdm)
vifstep(cust[,c(6,10:11)],th = 5)

#random forest
library(randomForest)
library(pROC)
library(e1071) 

modelrf <- randomForest(Reached.on.Time_Y.N ~ . , data = training)

modelrf
plot(modelrf)
#The variable importance plot displays a plot with variables sorted by MeanDecreaseGini
importance(modelrf)
varImpPlot(modelrf)

### predict on testing dataset
test_pred <- predict(modelrf, testing)

### Accuracy of model on test dataset
confusionMatrix(test_pred,testing$Reached.on.Time_Y.N)

# Area under the Curve
aucrf_test <- roc(as.numeric(testing$Reached.on.Time_Y.N), as.numeric(test_pred), ci=TRUE);aucrf_test
plot(aucrf_test, ylim=c(0,1), print.thres=TRUE, main=paste('Random Forest AUC:',round(aucrf_test$auc[[1]],3)),col = 'blue')

#decision tree
#tree
library(tree)
cust_dt = tree(Reached.on.Time_Y.N ~.,training)
summary(cust_dt)
plot(cust_dt)
text(cust_dt,pretty=0)
cust_dt

pred = predict(cust_dt,testing ,type="class")

confusionMatrix(pred, testing$Reached.on.Time_Y.N) #67.95


###SVM
library(e1071) 

svm_model = svm(Reached.on.Time_Y.N ~. , data = training,kernel = "linear")
summary(svm_model)

svm_result = predict(svm_model,testing)
confusionMatrix(svm_result, testing$Reached.on.Time_Y.N) #89.29

tune.out = tune(svm, Reached.on.Time_Y.N ~.  , data = training, kernel ="linear",
                ranges = list(cost = c(0.01,0.1,1,5,10,20)))
summary(tune.out)

bestmod = tune.out$best.model
summary(bestmod)
svm_result = predict(bestmod,testing)
confusionMatrix(svm_result, testing$Reached.on.Time_Y.N) #89.33

######## dil data
library(adabag)
adaboost = boosting(Reached.on.Time_Y.N~., data = training, boos = T, mfinal = 10, coeflearn = "Breiman")

#Here, mfinal = 10 indicates the times of repeated process is 10
#Coeflean = "Breiman" indicates using ML algorithm by breiman
adaboost$trees
adaboost$weight #here we get weights for all trees``
adaboost$importance #here we get importance of all variables
errorevol(adaboost,train)
#Errorevol function can be used to show the evolution of error during the boosting process
#here we get evolution of error
#Notice nowwe dont have OOB error, because we use entre data set for each tree.
#we compare the final error : 5.98%. It seems slightly better than random forest:?

pred_ts = predict(adaboost, testing)
pred_ts #93.45

t1 = adaboost$trees[[1]] #to check one tree
library(tree)
plot(t1)
text(t1, pretty = 0)

library(gbm)
train_ctrl = trainControl(method= "repeatedcv", number = 5, repeats = 3)
set.seed(1)
gbm_tree_auto = train(Reached.on.Time_Y.N~., data= train, method="gbm",distribution = "bernoulli", trControl = train_ctrl, verbose=FALSE)
gbm_tree_auto

pred_gb = predict(gbm_tree_auto, test)
confusionMatrix(test$Reached.on.Time_Y.N,pred_gb)

mygrid = expand.grid(n.trees = c(150,175,200,225), interaction.depth=c(5,6,7,8,9),
                     shrinkage=c(0.075,0.1,0.125,0.15,0.2),
                     n.minobsinnode=c(7,10,12,15))


set.seed(2018)
gbm_tree_tune = train(Reached.on.Time_Y.N~., data= train,
                      method="gbm",distribution = "bernoulli", 
                      trControl = train_ctrl, verbose=FALSE, tuneGrid=mygrid)

model = gbm_tree_tune$bestTune
model
result_4 = predict(gbm_tree_tune, test)
confusionMatrix(test$Reached.on.Time_Y.N,pred_gb)




