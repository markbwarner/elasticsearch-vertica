   echo "truncate table es_search_results;"
NAMES="$(< names.txt)" #names from names.txt file
for NAME in $NAMES; do
    echo "drop table flexternal_"$NAME"_view cascade;"
    echo "CREATE FLEX EXTERNAL TABLE flexternal_"$NAME"() AS copy SOURCE curl(url='http://10.20.71.30:9200/sessionmsg/_search?size=1000000&q=msg:"$NAME"') PARSER FJSONParser(start_point='hits', start_point_occurrence=2);"
    echo "select compute_flextable_keys_and_build_view('flexternal_"$NAME"');"
    echo "insert into es_search_results select _id,_index,_score::float,\"_source.is_positive\"::boolean,substring(\"_source.msg\",1,1500) ,\"_source.roomid\"::integer,\"_source.roominstanceid\"::integer,\"_source.senderid\"::integer,\"_source.sessionid\",_type, '$NAME' as search_term from flexternal_"$NAME"_view;"
done
echo "commit;"
