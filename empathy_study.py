# -*- coding: utf-8 -*-
"""empathy_study.ipynb

import re
import requests
import pandas as pd
import numpy as np
from io import StringIO
import matplotlib.pyplot as plt
import scipy.stats as stats
plt.style.use('ggplot')

# Download data
Data it's downloaded from Google Drive
"""
batch1_2_3 = 'https://docs.google.com/spreadsheets/d/1jT7VQOFyisTM1eyGi0NvSmMeT2DGs6h--nFqTSeBm1w/export?format=tsv'

def load_dataset(url, sep):
    r = requests.get(url)
    data = r.content.decode('utf8')
    df = pd.read_csv(StringIO(data), sep=sep)
    return df

df = load_dataset(batch1_2_3, '\t')

"""# Cleaning"""

#print column names, types and null values
df.info()

"""## Encoding categorical data"""

# encode categorical data
from sklearn.preprocessing import LabelEncoder

# creating instance of labelencoder
labelencoder = LabelEncoder()
# Assigning numerical values and storing in another column
df['Gender_num'] = labelencoder.fit_transform(df['Gender'])
df['Age_num'] = labelencoder.fit_transform(df['Age'])
df['Etn_num'] = labelencoder.fit_transform(df['Ethnicity'])
df

"""## Remove null values"""

nan_value = float("NaN")
df.replace("", nan_value, inplace=True)
df.dropna(subset = ["EQ"], inplace=True)

"""## Balance data (TODO)"""

#is the dataset unbalanced for female/male?
df['Gender'].value_counts()

#from https://towardsdatascience.com/how-to-deal-with-imbalanced-data-in-python-f9b71aba53eb
# import SMOTE oversampling and other necessary libraries 
from collections import Counter
from imblearn.over_sampling import SMOTE
from sklearn.model_selection import train_test_split
import pandas as pd
import numpy as np
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)

# Separating the independent variables from dependent variables
X = df.iloc[:,[-2,-7]] #age, eq
y = df.iloc[:,-3] #gender

#Split train-test data
X_train, X_test, y_train, y_test = train_test_split(X,y,test_size=0.30)

# summarize class distribution
print("Before oversampling: ",Counter(y_train))

# define oversampling strategy
SMOTE = SMOTE()

# fit and apply the transform
X_train_SMOTE, y_train_SMOTE = SMOTE.fit_resample(X_train, y_train)

# summarize class distribution
print("After oversampling: ",Counter(y_train_SMOTE))

#PART 2
# import SVM libraries 
from sklearn.svm import SVC
from sklearn.metrics import classification_report, roc_auc_score

model=SVC()
clf_SMOTE = model.fit(X_train_SMOTE, y_train_SMOTE)
pred_SMOTE = clf_SMOTE.predict(X_test)

print("ROC AUC score for oversampled SMOTE data: ", roc_auc_score(y_test, pred_SMOTE))

df.head(10)

# number of unique values of column Gender
df.Gender.nunique()

# unique values of column Gender
df.Gender.unique()

"""# Visualization"""

#def plot_male_female_(df, col):
    # histogram of column - males and females

df[df.Gender == 'Male'].EQ.plot(kind='hist', color='blue', edgecolor='black', alpha=0.5, figsize=(10, 7))
df[df.Gender == 'Female'].EQ.plot(kind='hist', color='red', edgecolor='black', alpha=0.5, figsize=(10, 7))
plt.legend(labels=['Males', 'Females'])
plt.title('Distribution of EQ', size=24)
plt.xlabel('EQ score', size=18)
plt.ylabel('Frequency', size=18);

"""Boxplot"""

import seaborn as sns
sns.set()
g = sns.factorplot("Gender", "EQ", data=df, kind="box", palette=["lightpink", "lightblue"])
g.set_axis_labels("Gender", "EQ score");

"""Kernel Density Estimate"""

sns.distplot(df.EQ[df.Gender=='Male'])
sns.distplot(df.EQ[df.Gender=='Female']);

"""Violin Plot 

A combination of boxplot and kernel density estimate.

"""

sns.violinplot("Gender", "EQ", data=df,
               palette=["lightpink", "lightblue"]);

"""Ethnicity of participants"""

df.Ethnicity.value_counts().plot(explode=[0.05]*10, kind='pie', label='Ethnicity', autopct="%.1f%%",pctdistance=0.5)

"""Age of participants"""

df.Age.value_counts().plot(explode=[0.05]*5, kind='pie', label='Age', autopct="%.1f%%",pctdistance=0.5)

