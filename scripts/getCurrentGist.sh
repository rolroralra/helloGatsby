#!/bin/bash
HOME_DIR_PATH="$(dirname $(realpath $0))"

#JSON_FILE_PATH="${HOME_DIR_PATH}/gist_rolroralra.json"

if [ -f ${JSON_FILE_PATH} ]
then
	rm -f ${JSON_FILE_PATH}
fi

JQ_QUERY='[.[] | {"id":.id, "filename":([.files | to_entries[] | .value.filename]), "description":.description, "created_at":.created_at,"updated_at":.updated_at}]'
#curl https://api.github.com/users/rolroralra/gists | jq -r "${JQ_QUERY}" > ${JSON_FILE_PATH}
curl https://api.github.com/users/rolroralra/gists 2>/dev/null | jq -r "${JQ_QUERY}"

echo
#echo
#echo "[OUTPUT]"
#echo "$(ls -lt ${JSON_FILE_PATH})"
#echo
