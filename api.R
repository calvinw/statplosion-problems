# api.R

library(knitr)
library(rmarkdown)
library(statplosion)

opts_knit[["set"]](progress=FALSE)
opts_chunk[["set"]](echo=FALSE)
example_label<-function(s){}

# Generate out the problems list on startup
source("make_api_problems.R")

source("XmlPractice.R")
do_math<-function(filename) {
	doc<-read_html(filename)

	inlinespans<-xml_find_all(doc, "//span[@class='math inline']")
	lapply(inlinespans, inline_math) 

	displayspans<-xml_find_all(doc, "//span[@class='math display']")
	lapply(displayspans, display_math) 

	write_html(doc, filename)
}

make_parameters<-function(parameters) {
  newparams<-lapply(parameters, function(param) {
    if (suppressWarnings(all(!is.na(as.numeric(as.character(param)))))) {
      as.numeric(as.character(param))
    } else {
      param 
    }
  })

  return (newparams)
}


#' CORS allows requests made from external urls to be accepted
#' @filter cors
cors <- function(res) {
  res$setHeader("Access-Control-Allow-Origin", "*")
  plumber::forward()
}

#' @get /problems
#' @html
function(){
  # "<html><h1>hello world</h1></html>"
  name<-"problems"
  htmlfilename<-paste0(name, ".html")
  rmdfilename<-paste0(name, ".Rmd")
  render(rmdfilename, "html_document")
  html<-paste(readLines(htmlfilename), collapse="\n")
  return (html)
}


resizer<-'<script src="https://cdn.jsdelivr.net/npm/iframe-resizer@4.2.11/js/iframeResizer.contentWindow.min.js"></script>'
mathjax3<-'<script id="Mathjax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>'

#' Returns html fragment for rendered problem w query string
#' query string will be params like this: ?x=2&mu=3&sigma=4 
#' @get /problem/fragment/mathjax/<name>
#' @html
function(req, name){

  # query string could be anything so parse ourselves
  parameters<-plumber:::parseQS(req$QUERY_STRING)

# this prints out the request environment
# print(sapply(ls(req), function(x) get(x, envir = req)))

  #p<-lapply(parameters, as.numeric)
  p<- make_parameters(parameters)
  #print(str(p))
  filename<-paste0(name,".Rmd")
  htmlfilename<-paste0(name, ".html")
  solution<-FALSE
  render(filename, "html_fragment", params=p)

  html<-paste(readLines(htmlfilename), collapse="\n")

  html<-paste("<!DOCTYPE html>",
              "<html><head>", 
              mathjax3,
              resizer, 
              "</head><body>",
              html, 
               "</body></html>", 
              collapse="\n");

  return (html)
}


#' Returns html fragment for rendered problem w query string
#' query string will be params like this: ?x=2&mu=3&sigma=4 
#' @get /problem/fragment/pngs/<name>
#' @html
function(req, name){

  opts_chunk[["set"]](fig.retina=1)

  # query string could be anything so parse ourselves
  parameters<-plumber:::parseQS(req$QUERY_STRING)

# this prints out the request environment
# print(sapply(ls(req), function(x) get(x, envir = req)))

  # p<-lapply(parameters, as.numeric)
  p<- make_parameters(parameters)
  #print(str(p))
  filename<-paste0(name,".Rmd")
  htmlfilename<-paste0(name, ".html")
  solution<-FALSE
  render(filename, "html_fragment", params=p)

  do_math(htmlfilename)

  html<-paste(readLines(htmlfilename), collapse="\n")

 # html<-paste("<html><head>", 
 #             resizer, 
 #             "</head><body>", 
 #             html, 
 #              mathjax, 
 #              "</body></html>", 
 #             collapse="\n");
  return (html)
}


#' Returns html for rendered problem w query string
#' query string will be params like this: ?x=2&mu=3&sigma=4 
#' @get /problem/html/<name>
#' @html
function(req, name){

  # query string could be anything so parse ourselves
  parameters<-plumber:::parseQS(req$QUERY_STRING)

# this prints out the request environment
# print(sapply(ls(req), function(x) get(x, envir = req)))

  #p<-lapply(parameters, as.numeric)
  p<- make_parameters(parameters)

  filename<-paste0(name,".Rmd")
  htmlfilename<-paste0(name, ".html")
  solution<-FALSE
  # render(filename, "html_document", params=p)
  mj<-"https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"
  render(filename, html_document(mathjax=mj, 
            includes=includes(in_header="resizer.html")), params=p)
  html<-paste(readLines(htmlfilename), collapse="\n")
  return (html)
}

#* @serializer contentType list(type="text/plain")
#* @get /problem/rmarkdown/<name>
function(name){
    filename<-paste0(name,".Rmd")
    paste(readLines(filename), collapse="\n")
}

#* @html
#* @get /something
function(){
  return("<html><h1><em>Something HUGE</em></h1></html>")
}

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg=""){
  list(msg = paste0("The NEW message is: '", msg, "'"))

}

