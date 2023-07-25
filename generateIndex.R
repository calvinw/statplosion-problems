
# List all files in question  
files <- list.files("question") 

# Filter to only files containing "Question.Rmd"
files <- files[grepl("Question.Rmd", files)]

# Remove "Question.Rmd" from each file name
files <- sub("Question.Rmd", "", files)

# Initialize empty string 
output <- ""

# Loop through each name
for(name in files){

  # Create the text for that name
  text <- paste0(name, "Question: [html](question/", name, "Question.html)", "&nbsp;&nbsp;&nbsp;&nbsp;",  "[Rmd](question/", name, "Question.Rmd)  ", 
		 "\n",
                 name, "Solution: [html](solution/", name, "Solution.html)", "&nbsp;&nbsp;&nbsp;&nbsp;",   "[Rmd](solution/", name, "Solution.Rmd)  ",
		 "\n\n")

  # Append to output string
  output <- paste0(output, text)
}


#This creates something like this for each "Problem":
#[ProblemQuestion](question/ProblemQuestion.html)     [Rmd](question/ProblemQuestion.Rmd)  
#[ProblemSoution](solution/ProblemSolution.html)     [Rmd](solution/ProblemSolution.Rmd)  

# Write output to index.Rmd 
write(output, "index.Rmd")
cat(output)
