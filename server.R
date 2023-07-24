library("plumber")

# 'api.R' defines our api 
plumbr <- plumb("api.R")

# get port number from environment variable
port <- strtoi(Sys.getenv("PORT"))
if(is.na(port)) { 
    port <- 8080
}
plumbr$run(port=port, 
           host='0.0.0.0', 
           swagger=TRUE)
