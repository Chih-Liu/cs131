# set input field separator as comma for CSV files 
BEGIN{
	FS = ","
}

# skip the first row
NR == 1{ next }

# process each student record
{
	name = $2  # get studetn name (col 2)
	sum = 0    # initialize sum of grades for this student
	
	# loop through all grade columns (starting from col 3)
	for (i = 3; i <= NF; i++) {
		sum += $i  # add each grade to sum
	}

	total[name] = sum    # store total in associative array
	count[name] = NF - 2   # store number of subjects for this student

	# update max score and corresponding student name
        if (max_score == "" || sum > max_score) {
		max_score = sum
		max_student = name
	}

	# update min score and corresponding student name
	if (min_score == "" || sum < min_score) {
		min_score = sum
		min_student = name
	}
}

# function to calculate average score
function avg(total, n) {
	return total / n
}

# executed after processing all input lines
END{
	# iterate over all students in the total[] array
       for (student in total) {
	       a = avg(total[student], count[student]) # calculate average score

	       # determine pass/fail status
	       if (a >= 70) {
		       status = "Pass"
		} else {
			status = "Fail"
		}

		# print student information
	  	printf "%s: Total=%d, Average=%.2f, Status=%s\n", student, total[student], a, status
	     }

	     # print top and lowest scoring students
	     printf "Top student: %s with score %d\n", max_student, max_score
	     printf "Lowest student: %s with score %d\n", min_student, min_score
     	}	     
