library("xml2")

inline_math<-function(span) {
	latex<-xml_text(span)

	# We need to remote the delimters 
	latex<-sub("\\(", "", latex, fixed=T)
	latex<-sub("\\)", "", latex, fixed=T)

	latex<-trimws(latex)
	latex<-gsub("[\r\n\t]","", latex)
    latex<-URLencode(latex)
	latex<-gsub("+","%2B", latex, fixed=T)

	url<-paste0("https://chart.googleapis.com/chart?cht=tx&chl=", latex)
	imgtag<-paste0("<img src=", url, " style='vertical-align:text-top'></img>")

	html<-read_html(imgtag)
	img<-xml_find_first(html, "//img")

	# We replace the span with img 
	xml_replace(span, img)
}

display_math<-function(span) {
	latex<-xml_text(span)

	# We need to remove the equation begin and end for google latex
	latex<-sub("\\[\\begin{equation}", "", latex, fixed=T)
	latex<-sub("\\end{equation}\\]", "", latex, fixed=T)

	# We need to remove the align begin and end for google latex
	latex<-sub("\\[\\begin{align}", "", latex, fixed=T)
	latex<-sub("\\end{align}\\]", "", latex, fixed=T)

	# this is since google latex cannot undertand &= for align eqns 
	latex<-gsub("&", "", latex, fixed=T)

	# We need to add some space between lines too!
	latex<-gsub("\\\\", "\\\\[10px]", latex, fixed=T)

	latex<-gsub("$$", "", latex, fixed=T)

	# trim white space, tabs, newlines, inner spaces 
	latex<-trimws(latex)
	latex<-gsub("[\r\n\t]","", latex)
    latex<-URLencode(latex)
	latex<-gsub("+","%2B", latex, fixed=T)

	# wrap it in a div so we can center the img. 
	url<-paste0("https://chart.googleapis.com/chart?cht=tx&chl=", latex)
	divtag<-paste0("<div style='text-align:center'><img src=", url, "></img></div>")

	html<-read_html(divtag)
	div<-xml_find_first(html, "//div")

	# We replace the span with div with img inside 
	xml_replace(span, div)
}

# doc<-read_html("Equations.html")
#
# inlinespans<-xml_find_all(doc, "//span[@class='math inline']")
# lapply(inlinespans, inline_math) 
#
# displayspans<-xml_find_all(doc, "//span[@class='math display']")
# lapply(displayspans, display_math) 
#
# write_html(doc, "EquationsOut.html")
