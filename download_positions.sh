#!/bin/bash 

# Create an output dir named as today's date formated as YYYYMMDD which will hold all files
output_dir="$(date +%Y%m%d)";
mkdir ${output_dir};

# Save positions listening as an html file
echo "Saving positions listing as ${output_dir}/all_positions.html";
wget --no-verbose "https://postdocs.stanford.edu/prospective/opportunities?field_stanford_department_target_id=All&field_s_person_first_name_value=&field_s_person_last_name_value=&items_per_page=300" -O "${output_dir}/all_positions.html";

# Loop over all oportunities and download files in parallel (launch one child process for each)
for url in $(grep -o "open-postdoctoral-position-faculty-mentor.*\">" "${output_dir}/all_positions.html" | perl -pe "s/\">$//"); do
    ( wget --no-verbose "https://postdocs.stanford.edu/prospective/opportunities/${url}" -O ${output_dir}/${url}.html) &
    done

# wait for child processes to finish
wait;

echo "Download completed!!";