"""# T-test

## Assumption check
The assumptions in this section need to be met in order for the test results to be considered valid. 
From: https://pythonfordatascienceorg.wordpress.com/independent-t-test-python/

### 1. The two samples are independent
This assumption is tested when the study is designed. What this means is that no individual has data in group A and B.

### 2. Population distributions are normal
One of the assumptions is that the sampling distribution is normally distributed. The test of the assumption of normality can be done visually with a histogram and/or as a q-q plot, and by using the Shapiro-Wilk test which is the stats.shaprio() method.
"""

plt.style.use('ggplot')

fig, ax = plt.subplots(1, 2, figsize=(11, 4))

ax[0].hist(df['EQ'][df['Gender'] == 'Male'], facecolor='b')
ax[1].hist(df['EQ'][df['Gender'] == 'Female'], facecolor='r')

ax[1].set_title("Distribution of EQ score for females")
ax[0].set_title("Distribution of EQ score for males")

stats.probplot(df['EQ'][df['Gender'] == 'Male'], dist="norm", plot= plt)
plt.title("Male EQ score Q-Q Plot")

stats.probplot(df['EQ'][df['Gender'] == 'Female'], dist="norm", plot= plt)
plt.title("Female EQ score Q-Q Plot")

"""To be sure, we can test it statistically using the Shapiro-Wilk test for normality which is the stats.shaprio() method. In the output of the function, the first value is the W test statistic and the second value is the p-value."""

eq= df['EQ'][df['Gender'] == 'Male'].values
stats.shapiro(eq)

eq2= df['EQ'][df['Gender'] == 'Female'].values
stats.shapiro(eq2)

"""### 3. The variances between the two groups are equal
To test the homogeneity of variances we will use Levene’s test for homogeneity of variance. The method to conduct this test is stats.levene()
"""

stats.levene(df['EQ'][df['Gender'] == 'Male'], df['EQ'][df['Gender'] == 'Female'])

"""The result of the test is not significant, therefore there is homogeneity of variances and we can procede with the test

## T-test using researchpy
"""

!pip install researchpy
import researchpy as rp

summary, results = rp.ttest(group1= df['EQ'][df['Gender'] == 'Male'], group1_name= "Male EQ",
                            group2= df['EQ'][df['Gender'] == 'Female'], group2_name= "Female EQ")

print(summary)

print(results)

"""## T-test using scipy"""

stats.ttest_ind(df['EQ'][df['Gender'] == 'Male'],
                df['EQ'][df['Gender'] == 'Female'])

"""# Facial data analysis

## functions
"""

import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error
import time

def lin_reg(x, y):
  #split train and test set
  validation_size = 0.3
  X_train, X_test, y_train, y_test = train_test_split(x, y, test_size=validation_size)

  #apply regression model
  model_linear= LinearRegression(copy_X=True)
  t0 = time.time()
  model_linear.fit(X_train, y_train)
  execution = time.time() - t0
  y_pred = model_linear.predict(X_test)
  l_reg = model_linear.score(X_test, y_test)

  #show results of regression model
  print("score linear: %.4f" % l_reg)
  regression_error = mean_absolute_error(y_test, y_pred)
  print("regression_error: %.4f" % regression_error)

# Code to read csv file into Colaboratory:
!pip install -U -q PyDrive
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
from google.colab import auth
from oauth2client.client import GoogleCredentials

# Authenticate and create the PyDrive client.
auth.authenticate_user()
gauth = GoogleAuth()
gauth.credentials = GoogleCredentials.get_application_default()
drive = GoogleDrive(gauth)

# Download the 3 batches
downloaded1 = drive.CreateFile({'id':"1OppZsCswRCw2n_EjmsaPhS3YYngM9A0i"}) 
downloaded1.GetContentFile('ExportMerge1.csv')  

downloaded2 = drive.CreateFile({'id':"1D7x1DL8zSLe2fGXKKWaOhd2Ds6iRO00D"}) 
downloaded2.GetContentFile('ExportMerge2.csv') 

downloaded3 = drive.CreateFile({'id':"1BuCtdYLKqe-3o5vy3oWxQsGvgLS_u6kf"}) 
downloaded3.GetContentFile('ExportMerge3.csv')

df_batch1 = pd.read_csv('ExportMerge1.csv',skiprows=44) #skip metadata
df_batch2 = pd.read_csv('ExportMerge2.csv',skiprows=54) #skip metadata
df_batch3 = pd.read_csv('ExportMerge3.csv',skiprows=46) #skip metadata

