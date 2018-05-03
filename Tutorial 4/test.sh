#!/usr/bin/env bash

# CS2102 Tutorial 4 Question 2

test_query() {
	local view_name=$1
	local query=$2

	local your_output_file="${your_dir}/${view_name}.txt"
	local soln_output_file="${soln_dir}/${view_name}.txt"
	local diff_file="${diff_dir}/${view_name}.txt"

	if ! (psql -c "${query}" &> "${your_output_file}" ); then
		pass=false
		echo "ERROR: The view definition for ${view_name} has an error! Refer to ${your_output_file}"
	else
		diff "${your_output_file}" "${soln_output_file}" > "${diff_file}"
		if [ $? -ne 0 ]; then
		    pass=false
		    echo "ERROR: The output of view ${view_name} does not matched the provided solution file! Refer to ${diff_file}"
		fi
	fi
}


test_queries()
{
	\rm -f ${your_dir}/*.txt 2>/dev/null
	pass=true
	test_query qa "select * from qa order by rname, maxprice;"
	test_query qb "select * from qb order by rname, avgprice;"
	test_query qc "select * from qc order by rname, avgprice;"
	test_query qd "select * from qd order by rname, totalprice;"
	test_query qe "select * from qe order by cname1, cname2;"
	if $pass; then
		echo "Your queries passed the tests on the provided database instance."
		exit 0
	else
		exit 1
	fi
}

assign_file=tut4.sql
soln_dir=solution-files
your_dir=your-solution
diff_dir=diff-dir

if [ ! -e "${assign_file}" ]; then
	echo "ERROR: ${assign_file} is missing in ${pwd}"
	exit 1
fi

rm -rf "${your_dir}"  2>/dev/null
rm -rf "${diff_dir}"  2>/dev/null
mkdir "${your_dir}"
mkdir "${diff_dir}"


psql -E < "$assign_file" >&2
test_queries

