****************************
** DATA FOR QUESTION 1
****************************

The dataset for the first question comes from the "Census Income Data Set" provided by the UCI Machine Learning Repository ("https://archive.ics.uci.edu/ml/datasets/census+income").  The dataset provided contains a subset of the variables in the original data.  Each observation refers to a particular individual.  The data is extracted from the 1994 United States census.

The main outcome variable for prediction is *income_group* where a 1 means the indivdiual's income exceeds 50K in the year and a 0 means it does not.

The potentially relevant predictors of income_group are as follows:

1) age.  The age of an individual.

2) workclass.  A description of the individual's employment status.  Values: Private (works in private sector), Self-emp-not-inc (self-employed, unincorporated), Self-emp-inc (self-employed, incorporated), Federal-gov (Federal government employee), Local-gov (Local government employee), State-gov (State government employee), Without-pay (currently not receiving income), Never-worked.

3) education.  The highest level of education achieved by the individual.  Values: Bachelors (university graduate), Some-college (some university), 11th (11th grade), HS-grad (high-school graduate), Prof-school (professional school), Assoc-acdm (associate degree - academic), Assoc-voc (associate degree - vocational), 9th (9th grade), 7th-8th (7th/8th grade), 12th (12th grade), Masters (masters degree), 1st-4th (1st-4th grade), 10th (10th grade), Doctorate, 5th-6th (5th-6th grade), Preschool.

4) education-num.  Years of education.

5) marital-status.  Marital status of an individual.  Values: Married-civ-spouse (civilian spouse), Divorced, Never-married, Separated, Widowed, Married-spouse-absent, Married-AF-spouse (spouse is in the armed forces).

6) race.  Values: White, Asian-Pac-Islander (Asian or Pacific Islander), Amer-Indian-Eskimo (Native American), Other, Black.

7) sex.

8) capital-gain.  Increase in value of financial capital.

9) capital-loss.  Decrease in value of financial capital.

10) hours-per-week.  The hours an invidiual has reported to work per week.

11) native-country.  An individual's country of origin.

****************************
** DATA FOR QUESTION 3
****************************

The data for this question comes from the Young Person's Survey available from Kaggle https://www.kaggle.com/datasets/miroslavsabo/young-people-survey.  In the raw data, individual survey responses are recorded from over 1,000 young people about a variety of topics.  Here we focus on survey responses regarding preferences over the trance music genre.  Each individual expresses preferences using a 1-5 integer scale where 1 is "don't enjoy at all" and 5 is "enjoy very much."  The data file trance.csv tabulates the number of individuals who answer 1/2/3/4/5 within demographic cells, where a demographic cell is a combination of (age group) X (number of siblings) X (location of residence, i.e. city or village) X (gender) X (dwelling type, i.e. block of flats or house/bungalow).





