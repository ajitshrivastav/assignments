#install.packages("dummy", repos="http://cran.rstudio.com/")
library(dummy)
library(stringr)
# Load csv file in a data frame
original_prods <- read.csv("data_wrangling_ex_1/data/refine_original.csv")
# standardize company names to lower case
products_df <- original_prods %>% mutate(company=tolower(company))

# get all the unique company list to proceed with cleanup
unique(products_df$company)

# If company contains lips or phil, set it as philips
# If company name starts with ak, set it as akzo
# If company name contains uni or lever, set it as unilever
# If company name starts with van, set it as van houten
products_df <- products_df %>% mutate(company=ifelse(grepl("lips|phil", company), "philips", company)) %>% mutate(company=ifelse(grepl("^ak", company), "akzo", company))  %>% mutate(company=ifelse(grepl("uni|lever", company), "unilever", company)) %>% mutate(company=ifelse(grepl("^van", company), "van houten", company))

# Add a new field product_code, extract from Product.code...number
products_df <- products_df %>% mutate(product_code=substr(Product.code...number, 1, unlist(gregexpr(pattern ='-',Product.code...number))-1)
)

# Add a new field product_number, extract from Product.code...number
products_df <- products_df %>% mutate(product_number=substr(Product.code...number, unlist(gregexpr(pattern ='-',Product.code...number))+1, str_length(Product.code...number))
)

# Add a new field product_category, and map values from product_code
products_df <- products_df %>% mutate(product_category=ifelse(grepl("p", product_code), "Smartphone", "N/A")) 
products_df <- products_df %>% mutate(product_category=ifelse(grepl("v", product_code), "TV", product_category))
products_df <- products_df %>% mutate(product_category=ifelse(grepl("x", product_code), "Laptop", product_category))
products_df <- products_df %>% mutate(product_category=ifelse(grepl("q", product_code), "Tablet", product_category))

# Add a new field full_address, and map values from address, city, country
products_df <- products_df %>% mutate(full_address=paste(address, city, country, sep = ','))
products_df <- products_df %>% select (company, product_code, product_number, product_category, name, full_address)
products_df

# Both the company name and product category are categorical variables i.e. they take only a fixed set of values. In order to use them in further analysis you need to create dummy variables. Create dummy binary variables for each of them with the prefix company_ and product_ i.e.
# Add four binary (1 or 0) columns for company: company_philips, company_akzo, company_van_houten and company_unilever
# Add four binary (1 or 0) columns for product category: product_smartphone, product_tv, product_laptop and product_tablet
# for(level in unique(example$strcol)){
#   example[paste("dummy", level, sep = "_")] <- ifelse(example$strcol == level, 1, 0)
# }
### Question, how can i create dummy variables for selected columns, dummy() API does not give an option to specify set of columns for which dummy variable is to be created
product_df_dummy <- products_df %>% select (company, product_category)
product_df_dummy <- dummy(product_df_dummy)
str(products_df)
str(product_df_dummy)
product_df_dummy
#dummy(products_df)

