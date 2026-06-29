
create table widecol.widecol_test(
    w_id        integer not null,/*{{ rownum }}*/
    w_ytd       decimal(12,2),/*{{ 300000.0 }}*/
    w_tax       decimal(4,4),/*{{ rand.range_inclusive(0, 2000)/10000 }}*/
    w_name      varchar(10),/*{{ rand.regex('[0-9a-zA-Z]{6,10}') }}*/
    w_street_1  varchar(20),/*{{ rand.regex('[0-9a-zA-Z]{10,20}') }}*/
    w_street_2  varchar(20),/*{{ rand.regex('[0-9a-zA-Z]{10,20}') }}*/
    w_street_3  varchar(20),/*{{ rand.regex('[0-9a-zA-Z]{10,20}') }}*/
    w_city      varchar(20),/*{{ rand.regex('[0-9a-zA-Z]{10,20}') }}*/
    w_state     char(2),/*{{ rand.regex('[A-Z]{2}') }}*/
    w_zip       char(9),/*{{ rand.regex('[0-9]{4}11111') }}*/

    r_dec000 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_dec001 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_dec002 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_dec003 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_dec004 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_dec005 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_dec006 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_dec007 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_dec008 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_dec009 decimal(14, 2), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/
    r_int000 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int001 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int002 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int003 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int004 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int005 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int006 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int007 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int008 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int009 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int010 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int011 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int012 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int013 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int014 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int015 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int016 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int017 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int018 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int019 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int020 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int021 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int022 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int023 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int024 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int025 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int026 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int027 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int028 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int029 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int030 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int031 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int032 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int033 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int034 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int035 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int036 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int037 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int038 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int039 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int040 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int041 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int042 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int043 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int044 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int045 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int046 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int047 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int048 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int049 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int050 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int051 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int052 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int053 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int054 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int055 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int056 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int057 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int058 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int059 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int060 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int061 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int062 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int063 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int064 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int065 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int066 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int067 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int068 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int069 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int070 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int071 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int072 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int073 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int074 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int075 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int076 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int077 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int078 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int079 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_str000 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str001 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str002 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str003 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str004 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str005 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str006 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str007 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str008 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str009 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str010 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str011 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str012 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str013 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str014 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str015 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str016 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str017 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str018 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str019 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str020 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str021 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str022 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str023 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str024 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str025 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str026 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str027 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str028 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str029 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str030 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str031 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str032 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str033 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str034 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str035 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str036 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str037 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str038 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str039 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str040 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str041 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str042 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str043 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str044 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str045 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str046 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str047 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str048 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str049 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str050 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str051 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str052 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str053 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str054 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str055 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str056 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str057 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str058 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str059 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str060 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str061 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str062 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str063 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str064 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str065 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str066 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str067 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str068 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str069 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str070 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str071 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str072 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str073 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str074 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str075 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str076 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str077 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str078 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str079 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str080 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str081 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str082 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str083 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str084 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str085 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str086 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str087 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str088 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str089 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str090 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str091 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str092 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str093 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str094 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str095 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str096 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str097 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str098 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str099 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str100 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str101 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str102 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str103 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str104 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str105 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str106 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str107 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str108 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str109 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str110 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str111 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str112 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str113 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str114 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str115 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str116 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str117 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str118 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str119 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str120 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str121 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str122 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str123 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str124 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str125 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str126 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str127 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str128 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str129 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str130 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str131 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str132 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str133 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str134 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str135 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str136 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str137 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str138 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str139 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str140 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str141 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str142 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str143 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str144 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str145 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str146 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str147 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str148 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str149 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str150 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str151 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str152 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str153 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str154 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str155 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str156 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str157 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str158 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str159 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str160 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str161 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str162 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str163 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str164 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str165 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str166 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str167 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str168 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str169 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str170 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str171 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str172 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str173 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str174 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str175 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str176 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str177 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str178 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str179 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str180 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str181 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str182 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str183 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str184 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str185 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str186 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str187 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str188 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str189 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str190 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str191 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str192 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str193 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str194 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str195 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str196 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str197 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str198 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str199 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str200 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str201 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str202 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str203 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str204 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str205 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str206 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str207 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str208 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str209 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str210 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str211 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str212 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str213 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str214 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str215 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str216 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str217 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str218 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str219 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str220 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str221 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str222 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str223 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str224 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str225 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str226 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str227 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str228 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str229 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str230 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str231 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str232 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str233 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str234 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str235 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str236 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str237 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str238 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str239 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str240 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str241 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str242 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str243 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str244 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str245 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str246 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str247 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str248 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str249 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str250 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str251 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str252 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str253 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str254 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str255 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str256 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str257 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str258 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str259 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str260 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str261 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str262 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str263 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str264 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str265 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str266 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str267 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str268 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str269 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str270 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str271 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str272 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str273 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str274 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str275 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str276 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str277 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str278 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str279 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str280 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str281 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str282 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str283 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str284 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str285 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str286 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str287 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str288 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str289 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str290 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str291 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str292 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str293 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str294 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str295 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str296 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str297 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str298 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str299 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str300 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str301 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str302 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str303 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str304 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str305 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str306 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str307 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str308 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str309 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str310 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str311 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str312 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str313 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str314 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str315 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str316 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str317 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str318 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str319 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str320 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str321 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str322 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str323 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str324 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str325 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str326 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str327 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str328 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str329 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str330 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str331 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str332 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str333 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str334 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str335 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str336 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str337 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str338 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str339 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str340 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str341 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str342 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str343 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str344 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str345 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str346 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str347 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str348 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str349 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str350 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str351 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str352 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str353 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str354 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str355 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str356 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str357 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str358 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str359 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str360 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str361 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str362 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str363 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str364 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str365 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str366 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str367 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str368 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str369 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str370 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str371 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str372 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str373 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str374 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str375 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str376 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str377 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str378 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str379 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str380 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str381 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str382 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str383 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str384 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str385 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str386 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str387 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str388 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str389 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str390 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str391 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str392 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str393 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str394 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str395 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str396 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str397 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str398 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    r_str399 varchar(30), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/
    primary key (w_id)
);
