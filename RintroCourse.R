#Intro to R script

#get current working directory
getwd()

#set working directory to ('...')
setwd("/Users/simon/scw-2018/intro-R/")

cats <- 10 #crazy cat lady
cats -9

G4 <- 5
4G <- 5


#avoid these variable names
#c, C, F, t, T, S (they are built in R functions)

#6 main data types
# Characters 'asdfg' "asdfdf"
# integers
# complex
# logical
# numerical
# raw (we wont use)

#functions:

class(cats)
#class tells you the data type
typeof(cats)

# in R an Integer is a whole number
i <- 2L
j <- 2

class(j)
typeof(j)
class(i)
typeof(i)

#complex numbers
k <- 1 + 4i

#logicals (all CAPS)
TRUE FALSE

#data structures

#atomic vectors

logical_vector <- c(TRUE,TRUE,FALSE,TRUE)   #c combine function
class(logical_vector)

char_vector <- c("saDFSAF","SDAD","ASDSADA")
class(char_vector)
length(char_vector)
anyNA(char_vector)
char_vector[2]  #to ask for second element

mixed <- c("True",TRUE)
class(mixed)
#careful not to do this, R will assign it as character not mixed!

anothermixed <- c(pi)
class(anothermixed)

anothermixed <- c(FALSE, 2L, 3.14)
class(anothermixed)

anothermixed <- c(FALSE, 2L)
class(anothermixed)

#List datatype (made of multiple vectors)

mylist <- list(chars = 'coffee', nums = c(1.4,5) , logicals = TRUE , anotherlist = list(a = 'a', b=2))
mylist[2]
class(mylist)
str(mylist)

mylist[3]
mylist$logicals

#matrix (2D and homogenous data type, more info in help panel)

m <- matrix(nrow = 2, ncol = 3)
class(m)
m
m <- matrix(data = 1:6, nrow = 2, ncol = 3)
#note: fills by column first
m

#how to fill br row
m <- matrix(data = 1:6, nrow = 2, ncol = 3, byrow=TRUE)
m

#dataframes (2D with heterogenous data types, but indivdual column is a vector and needs to contain same datatype)
df <- data.frame( id= letters[1:10], x=1:10, y=11:20, z=TRUE, w=c("hello","ads","afa","afaff","afafaf"))
df
str(df)
class(df)
typeof(df)
head(df)
tail(df)
dim(df)
names(df)
summary(df)

#factors
state <- factor (c("Arizona", "Cal", "Mass"))
state
state <- factor (c("AZ","CA","CA"))
state
nlevels(state)
levels(state)
ratings <- factor (c("low","high","med"))
ratings
r <- c("low","high","med")
ratings <- factor (r)
ratings <- factor (ratings, levels =c("low","med","high"), ordered=TRUE)
ratings
min(ratings)

survey <- data.frame(number = c(1,2,2,1,2), group = c ("A","B","A","A","B"))
survey
str(survey)
# data.frame turns strings to factors (can stop it by setting argument to FALSE)


simon <- data.frame (Day=1:5, Magnification=c(2,10,5,2,5), Observation=c("Growth","Death","No Change","Death","Growth") )
simon
str(simon)

Day=1:5
Magnification=c(2,10,5,2,5)
Observation=c("Growth","Death","No Change","Death","Growth")

simon <- data.frame (Day,Magnification,Observation)
simon

#Import in Data

gapminder <- read.csv("gapminder-FiveYearData.csv")
dim (gapminder)
head(gapminder)
str(gapminder)

View(gapminder)
gapminder[1,1]
gapminder[3,2]
gapminder[ ,1]
gapminder[7, ]
gapminder[10:15,5:6]
View(gapminder)
gapminder[10:15,c("lifeExp","gdpPercap")]
gapminder[gapminder$country =='Switzerland' ,]

install.packages('dplyr')
library(dplyr)

#this is a pipe %>%
# select is by column
# filter is by row

select(gapminder,lifeExp,gdpPercap)
gapminder %>% select(lifeExp,gdpPercap)
gapminder %>% filter(lifeExp > 71)
gapminder %>%
  select(year,country,gdpPercap) %>%
  filter(country == 'Mexico') %>%
  head()

