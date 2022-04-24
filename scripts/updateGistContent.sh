#!/bin/bash
source ~/.bash_profile

HOME_DIR_PATH="$(dirname $(realpath $0))"
JSON_FILE_PATH="${HOME_DIR_PATH}/gist_list.json"
GATSBY_HOME_PATH="${HOME_DIR_PATH}/../content/blog"

MD_FILE_EXT=".md"
GIST_USER_ID="rolroralra"
GIST_BASE_URL="gist:${GIST_USER_ID}"

TEST_YN="n"

if [ -f ${JSON_FILE_PATH} ]
then
	rm -f ${JSON_FILE_PATH} ${JSON_FILE_PATH}
fi

# Get Current Update Gists
bash ${HOME_DIR_PATH}/getCurrentUpdateGistList.sh > ${JSON_FILE_PATH}

if [ ! -f ${JSON_FILE_PATH} ]
then
	echo
	echo "[WARNING] There is no json output file for NEW BLOG CONTENTS"
	echo "[ERROR] Failed to get current gist."
	echo
  exit 1
fi

jq -c '.[]' ${JSON_FILE_PATH} | while read INPUT; do
	GIST_ID=$(echo ${INPUT} | jq -r .id)
	FILENAME_ARRAY=$(echo ${INPUT} | jq -r .filename)
	DESCRIPTION=$(echo ${INPUT} | jq -r .description)
	CREATED_AT=$(echo ${INPUT} | jq -r .created_at)
	UPDATED_AT=$(echo ${INPUT} | jq -r .updated_at)

	TITLE="Hello ${DESCRIPTION}"
	DIR_NAME=$(echo ${TITLE%%${MD_FILE_EXT}} | cut -c -20 | sed -e 's/ /-/g' | sed -e 's/,/_/g' | sed -e 's/\//_/g')
	DIR_PATH="${GATSBY_HOME_PATH}/${DIR_NAME}"
	CONTENT_FILE_PATH="${DIR_PATH}/index.md"
	
	# DEBUG
	if [ ${TEST_YN} = "y" -o ${TEST_YN} = "Y" ]
	then
		echo "GIST_ID: ${GIST_ID}"
		echo "FILENAME_ARRAY: ${FILENAME_ARRAY}"
		echo "DESCRIPTION: ${DESCRIPTION}"
		echo "CREATED_AT: ${CREATED_AT}"
		echo "UPDATED_AT: ${UPDATED_AT}"
		echo "CONTENT_FILE_PATH: ${CONTENT_FILE_PATH}"
	fi

	if [ ! -d ${DIR_PATH} ]
	then
		mkdir -p ${DIR_PATH}
	fi	
	
	if [ -f ${CONTENT_FILE_PATH} ]
	then
		rm -f ${CONTENT_FILE_PATH}
	fi
	
	MD_INFO="---\ntitle: ${TITLE}\ndate: ${UPDATED_AT}\ndescription: ${DESCRIPTION}\n"
	echo -n -e ${MD_INFO} >> ${CONTENT_FILE_PATH}

	echo ${FILENAME_ARRAY} | jq -c '.[]' | while read FILE_NAME; do
		FILE_NAME=$(echo -n ${FILE_NAME} | jq -r ".")
		MD_CONTENT="---\n\n## ${FILE_NAME%%${MD_FILE_EXT}}\n\`${GIST_BASE_URL}/${GIST_ID}#${FILE_NAME}\`\n"
		echo -n -e ${MD_CONTENT} >> ${CONTENT_FILE_PATH}
	done
	
	ls -lt ${CONTENT_FILE_PATH}
	echo
done


echo
ls -lt ${GATSBY_HOME_PATH}
echo
echo
