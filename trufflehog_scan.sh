#!/bin/bash



ORG_NAME="leapfrogtechnology"

DEST_FOLDER="github_repositories"

REPORT_FILE="trufflehog_report.txt"



#.....function to scan repository with Trufflehog.........

scan_repo_with_trufflehog() {

	    REPO_PATH="$1"

	        REPO_NAME="$2"

		    echo "Scanning $REPO_NAME ($REPO_PATH) with Trufflehog..."

		        echo "Repository: $REPO_NAME" >> "$REPORT_FILE"

			    trufflehog --regex --entropy=False --rules aws_key,terraform --repo_path "$REPO_PATH" "git_placeholder" >> "$REPORT_FILE"

			        echo "" >> "$REPORT_FILE" # Add an empty line for better readability

			}



			##.........get list of repositories............

			REPOS_URL="https://api.github.com/orgs/$ORG_NAME/repos?type=public"

			REPOS=$(curl -s "$REPOS_URL" | jq -r '.[].html_url')



			#........create destination folder if it doesn't exist.........

			mkdir -p "$DEST_FOLDER"



			#....clone repositories..........

			for REPO_URL in $REPOS; do

				    REPO_NAME=$(basename "$REPO_URL" .git)

				        echo "Cloning $REPO_NAME..."

					    git clone "$REPO_URL" "$DEST_FOLDER/$REPO_NAME"



					        #...scan cloned repository with Trufflehog.........

						    scan_repo_with_trufflehog "$DEST_FOLDER/$REPO_NAME" "$REPO_NAME"

					    done



					    echo "All repositories cloned into $DEST_FOLDER"

					    echo "Trufflehog scan complete. Results stored in $REPORT_FILE"




