#!/usr/bin/env bash

# CS2102 Assignment 3

test_query() {
	local view_name=$1
	local query=$2

	local soln_output_file="${soln_dir}/${view_name}.txt"
	local your_output_file="${your_dir}/${view_name}.txt"
	local diff_file="${diff_dir}/${view_name}.txt"

	if ! (psql -c "${query}" &> "${your_output_file}" ); then
		pass=false
		echo "ERROR: The view definition for ${view_name} has an error! Refer to ${your_output_file}"
	else
		diff "${your_output_file}" "${soln_output_file}" > "${diff_file}"
		if [ $? -ne 0 ]; then
		    pass=false
		    echo "ERROR: The output of view ${view_name} does not matched the solution file for database instance db${dbnum}! Refer to ${diff_file}"
		fi
	fi
}


test_queries() {
	pass=true
	test_query q1 "select * from q1 order by rname;"
	test_query q2 "select * from q2 order by pizza;"
	test_query q3 "select * from q3 order by cname;"
	test_query q4 "select * from q4 order by rname1, rname2;"
	test_query q5 "select * from q5 order by cname;"
	test_query q6 "select * from q6 order by rname;"
	test_query q7 "select * from q7 order by rname, pizza1, pizza2, pizza3, totalPrice;"
	test_query q8 "select * from q8 order by rname;"
	test_query q9 "select * from q9 order by area, numCustomers, numRestaurants, maxPrice;"
	test_query q10 "select * from q10 order by rname;"

	if $pass; then
		echo "Your queries passed the tests on database instance db${dbnum}."
	else
		echo "Your queries failed some test on database instance db${dbnum}."
	fi
}

load_data() {
sed "s@/db[0-9]*/@/db${dbnum}/@"  <<EOF | psql
DELETE FROM Likes;
DELETE FROM Sells;
DELETE FROM Restaurants;
DELETE FROM Customers;
DELETE FROM Pizzas;
\COPY Pizzas FROM 'data/db1/pizzas.csv' WITH (FORMAT csv, DELIMITER ',');
\COPY Restaurants FROM 'data/db1/restaurants.csv' WITH (FORMAT csv, DELIMITER ',');
\COPY Customers FROM 'data/db1/customers.csv' WITH (FORMAT csv, DELIMITER ',');
\COPY Sells FROM 'data/db1/sells.csv' WITH (FORMAT csv, DELIMITER ',');
\COPY Likes FROM 'data/db1/likes.csv' WITH (FORMAT csv, DELIMITER ',');
EOF
}

assign_file=assign3.sql
soln_dir=solution-files
your_dir=your-solution
diff_dir=diff-dir

if [ ! -e "${assign_file}" ]; then
	echo "ERROR: ${assign_file} is missing in ${pwd}"
	exit 1
fi

if [ $# -eq 0 ]; then
	dblist="1 2 3 4 5 6 7"
else
	dblist="$@"
fi


mkdir -p "${your_dir}"
mkdir -p "${diff_dir}"

# create views
psql -E < "$assign_file" >&2


for dbnum in ${dblist}
do
	echo "Testing on database instance db${dbnum} ..."
	soln_dir=solution-files/db${dbnum}
	your_dir=your-solution/db${dbnum}
	diff_dir=diff-dir/db${dbnum}
	\rm -rf ${your_dir} 2>/dev/null
	mkdir ${your_dir} 
	\rm -rf ${diff_dir} 2>/dev/null
	mkdir ${diff_dir} 
	load_data
	test_queries
done

