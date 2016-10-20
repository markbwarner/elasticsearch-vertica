/* Copyright (c) 2005 - 2014, Hewlett-Packard Development Co., L.P.  -*- Java -*-*/
/* 
 *
 * Description: Example User Defined Scalar Function: Add 2 ints
 *
 * Create Date: June 1, 2013
 */

package com.vertica.JavaLibs;

import com.vertica.sdk.*;

import java.text.NumberFormat;
import java.text.ParsePosition;
import java.util.Arrays;
import java.util.Collection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
 
import org.elasticsearch.action.count.CountResponse;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.search.SearchType;
import org.elasticsearch.client.transport.TransportClient;
import org.elasticsearch.common.settings.ImmutableSettings;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.index.query.QueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.query.MatchQueryBuilder.Type;
import org.elasticsearch.search.SearchHit;

public class ElasticSearchCount extends ScalarFunctionFactory {

	TransportClient client = null;
	static int MAXROWS = 1;
	static String indexName = "sessionmsg";

public void ElasticSearchCount()
{
	vol = ScalarFunctionFactory.volatility.IMMUTABLE;
	
}


	@Override
	public void getPrototype(ServerInterface srvInterface,
			ColumnTypes argTypes, ColumnTypes returnType) {
		// field name in ELK to search for 'senderid'
		argTypes.addVarchar();
		// field value from table to match senderid
		argTypes.addInt();
		// term to look for.
		argTypes.addVarchar();
		// type of search wild card or not.(wildcard,term)
		argTypes.addVarchar();
		// argTypes.addInt();
		// Return value is the number of time term appears.
		// returnType.addVarchar();
		returnType.addInt();
	}

	public class ElasticCount extends ScalarFunction {
		@Override
		
		
		public void setup(ServerInterface srvInterface, SizedColumnTypes argTypes) {
			
			 
			//Settings settings = ImmutableSettings.settingsBuilder()
			//		.put("client.transport.sniff", true).build();
			Settings settings = ImmutableSettings.settingsBuilder()
					   .put("cluster.name", "elasticsearchpart").build();
			client = new TransportClient(settings)
					.addTransportAddress(new InetSocketTransportAddress(
							"172.16.116.35", 9300));

		}
		
		public void destroy(ServerInterface srvInterface, SizedColumnTypes argTypes) {
			client.close();

		}
		
		public void processBlock(ServerInterface srvInterface,
				BlockReader arg_reader, BlockWriter res_writer)
				throws UdfException, DestroyInvocation {

			// Integer[] lngHit = new Integer[MAXROWS];
			// String[] strHit = new String[MAXROWS];

			do {
				String field_toSearch = arg_reader.getString(0);

				long field_value = arg_reader.getLong(1);

				String search_term = arg_reader.getString(2);

				String search_type = arg_reader.getString(3);

				boolean valid_nbr = true;

				CountResponse response;
				SearchHit[] results;

				long nbrofrows = 0;
				if (valid_nbr) {
					QueryBuilder qb = null;

					if (search_type.equalsIgnoreCase("term")) {

						qb = QueryBuilders
								.boolQuery()
								.must(QueryBuilders.termQuery(field_toSearch,
										field_value))
								.must(QueryBuilders.termQuery("msg",
										search_term));
					} else {
						String search_term_w = "*" + search_term + "*";
						qb = QueryBuilders
								.boolQuery()
								.must(QueryBuilders.termQuery(field_toSearch,
										field_value))
								.must(QueryBuilders.wildcardQuery("msg",
										search_term_w));

					}

					response = client.prepareCount(indexName).setQuery(qb)
							.execute().actionGet();

					// results = response.getHits().getHits();

					nbrofrows = response.getCount();

					// res_writer.setLong(nbrofrows);

				}

				res_writer.setLong(nbrofrows);

				res_writer.next();

			} while (arg_reader.next());


		}

	}

	/*
	 * @Override public void getReturnType(ServerInterface srvInterface,
	 * SizedColumnTypes argTypes, SizedColumnTypes returnType) {
	 * returnType.addVarchar(50); }
	 */
	@Override
	public ScalarFunction createScalarFunction(ServerInterface srvInterface) {
		return new ElasticCount();
	}
}
