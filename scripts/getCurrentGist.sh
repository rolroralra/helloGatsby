#!/bin/bash
HOME_DIR_PATH="$(dirname $(realpath $0))"

JQ_QUERY='[.[] | {"id":.id, "filename":([.files | to_entries[] | .value.filename]), "description":.description, "created_at":.created_at,"updated_at":.updated_at}]'
curl https://api.github.com/users/rolroralra/gists 2>/dev/null | jq -r "${JQ_QUERY}"

