library(rvest)
library(dplyr)

phones= data.frame()

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

write.csv(phones, "Jumia_Phones_and_Tablets")