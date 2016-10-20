drop table flexternal_cried_view cascade;
CREATE FLEX EXTERNAL TABLE flexternal_cried() AS copy SOURCE curl(url='http://10.20.71.30:9200/sessionmsg/_search?size=1000000&q=msg:cried') PARSER FJSONParser(start_point='hits', start_point_occurrence=2);
select compute_flextable_keys_and_build_view('flexternal_cried');
insert into es_search_results select _id,_index,_score::float,"_source.is_positive"::boolean,substring("_source.msg",1,1500) ,"_source.roomid"::integer,"_source.roominstanceid"::integer,"_source.senderid"::integer,"_source.sessionid",_type, 'cried' as search_term from flexternal_cried_view;
