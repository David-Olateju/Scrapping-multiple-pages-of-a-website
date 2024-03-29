# WEB SCRAPPING MULTIPLE PAGES

Taking it off from where we stopped at the last project, where a single page was scrapped. To get a quick recap, you can follow the link provided, https://github.com/David-Olateju/eCommerce-site-Scrapping-in-R.git,
to have a quick glance of it.

In this project, multiple pages of the eCommerce website (Jumia's) that we have been using will be scrapped, and we will focus on the "Phone and Tablets" section. 
Let's begin: 

## LOADING THE LIBRARIES
 1. rvest: the library for scrapping the data
 2. dplyr: library for data manipulation.
```{r}
library(rvest)
library(dplyr)
```

## CREATING AN EMPTY DATARAME.
An empty dataframe with the variable name, "phones" will be created for storing the data that will be scraped from the site.
```{r}
phones= data.frame()
```

## MAKING CLEAR OF WHAT TO SCRAPE
What we want from each page are; product's name, original pice, discount, discount price, and ratings.
Referencing a single page scrapped from the last project (you can follow this link to check it out; https://github.com/David-Olateju/eCommerce-site-Scrapping-in-R.git) 
The Tag name for each distinct class needed is the same in all pages, so we only need to iterate over them, to get the desired results.


## SCRAPPING THE DATA

```{r}


for(page_result in seq(from= 1, to= 50, by= 1)) {
  link= paste0("https://www.jumia.com.ng/mlp-stay-connected-deals/smartphones/?page=", 
              page_result,"#catalog-listing")
  
  page = read_html(link)
  name= html_nodes(page, ".name") %>%  html_text2()
  original_price= html_nodes(page, ".old") %>%  html_text2()
  discount= html_nodes(page, "._sm") %>%  html_text2()
  discount_price= html_nodes(page, ".prc") %>% html_text2()
  ratings= html_nodes(page, ".rev") %>%  html_text2()
  
  max_length = max(c(length(names), length(original_price), length(discount), length(discount_price), length(ratings)))
  
  phones= rbind(phones, data.frame(
    name= c(name, rep(NA, max_length - length(name))),
    original_price= c(original_price, rep(NA, max_length - length(original_price))),
    discount= c(discount, rep(NA, max_length - length(discount))),
    discount_price= c(discount_price, rep(NA, max_length - length(discount_price))),
    ratings= c(ratings, rep(NA, max_length - length(ratings)))
  )) 
  
  print(paste("Page:", page_result))
  
}

```

### EXPLAINING THE CODES
##### FINDING PATTERNS AND ITERATION
The secrets to scrapping multiple pages are, finding a pattern in the pages and iterating over them by using a "for-loop".
Before iterating over the web pages, you must make sure to look at the links and find the patterns of increment for the web pages, as this will determine the values you will use to iterate over the pages. Using our case study's first 4 pages below:
link_to_page_1=  https://www.jumia.com.ng/phones-tablets/
link_to_page_2 = https://www.jumia.com.ng/phones-tablets/?page=2#catalog-listing
link_to_page_3 = https://www.jumia.com.ng/phones-tablets/?page=3#catalog-listing
link_to_page_4 = https://www.jumia.com.ng/phones-tablets/?page=4#catalog-listing

From the links above, can you derive a pattern?
Yes, each pages has its form of index number, "page=2", "page=3", "page=4". and so on. So, we can deduce from there that, the page increments by 1, and you can then add the detected pattern to the first page link, so that it'll become, "https://www.jumia.com.ng/phones-tablets/?page=1#catalog-listing" in your Browser, then reload it. so it'd be saved. 
From here, we can scrape the data we want one after the other in different pages, but with a "for-loop", it will be faster and easier.

Moving on, from the pattern detected from above, we can set the values for "seq()" function to, create a sequence(from 1, to 50, and increase by 1). That explains the reason we have to use a "for" loop and the seq() function will iterate over all the pages till it gets to the last one, page 50 as shown below;

```
for(page_result in seq(from= 1, to= 50, by= 1)) {
  link= paste0("https://www.jumia.com.ng/mlp-stay-connected-deals/smartphones/?page=", 
              page_result,"#catalog-listing")
```


##### GETTING THE NEEDED OBSERVATIONS FROM THE PAGES
The block of code below scrapes the name, original_price, discount, discount_price and ratings using their tag names.
To get a better description of the code, you can check it out from this project's link, https://github.com/David-Olateju/eCommerce-site-Scrapping-in-R.git
```
  page = read_html(link)
  name= html_nodes(page, ".name") %>%  html_text2()
  original_price= html_nodes(page, ".old") %>%  html_text2()
  discount= html_nodes(page, "._sm") %>%  html_text2()
  discount_ price= html_nodes(page, ".prc") %>% html_text2()
  ratings= html_nodes(page, ".rev") %>%  html_text2()
```


##### SORTING OUT THE IRREGULARITIS DUE TO DIFFERENCES IN NUMBERS OF ROWS
When I tried to create a data frame using the technique I used in the last project, i got an error, which is shown below;
![N](https://github.com/David-Olateju/Scrapping-multiple-pages-of-a-website/assets/129637983/aad41b6f-0d99-474e-ba40-169206299883)

This error referred to the differences in row numbers, that is, for exampele, the "name" feature had 40 rows, the "original_price" column, 39 and the "discount", 38.
This could have been that, 1 product did not have any dicount offer, hence they was an empty row for "discount" column.

To take care of this error, the code below had to be use: 

```
  max_length = max(c(length(names), length(original_price), length(discount), length(discount_price), length(ratings)))
```
The length of all the features were recorded, but the feature with the maximum number of rows was assigned to the variable, max_length.


##### BINDING THE ROWS AND IMPORTANCE OF max_length
```
 phones= rbind(phones, data.frame(
    name= c(name, rep(NA, max_length - length(name))),
    original_price= c(original_price, rep(NA, max_length - length(original_price))),
    discount= c(discount, rep(NA, max_length - length(discount))),
    discount_price= c(discount_price, rep(NA, max_length - length(discount_price))),
    ratings= c(ratings, rep(NA, max_length - length(ratings)))
  ))
 
```

The importance of max_length is that, from the max_length gotten above, it's been explained that, there were differences in the row numbers.
Each feature will be filled with the data gotten from each page, using its tag name, and the remaining blank rows for any feature will be filled by
the specified character, in our case, "NA". The general structure of the line is given below;

feature= c(feature, rep(what_to_fill_blank_rows_with, max_length - length(feature)))

The feature was first filled with the observations, then the length of the feature will be subtracted from the maximum length (max_length gotten from above), 
the result of this subtraction will then be filled with "NA", as specified.


## TAKING A LOOK AT THE DATA
![a](https://github.com/David-Olateju/Scrapping-multiple-pages-of-a-website/assets/129637983/4985f243-22f4-4670-b6ee-c10c8d9cbc67)

There were 4000 rows of data, after scrapping and 5 columns.


## CONVERTING AND WRITING IT AS A CSV FILE
With that, all 50 pages will be scrapped and you'll convert it to a csv file using the code below:
```{r}
write.csv(phones, "Jumia_Phones_and_Tablets.csv")

```

# THE END.
Thanks for reading through.


Do you wish to sharpen/shopw off your Data Cleaning skills, you can have a go at the dataset here, https://github.com/David-Olateju/Scrapping-multiple-pages-of-a-website/blob/10149fa3c1f1f4b9c3775cbbe0f8bffc88d80d55/Jumia_Phones_and_Tablets.csv
