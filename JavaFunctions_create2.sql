/*****************************
 * Vertica Analytic Database
 *
 * Example SQL for User Defined Scalar Functions
 *
 * Copyright (c) 2005 - 2014 Vertica, an HP company
 */


-- Step 1: Create LIBRARY 
\set libSfile '\''`pwd`'/build/JavaScalarLib.jar\''
\set libTfile '\''`pwd`'/build/JavaTransformLib.jar\''

CREATE LIBRARY JavaScalarFunctions AS :libSfile DEPENDS '/opt/vertica/bin/elasticsearch-1.4.4.jar:/opt/vertica/bin/lucene-core-4.10.3.jar:/opt/vertica/bin/lucene-analyzers-common-4.10.3.jar' LANGUAGE 'JAVA';
CREATE LIBRARY JavaTransformFunctions AS :libTfile DEPENDS '/opt/vertica/bin/elasticsearch-1.4.4.jar:/opt/vertica/bin/lucene-core-4.10.3.jar:/opt/vertica/bin/lucene-analyzers-common-4.10.3.jar' LANGUAGE 'JAVA';
-- Step 2: Create Functions
CREATE FUNCTION add2ints AS LANGUAGE 'Java' NAME 'com.vertica.JavaLibs.Add2intsInfo' LIBRARY JavaScalarFunctions;
CREATE FUNCTION ELKadd2ints AS LANGUAGE 'Java' NAME 'com.vertica.JavaLibs.ELKAdd2intsInfo' LIBRARY JavaScalarFunctions;
CREATE FUNCTION ELKadd2intsAcct AS LANGUAGE 'Java' NAME 'com.vertica.JavaLibs.ELKAdd2intsInfoAcct' LIBRARY JavaScalarFunctions;
CREATE FUNCTION ElasticCount AS LANGUAGE 'Java' NAME 'com.vertica.JavaLibs.ElasticSearchCount' LIBRARY JavaScalarFunctions;
CREATE FUNCTION addanyints AS LANGUAGE 'Java' NAME 'com.vertica.JavaLibs.AddAnyIntsInfo' LIBRARY JavaScalarFunctions;


CREATE TRANSFORM FUNCTION topk AS LANGUAGE 'Java' NAME 'com.vertica.JavaLibs.TopKFactory' LIBRARY JavaTransformFunctions;
CREATE TRANSFORM FUNCTION ElasticCountT AS LANGUAGE 'Java' NAME 'com.vertica.JavaLibs.ElasticSearchCountTransform' LIBRARY JavaTransformFunctions;
CREATE TRANSFORM FUNCTION polytopk  AS LANGUAGE 'Java' NAME 'com.vertica.JavaLibs.PolyTopKFactory' LIBRARY JavaTransformFunctions;
CREATE TRANSFORM FUNCTION topkwithparams AS LANGUAGE 'Java' NAME 'com.vertica.JavaLibs.TopKPerPartitionWithParamsFactory' LIBRARY JavaTransformFunctions;


-- Step 3: Use Functions