Mexico <- gapminder %>%
  select(year,country,gdpPercap) %>%
  filter(country == 'Mexico')

View(Mexico)
  
NewData <- gapminder %>%

  filter(year > 1980 &! continent == 'Europe')

View(NewData)  

#booleens: AND=& OR=|(piper) NOT=!

install.packages('ggplot2')
library(ggplot2)

gapminder %>% group_by(country) %>% tally()

gapminder %>% group_by(country) %>% summarise(avg = mean(pop))
gapminder %>% group_by(country) %>% summarise(avg = mean(pop), std = sd(pop), total = n())

#sort by averages using arrange function (descending)
gapminder %>% group_by(country) %>% 
  summarise(avg = mean(pop), std = sd(pop), total = n()) %>% 
  arrange(desc(avg))

#mutate (how to apply calculations to your data!)

gapminder_mod <- gapminder %>% mutate(gdp=pop*gdpPercap)

#avg life expectancy
gapminder_mod %>% group_by(country) %>% 
  summarise(avg = mean(lifeExp)) %>% 
  filter(avg==max(avg) | avg==min(avg))
  
#PLOTTING DATA!!!!

#basic R plots
plot(x=gapminder_mod$gdpPercap, y=gapminder_mod$lifeExp)
  
#ggplot2 package
library(ggplot2)

ggplot(gapminder_mod, aes(x=gdpPercap, y=lifeExp)) +
  geom_point()

#log10 

ggplot(gapminder_mod, aes(x=log10(gdpPercap), y=lifeExp)) +
  geom_point()

#transparent

p <- ggplot(gapminder_mod, aes(x=log10(gdpPercap), y=lifeExp, color=continent)) +
  geom_point(alpha=1/3,size=2)

p

p2 <- p + facet_wrap(~continent)

p2

p3 <- p2 + geom_smooth()

p3

#Combine dplyr and ggplot2

gapminder %>% mutate(gdp=pop*gdpPercap) %>% 
  ggplot(aes(gdp,lifeExp)) + geom_point()


#Exercise for histogram

p4 <- ggplot(gapminder_mod, aes(x=(lifeExp), fill=continent)) +
  geom_histogram(binwidth = 1) +
  ggtitle("Histrogram_gapminder")

p4

#saving plots
ggsave(p7,file = "~/scw-2018/intro-R/densityplot.png")

#line plot
p5 <- gapminder_mod %>% filter(country == "United States") %>% 
  ggplot(aes(x=year, y=lifeExp)) +
  geom_line(color="pink", size = 7)

p5

#EX: Plot lifeExp against year and facet by continent 
#and fit a smooth and/or linear regression, w/ or w/o facettin

p6<-ggplot(gapminder_mod, aes(x=year, y=lifeExp, color=continent)) +
  geom_point(alpha=1/3,size=2) +
  facet_wrap("continent") +
  geom_smooth(color="black", size = 1, se =FALSE) +
  geom_smooth(color="red", size = 1, method="lm")

p6

#density plots

p7<-ggplot(gapminder_mod, aes(gdpPercap,lifeExp)) +
  geom_point(size=0.5) +
  geom_density_2d()+
  scale_x_log10()

p7

#multiplegraphs

install.packages("gridExtra")
library(gridExtra)

gridExtra::grid.arrange(p3,p6)

#loops

gapminder_mod %>% filter(continent == "Asia") %>% 
   summarise(avg = mean(lifeExp))

contin <- unique(gapminder_mod$continent)
contin

#  for (variable in list) {
#  do something
#  }

for (c in contin) {
 res <- gapminder_mod %>% filter(continent == c) %>% 
 summarise(avg = mean(lifeExp))
 print(paste0("the avg life expectancy of ",c," is ",res))
 }


#Functions

mean (2,22)

adder <- function(x,y){
    print(paste0("The sum of ", x," and ", y, " is: ", x+y))
    #return (x + y)
}
adder (2,3)




