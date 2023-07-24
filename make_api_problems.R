library("knitr")

files <- list.files(pattern = "\\.Rmd$")
files<-grep(files, pattern="index", inv=T,value=T)
files<-grep(files, pattern="problem", inv=T,value=T)
problems<-gsub(files, pattern=".Rmd$", replacement="")

mylines<-c("# Statplosion \n",
           "## Problems (Full webpage with Mathjax) \n",
           "The problem link renders a problem with default params.   ",
           "Change the params and submit again to re-render.   ",
           "\n")

mylines2<-c("## Fragment with Mathjax\n")
mylines3<-c("## Fragment with Pngs (for pasting to emails)\n")
mylines4<-c("## Rmarkdown \n")

for(problem in problems) { 
    text <- readLines(paste0(problem,".Rmd"))
    knit_params <- knitr::knit_params(text)
    params <- purrr::map(knit_params, "value")
    names<-names(params)
    querys<-c()
    for(key in names) { 
       query<-paste0(key,"=",params[[key]])
       querys<-c(querys, query)
    }
    finalquerystring<-paste(querys, collapse="&")
    l<-paste0(problem,"?",finalquerystring)

    # part1<-paste0(problem, ":", "\n")
    # part2<-paste0(problem, ":", "\n")
    # part3<-paste0(problem, ":", "\n")
    # part4<-paste0(problem, ":", "\n")

    part1<-paste0("[", l, "]", "(problem/html/", l, ")","  ")
    part2<-paste0("[", l, "]", "(problem/fragment/mathjax/", l, ")", "  ")
    part3<-paste0("[", l, "]", "(problem/fragment/pngs/", l, ")", "  ")
    part4<-paste0("[", l, "]", "(problem/rmarkdown/", l, ")", "  ")


    mylines<-c(mylines, part1)
    mylines2<-c(mylines2, part2)
    mylines3<-c(mylines3, part3)
    mylines4<-c(mylines4, part4)
}

mylines<- c(mylines, "\n", mylines2, "\n", mylines3, "\n", mylines4)
fileConn<-file("problems.Rmd")
writeLines(mylines, fileConn)
close(fileConn)