#merge batches
df3=pd.concat([df_batch1, df_batch2, df_batch3])

df.rename(columns={'Respondent ID': 'Respondent'}, inplace=True)  

#select only participants with good quality scores
df_good=df.loc[df['Quality'] == 0, ['EQ','Respondent', 'Quality']]

#merge facial data with eq scores
df3_withEQ = pd.merge(df3, df_good, how="right")
df3_withEQ.dropna(inplace=True)
print(df3_withEQ)

#the stimulus images are labelled as 1HAS 2HAS etc, but we're interested only in the emotion respresentend in this case happiness
#so 1HAS and 2HAS represent the same emotion. We remove the number from the label
df3['SourceStimuliEmotions']=df3['SourceStimuliName'].str[1:]

dfStimuli = df3[["SourceStimuliEmotions", "Anger",	"Contempt",	"Disgust",	"Fear",	"Joy",	"Sadness",	"Surprise",	"Engagement"]]

#average emotion value across all participants for each stimulus image
dfStimuli.groupby(['SourceStimuliEmotions']).mean()

dfStimuli.groupby(['SourceStimuliEmotions']).max()

# encode categorical data
from sklearn.preprocessing import LabelEncoder

# creating instance of labelencoder
labelencoder = LabelEncoder()
tot_stimuli=len(df3['SourceStimuliName'].unique())
tot_emotions=len(df3['SourceStimuliEmotions'].unique())

# Assigning numerical values and storing in another column
df3['SourceStimuli_num'] = labelencoder.fit_transform(df3['SourceStimuliEmotions'])

print("Tot stimuli:", tot_stimuli)
print("Tot emotions:", tot_emotions)
print(df3['SourceStimuliEmotions'].unique())

tot_participants=len(df3['Respondent'].unique())
print("Tot participants:", tot_participants)

df3

df3.dropna(inplace= True,subset=df3.iloc[:,-36:].columns,how="any")

#average, min and max emotion expression for each particpant for each type of stimulus
grouped = df3.groupby(['Respondent', 'SourceStimuliEmotions']).agg({'Anger': ['mean', 'min', 'max'], 'Contempt': ['mean', 'min', 'max'], 'Disgust': ['mean', 'min', 'max'], 'Fear': ['mean', 'min', 'max'], 'Joy': ['mean', 'min', 'max'], 'Sadness': ['mean', 'min', 'max'], 'Surprise': ['mean', 'min', 'max']})
grouped.columns = ['Anger_mean', 'Anger_min', 'Anger_max','Contempt_mean', 'Contempt_min', 'Contempt_max','Disgust_mean', 'Disgust_min', 'Disgust_max','Fear_mean', 'Fear_min', 'Fear_max','Joy_mean', 'Joy_min', 'Joy_max','Sadness_mean', 'Sadness_min', 'Sadness_max','Surprise_mean', 'Surprise_min', 'Surprise_max']
grouped= grouped.reset_index()    
grouped

"""## analysis facial response and EQ"""

#average, min and max emotion expression for each particpant for all stimulis
df3_withEQ_avg = df3_withEQ.groupby(['Respondent']).agg({"EQ": ['mean'],'Anger': ['mean'], 'Contempt': ['mean'], 'Disgust': ['mean'], 'Fear': ['mean'], 'Joy': ['mean'], 'Sadness': ['mean'], 'Surprise': ['mean']})
df3_withEQ_avg.columns = ["EQ",'Anger_mean', 'Contempt_mean','Disgust_mean', 'Fear_mean', 'Joy_mean', 'Sadness_mean', 'Surprise_mean']
df3_withEQ_avg= df3_withEQ_avg.reset_index()  
df3_withEQ_avg

# correlation between eq score and average reaction to all stimuli
correlation=df3_withEQ_avg.corr()["EQ"].sort_values(ascending=False)
print(correlation)

y=df3_withEQ_avg["EQ"] #target: stimuli
x=df3_withEQ_avg.iloc[:, 2:] #features: emotions and expressions
lin_reg(x, y)

"""## analysis facial stimulus and subjects facial expressions and emotions
relationship between each facial stimulus and subjects' facial expressions and emotions to it (so which emotion and facial features are triggered upon seeing happy faces for example)

"""

# analysis with all values
correlation=df3.corr()["SourceStimuli_num"].sort_values(ascending=False)
print(correlation)

y=df3["SourceStimuli_num"] #target: stimuli
x=df3.iloc[:, -36:-3] #features: emotions and expressions
lin_reg(x, y)