print("""
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
""")
print('\n'.join(['    r_dec{:03d} decimal(14, 2), '.format(x) + '/*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range_inclusive(0, 200000)/10000 ELSE NULL END }}*/' for x in range(0,10)]))
print('\n'.join(['    r_int{:03d} integer, '.format(x) + '/*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.range(0, 10000000) ELSE NULL END }}*/' for x in range(0,100)]))
print('\n'.join(["    r_str{:03d} varchar(30), ".format(x) + "/*{{ CASE rand.bool(0.05) WHEN TRUE THEN rand.regex('[0-9a-zA-Z]{6,10}') ELSE NULL END }}*/" for x in range(0,850)]))
print("""    primary key (w_id)
);""")