postKnit<- '<script src="https://rawcdn.githack.com/oscarmorrison/md-page/master/md-page.js"></script>
<script async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script><script src="https://cdn.jsdelivr.net/npm/iframe-resizer@4.2.11/js/iframeResizer.contentWindow.min.js"></script><noscript>' 

#* render some markdown 
#* @param md to render 
#* @html
#* @get /md
function(md=""){
  decoded_md <- URLdecode(md)
  opts_knit$set(upload.fun = image_uri)
  # knit(output="knitted.md", text=decoded_md)
  # md<-paste(readLines("knitted.md"), collapse="\n")
  # md<-paste("<!DOCTYPE html>", postKnit, md, collapse="\n");
  # return (md)

  rmd <- tempfile(pattern="", fileext=".Rmd", tmpdir = ".")
  writeLines(decoded_md, rmd)
  mj<-"https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"
  render(rmd, html_document(mathjax=mj, 
            includes=includes(in_header="resizer.html")))

  rmdWithoutExt<-sub('\\.Rmd$',"", rmd)
  tmphtml<- paste0(rmdWithoutExt, ".html")
  html<-paste(readLines(tmphtml), collapse="\n")

  file.remove(rmd)
  file.remove(tmphtml)

  return (html)
}

#* Plot a histogram
#* @png
#* @get /plot
function(){
  rand <- rnorm(100)
  hist(rand)
}

#* Plot a (normal) area between 
#* @param mu 
#* @param sigma 
#* @param x1 
#* @param x2 
#* @png (width=350, height=200)
#* @get /areabetween
function(mu="23",
         sigma="8",
         x1="15",
         x2="25"){

    mu<-as.numeric(mu)
    sigma<-as.numeric(sigma)
    x2<-as.numeric(x2)
    x1<-as.numeric(x1)

    normal_curve(mu,sigma)
    normal_shade_area_between(x1,x2,mu,sigma)
    normal_label_point(x1)
    normal_label_point(x2)
}

#* Plot a (normal) left tail area 
#* @param mu 
#* @param sigma 
#* @param x 
#* @png (width=350, height=200)
#* @get /lefttail
function(mu="23",
         sigma="8",
         x="25"){

    mu<-as.numeric(mu)
    sigma<-as.numeric(sigma)
    x<-as.numeric(x)

    normal_curve(mu,sigma)
    normal_shade_left_area(x,mu,sigma)
    normal_label_point(x)
}

#* Plot a (normal) right tail area 
#* @param mu 
#* @param sigma 
#* @param x 
#* @png (width=350, height=200)
#* @get /righttail
function(mu="23",
         sigma="8",
         x="25"){

    mu<-as.numeric(mu)
    sigma<-as.numeric(sigma)
    x<-as.numeric(x)

    normal_curve(mu,sigma)
    normal_shade_right_area(x,mu,sigma)
    normal_label_point(x)
}

#* Plot a std area between 
#* @param z1  default 1.23
#* @param z2  default 1.93
#* @png (width=350, height=200)
#* @get /stdareabetween
function(z1="1.23", 
         z2="1.93"){

    z1<-as.numeric(z1)
    z2<-as.numeric(z2)

    std_normal_curve()
    std_normal_shade_area_between(z1,z2)
    std_normal_label_point(z1)
    std_normal_label_point(z2)
}

#* Plot a std left tail area 
#* @param z  default 1.23
#* @png (width=350, height=200)
#* @get /stdlefttail
function(z="1.23"){

    z<-as.numeric(z)

    std_normal_curve()
    std_normal_shade_left_area(z)
    std_normal_label_point(z)
}

#* Plot a std right tail area 
#* @param z  default 1.23
#* @png (width=350, height=200)
#* @get /stdrighttail
function(z="1.23"){

    z<-as.numeric(z)

    std_normal_curve()
    std_normal_shade_right_area(z)
    std_normal_label_point(z)
}

#* Plot a dotplot
#* @param d data, comma separated
#* @param main title 'Dotplot' by default 
#* @param xlab x-axis label 'Values' by default 
#* @param cex  dot size 3 by default
#* @param ycex  default 1.0
#* @param xcex  default 1.0
#* @png (width=700, height=300)
#* @get /dotplot
function(d="2,3,3,4,4,5", 
         main="Dotplot",
         xlab="Values",
         cex="3",
         ycex="1.0",
         xcex="1.0"
         ){
    x<-unlist(strsplit(d, split=","))
    dotplot(as.numeric(x),
            main=main,
            xlab=xlab,
            cex=as.numeric(cex),
            ycex=as.numeric(ycex),
            xcex=as.numeric(xcex))
}

#* Return the sum of two numbers
#* @param a The first number to add
#* @param b The second number to add
#* @post /sum
function(a, b){
  as.numeric(a) + as.numeric(b)
}

#* @assets .
list()

#print('api.R running')
