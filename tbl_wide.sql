
create table widecol_sample.widecol_test_wide(
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
    r_int080 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int081 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int082 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int083 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int084 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int085 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int086 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int087 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int088 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int089 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int090 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int091 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int092 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int093 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int094 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int095 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int096 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int097 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int098 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int099 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int100 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int101 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int102 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int103 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int104 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int105 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int106 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int107 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int108 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int109 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int110 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int111 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int112 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int113 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int114 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int115 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int116 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int117 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int118 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int119 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int120 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int121 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int122 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int123 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int124 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int125 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int126 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int127 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int128 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int129 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int130 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int131 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int132 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int133 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int134 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int135 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int136 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int137 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int138 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int139 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int140 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int141 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int142 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int143 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int144 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int145 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int146 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int147 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int148 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int149 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int150 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int151 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int152 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int153 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int154 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int155 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int156 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int157 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int158 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int159 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int160 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int161 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int162 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int163 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int164 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int165 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int166 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int167 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int168 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int169 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int170 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int171 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int172 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int173 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int174 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int175 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int176 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int177 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int178 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int179 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int180 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int181 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int182 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int183 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int184 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int185 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int186 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int187 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int188 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int189 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int190 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int191 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int192 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int193 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int194 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int195 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int196 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int197 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int198 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int199 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int200 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int201 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int202 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int203 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int204 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int205 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int206 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int207 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int208 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int209 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int210 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int211 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int212 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int213 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int214 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int215 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int216 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int217 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int218 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int219 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int220 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int221 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int222 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int223 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int224 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int225 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int226 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int227 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int228 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int229 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int230 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int231 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int232 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int233 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int234 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int235 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int236 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int237 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int238 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int239 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int240 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int241 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int242 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int243 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int244 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int245 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int246 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int247 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int248 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int249 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int250 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int251 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int252 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int253 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int254 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int255 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int256 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int257 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int258 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int259 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int260 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int261 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int262 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int263 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int264 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int265 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int266 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int267 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int268 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int269 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int270 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int271 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int272 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int273 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int274 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int275 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int276 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int277 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int278 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int279 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int280 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int281 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int282 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int283 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int284 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int285 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int286 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int287 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int288 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_int289 integer, /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/
    r_str000 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str001 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str002 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str003 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str004 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str005 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str006 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str007 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str008 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str009 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str010 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str011 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str012 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str013 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str014 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str015 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str016 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str017 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str018 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str019 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str020 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str021 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str022 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str023 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str024 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str025 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str026 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str027 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str028 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str029 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str030 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str031 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str032 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str033 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str034 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str035 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str036 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str037 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str038 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str039 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str040 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str041 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str042 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str043 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str044 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str045 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str046 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str047 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str048 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str049 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str050 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str051 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str052 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str053 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str054 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str055 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str056 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str057 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str058 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str059 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str060 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str061 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str062 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str063 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str064 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str065 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str066 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str067 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str068 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str069 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str070 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str071 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str072 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str073 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str074 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str075 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str076 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str077 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str078 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str079 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str080 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str081 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str082 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str083 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str084 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str085 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str086 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str087 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str088 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str089 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str090 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str091 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str092 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str093 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str094 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str095 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str096 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str097 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str098 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str099 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str100 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str101 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str102 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str103 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str104 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str105 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str106 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str107 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str108 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str109 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str110 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str111 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str112 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str113 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str114 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str115 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str116 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str117 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str118 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str119 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str120 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str121 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str122 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str123 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str124 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str125 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str126 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str127 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str128 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str129 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str130 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str131 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str132 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str133 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str134 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str135 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str136 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str137 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str138 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str139 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str140 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str141 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str142 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str143 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str144 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str145 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str146 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str147 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str148 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str149 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str150 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str151 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str152 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str153 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str154 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str155 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str156 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str157 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str158 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str159 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str160 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str161 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str162 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str163 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str164 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str165 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str166 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str167 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str168 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str169 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str170 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str171 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str172 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str173 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str174 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str175 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str176 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str177 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str178 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str179 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str180 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str181 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str182 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str183 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str184 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str185 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str186 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str187 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str188 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    r_str189 varchar(200), /*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{185,195}') ELSE NULL END }}*/
    primary key (w_id)
);
