* RECODING EB 953 -- YEAR 2021 ZA7783


***SECTION: technical variables


* ----
* generate eurobarometer id
* ---
 gen ebid = 953
label variable ebid "eurobarometer number"


* ----
* generate study id
* ----

gen studid = 7783
label variable studid "archive study number"


* ----
* generate edition id. 
* ---

*gen edid = version
*label variable edid "edition id"


* ----
* generate respondent id
* ----

rename uniqid respid 
label variable  respid "respondent study number original"

*rename unique_id respidza 
*label variable  respidza "respondent study number appointed by za or icpsr"



* ----
* generate year
* ----

gen year = 2021
label variable year "year"


* ----
* generate interview date
* ----

*gen intdate_start = 20200709
*label variable intdate_start "interview date start july 2020"

*gen intdate_end = 20200826
*label variable intdate_end "interview date end august 2020"

gen intdate = p1
label variable intdate "interview date"

*gen intday = p1
*label variable intday "interview date day"

*gen intmonth = "July August"
*label variable intmonth "interview date month"


* ----
* recode nation 
* ----

gen nation = country
label define nation 1 "France", modify
label define nation 2 "Belgium", modify
label define nation 3 "Netherlands", modify
label define nation 4 "Germany", modify
label define nation 5 "Italy", modify
label define nation 6 "Luxembourg", modify
label define nation 7 "Denmark", modify
label define nation 8 "Ireland", modify
label define nation 9 "Great Britain", modify
label define nation 10 "Northern Ireland", modify
label define nation 11 "Greece", modify
label define nation 12 "Spain", modify
label define nation 13 "Portugal", modify
label define nation 14 "Germany", modify
label define nation 15 "Norway", modify
label define nation 16 "Finland", modify
label define nation 17 "Sweden", modify
label define nation 18 "Austria", modify
label define nation 19 "Cyprus", modify
label define nation 20 "Czech Republic", modify
label define nation 21 "Estonia", modify
label define nation 22 "Hungary", modify
label define nation 23 "Latvia", modify
label define nation 24 "Lithuania", modify
label define nation 25 "Malta", modify
label define nation 26 "Poland", modify
label define nation 27 "Slovakia", modify
label define nation 28 "Slovenia", modify
label define nation 29 "Bulgaria", modify
label define nation 30 "Romania", modify
label define nation 31 "Turkey", modify
label define nation 32 "Croatia", modify
label define nation 33 "Cyprus (TCC)", modify
label define nation 34 "Macedonia (FYROM)", modify
label define nation 35 "Montenegro", modify
label define nation 43 "Iceland", modify
label define nation 44 "Liechtenstein", modify 


label values nation nation
label variable nation "nation"



* ----
* recode wsample, wnation, weuro
* ----

gen wsample = .

label variable wsample "weight sample"


gen wnation = w1 
label variable wnation "weight nation"

*weight europe: weight EU28 
gen weuro = w23 
label variable weuro "weight europe"


* ----
* generate weight all - 
* NB: WEIGHT EU28 + TR + HR + CY-TCC + ME +IS +RS provided for analysing all participating countries (samples) in total, 
* including the remaining candidate countries Turkey and Croatia, plus the Turkish Cypriot Community and 
* the Former Yugoslav Republic of Macedonia, Montenegro and Iceland. 
* This POPULATION SIZE WEIGHT adjusts each national sample in proportion to its share in the total population aged 15 and over, 
* of the total population surveyed in this wave (eu34). 
* The post-stratification weighting factors are included.

* ----

gen w_all = w92
label variable w_all "weight all"

* ----
* generate weight extra
* NB: WEIGHT EXTRA extrapolates the actual universe (population aged 15 or more) for each country (sample), 
* i.e. this weight variable integrates all other available weights, but does not reproduce the number of cases in the data set.
* ----


*weight Germany

gen wnationGE =.
label variable wnationGE "weight United Germany"

*weight Great Britain  -missing 

gen wnationGB = .

label variable wnationGE "weight Great Britain"



* ---- 
* gen satisfaction life
* ----

gen satislife =d70

*mvencode satislife, mv(.a = -99987)

replace satislife = .d if satislife == 5

label define satislife  1 "very satisfied", modify
label define satislife  2 "fairly satisfied", modify
label define satislife  3 "not very satisfied", modify
label define satislife  4 "not at all satisfied", modify
label define satislife  .d "DK", modify
*label define satislife  -99987 "NA", modify
label values satislife satislife
label variable satislife  "satisfaction life"


* ----
* recode satisfaction democracy ms
* ----

gen satisdms = sd18a
replace satisdms = .d if satisdms == 5

label define satisdms 1 "very satisfied", modify
label define satisdms 2 "fairly satisfied", modify
label define satisdms 3 "not very satisfied", modify
label define satisdms 4 "not at all satisfied", modify
label define satisdms .d "dk", modify
*label define satisdeu 9 "inap", modify
label values satisdms satisdms
label variable satisdms "satisfaction democracy ms"

* ----
* satisdeu -  recode satisfaction democracy eu
* ---- 

gen satisdeu = sd18b

replace satisdeu = .d if satisdeu == 5

label define satisdeu 1 "very satisfied", modify
label define satisdeu 2 "fairly satisfied", modify
label define satisdeu 3 "not very satisfied", modify
label define satisdeu 4 "not at all satisfied", modify
label define satisdeu .d "dk", modify

label values satisdeu satisdeu
label variable satisdeu "satisfaction democracy eu"


* ----
* recode political discussion national /local / european
* ----

gen poldisc_nat = d71_1
label variable poldisc_nat "political discussion national frequency"

gen poldisc_eu = d71_2
label variable poldisc_eu "political discussion european frequency"

gen poldisc_loc = d71_3
label variable poldisc_loc "political discussion local frequency"

foreach x of varlist poldisc_* {
recode `x'(1=1)(2=2)(3=4) (4 = .d)
label define `x' 1 "Often", modify
label define `x' 2 "From time to time", modify
label define `x' 4 "Never", modify
label define `x' .d "DK", modify
label values `x' `x'
}

* ----
* generate persuade friends
* ----

*gen persuade =. 

*mvencode persuade, mv(.a = -99987)
*mvencode persuade, mv(.d = .d)

*label define persuade  1 "often", modify
*label define persuade  2 "from time to time", modify
*label define persuade  3 "rarely", modify
*label define persuade  4 "never", modify
*label define persuade  .d "DK", modify
*label define persuade  -99987 "NA", modify
*label define persuade  -99993 "Not Applicable", modify
*label values persuade persuade
*label variable persuade  "persuade friends"

* ---- 
* recode important values pers
* ----

gen val_1 = qc6_1
label variable val_1 "val rule of law"

gen val_2 = qc6_2
label variable val_2 "val respect human life"

gen val_3 = qc6_3
label variable val_3 "val human rights"

gen val_4 = qc6_4
label variable val_4 "val individual freedom"

gen val_5 = qc6_5
label variable val_5 "val democracy"

gen val_6 = qc6_6
label variable val_6 "val peace"

gen val_7 = qc6_7
label variable val_7 "val equality"

gen val_8 = qc6_8
label variable val_8 "val solidarity"

gen val_9 = qc6_9
label variable val_9 "val tolerance"

gen val_10 = qc6_10
label variable val_10 "val religion"

gen val_11 = qc6_11
label variable val_11 "val self-fulfilment"

gen val_12 = qc6_12
label variable val_12 "val respect for cultures"

gen val_13 = qc6_13
label variable val_13 "None"

gen val_14 = qc6_14
label variable val_14 "dk"


* ----
* generate life next year better or worse
* ----

gen lifenext = qa2a_1

recode lifenext (1=1) (2=3) (3=2) (4= .d)

label define lifenext 1 "better", modify
label define lifenext 2 "same", modify
label define lifenext 3 "worse", modify
*label define lifenext  .d "DK", modify
*label define lifenext  -99987 "NA", modify
label values lifenext lifenext
label variable lifenext "next year life better or worse"


* ----
* generate country general next year
* ----

gen cntrynext = qa2a_2

recode cntrynext (1=1) (2=3) (3=2) (4= .d)

label define cntrynext 1 "better", modify
label define cntrynext 2 "same", modify
label define cntrynext 3 "worse", modify
label define cntrynext  .d "DK", modify
*label define cntrynext  -99987 "NA", modify
label values cntrynext cntrynext
label variable cntrynext "next year country better or worse"

* ----
* generate economic situation country next year
* ----

gen econ_cntrynext = qa2a_3
recode econ_cntrynext (1=1) (2=3) (3=2) (4 = .d) 

label define econ_cntrynext 1 "better", modify
label define econ_cntrynext 2 "same", modify
label define econ_cntrynext 3 "worse", modify
label define econ_cntrynext  .d "DK", modify
*label define econ_cntrynext  -99987 "NA", modify
*label define econ_cntrynext  -99993 "Not Applicable", modify
label values econ_cntrynext econ_cntrynext
label variable econ_cntrynext "economic situation country next year"

* ----
* gen financial situation hh next year
* ----

gen fina_hhnext = qa2a_4

recode fina_hhnext (1=1) (2=3) (3=2) (4 = .d)

label define fina_hhnext 1 "better", modify
label define fina_hhnext 2 "same", modify
label define fina_hhnext 3 "worse", modify
label define fina_hhnext  .d "DK", modify
*label define fina_hhnext  -99987 "NA", modify
label values fina_hhnext fina_hhnext
label variable fina_hhnext "financial situation hh next year"

* ----
* gen employment situation country next year
* ----

gen empl_cntrynext = qa2a_5

recode empl_cntrynext (1=1) (2=3) (3=2) (4 = .d)

label define empl_cntrynext 1 "better", modify
label define empl_cntrynext 2 "same", modify
label define empl_cntrynext 3 "worse", modify
label define empl_cntrynext  .d "DK", modify
*label define empl_cntrynext  -99987 "NA", modify
label values empl_cntrynext empl_cntrynext
label variable empl_cntrynext "employment situation country next year"

* ----
* gen employment situation personal next year
* ----

gen empl_persnext = qa2a_6

recode empl_persnext (1=1) (2=3) (3=2) (4 = .d)

label define empl_persnext 1 "better", modify
label define empl_persnext 2 "same", modify
label define empl_persnext 3 "worse", modify
label define empl_persnext  .d "DK", modify
*label define empl_persnext  -99987 "NA", modify
label values empl_persnext empl_persnext
label variable empl_persnext "employment situation personal next year"


* ----
* gen economic situation EU next year
* ----

gen econ_eunext = qa2a_7

recode econ_eunext (1=1) (2=3) (3=2) (4 = .d)

label define econ_eunext 1 "better", modify
label define econ_eunext 2 "same", modify
label define econ_eunext 3 "worse", modify
label define econ_eunext  .d "DK", modify
*label define econ_eunext  -99987 "NA", modify
label values econ_eunext econ_eunext
label variable econ_eunext "economic situation EU next year"

* ----
* gen economic situation world next year
* ----

*gen econ_worldnext = .

*recode  econ_worldnext (1=1) (2=3) (3=2) (. = .d)

*label define  econ_worldnext 1 "better", modify
*label define  econ_worldnext 2 "same", modify
*label define  econ_worldnext 3 "worse", modify
*label define  econ_worldnext  .d "DK", modify
*label define  econ_worldnext  -99987 "NA", modify
*label values  econ_worldnext econ_worldnext
*label variable  econ_worldnext "economic situation world next year"


* ----
* rename economic variables
* ----

rename econ_cntrynext econ_cntrynext_2

rename fina_hhnext fina_hhnext_2

rename empl_cntrynext empl_cntrynext_2

rename empl_persnext empl_persnext_2

rename econ_eunext econ_eunext_2

*rename econ_worldnext econ_worldnext_2


* ----
* gen employment situation country current
* ----

gen empl_cntrycur = qa1a_6

recode empl_cntrycur (1=1) (2=2) (3=3) (4=4) (5= .d)

label define empl_cntrycur 1 "very good", modify
label define empl_cntrycur 2 "good", modify
label define empl_cntrycur 3 "bad", modify
label define empl_cntrycur 4 "very bad", modify
label define empl_cntrycur .d "DK", modify
*label define empl_cntrycur.n "NA", modify
label values empl_cntrycur empl_cntrycur
label variable empl_cntrycur "employment country situation current"
* ----
* recode EC common problem
* ----


* ----
* generate membership  --	only asked to candidates + TCC
* ----

gen mem = qa6c

recode mem (1=1) (2=3) (3=2) (4 =.r) (5 =.d)

replace mem = 1 if qa6e == 1
replace mem = 2 if qa6e == 3
replace mem = 3 if qa6e == 2
replace mem = .r if qa6e == 4
replace mem = .d if qa6e == 5

label define mem 1 "Good thing", modify
label define mem 2 "Neither good nor bad", modify
label define mem 3 "Bad thing", modify
*label define mem  -99987 "NA", modify
*label define mem  -99993 "Not Applicable", modify
label values mem mem
label variable mem "membership"

* ----
* generate benefit -- --	only asked to candidates + TCC
* ----

gen benefit = qa6d 

recode benefit (1=1) (2=2) (3 =.r) (4 =.d)

replace benefit = 1 if qa6d  == 1
replace benefit = 2 if qa6d  == 2
replace benefit = .r if qa6d  == 3
replace benefit = .d if qa6d  == 4

label define benefit  1 "benefited", modify
label define benefit  2 "not benefited", modify
label define benefit  .d "DK", modify
*label define benefit  -99987 "NA", modify
*label define benefit  -99993 "Not Applicable", modify
label values benefit benefit
label variable benefit  "benefit"


* ----
* generate attachment country
* ----

gen attach_cntry = qc1a_2

replace attach_cntry = .d if qc1a_2 == 5

label define attach_cntry  1 "Very attached", modify
label define attach_cntry 2 "Fairly attached", modify
label define attach_cntry  3 "Not very attached", modify
label define attach_cntry  4 "Not at all attached", modify
label define attach_cntry .d "DK", modify
*label define attach_cntry  -99987 "NA", modify
*label define attach_cntry  -99993 "Not Applicable", modify
label values attach_cntry attach_cntry
label variable attach_cntry "attachment country"

* ----
* generate attachment europe
* ----

gen attach_eur = qc1a_4

replace attach_eur = .d if qc1a_4 == 5

label define attach_eur  1 "Very attached", modify
label define attach_eur 2 "Fairly attached", modify
label define attach_eur 3 "Not very attached", modify
label define attach_eur  4 "Not at all attached", modify
label define attach_eur .d "DK", modify
*label define attach_eur -99987 "NA", modify
*label define attach_eur  -99993 "Not Applicable", modify
label values attach_eur attach_eur
label variable attach_eur "attachment europe"


* ----
* generate attachment region
* ----

gen attach_reg = .



*label define attach_reg  1 "Very attached", modify
*label define attach_reg  2 "Fairly attached", modify
*label define attach_reg  3 "Not very attached", modify
*label define attach_reg  4 "Not at all attached", modify
*label define attach_reg .d "DK", modify
*label define attach_reg  -99987 "NA", modify
*label define attach_reg  -99993 "Not Applicable", modify
*label values attach_reg attach_reg
*label variable attach_reg "attachment region"

* ----
* generate trust national government
* ----

gen trms_ngov = qa6a_8

recode trms_ngov (1=1) (2=2) (3 = .d) 

label define trms_ngov  1 "trust", modify
label define trms_ngov  2 "no trust", modify
label define trms_ngov  .d "DK", modify
*label define trms_ngov -99993 "Not Applicable", modify
*label define trms_ngov  -99987 "NA", modify

label values trms_ngov trms_ngov
label variable trms_ngov "trust national government"

* ----
* generate trust national parliament
* ----

gen trms_nparl = qa6a_9

recode trms_nparl (1=1) (2=2) (3 = .d) 


label define trms_nparl  1 "trust", modify
label define trms_nparl  2 "no trust", modify
label define trms_nparl  .d "DK", modify
*label define trms_nparl  -99993 "Not Applicable", modify
*label define trms_nparl  -99987 "NA", modify

label values trms_nparl trms_nparl
label variable trms_nparl "trust national parliament"

* ----
* generate trust european union 
* ----

gen treu = qa6a_10

recode treu (1=1) (2=2) (3 = .d) 

label define treu  1 "trust", modify
label define treu  2 "no trust", modify
label define treu  .d "DK", modify
*label define treu  -99987 "NA", modify
*label define treu  -99993 "Not Applicable", modify
label values treu treu
label variable treu "trust european union"

* ----
* generate trust european parliament 
* ----

gen treu_ep = qa10_1

recode treu_ep (1=1) (2=2) (3 = .d) 

label define treu_ep  1 "trust", modify
label define treu_ep  2 "no trust", modify
label define treu_ep  .d "DK", modify
*label define treu_ep  -99987 "NA", modify
*label define treu_ep  -99993 "Not Applicable", modify
label values treu_ep treu_ep
label variable treu_ep "trust european parliament"

* ----
* generate trust european commission 
* ----

gen treu_com = qa10_2

recode treu_com (1=1) (2=2) (3 = .d)

label define treu_com  1 "trust", modify
label define treu_com  2 "no trust", modify
label define treu_com  .d "DK", modify
*label define treu_com  -99987 "NA", modify
*label define treu_com  -99993 "Not Applicable", modify
label values treu_com treu_com
label variable treu_com "trust european commission"

* ----
* generate trust european council
* ----

gen treu_coun = qa10_4

recode treu_com (1=1) (2=2) (3 = .d)

label define treu_coun  1 "trust", modify
label define treu_coun  2 "no trust", modify
label define treu_coun  .d "DK", modify
*label define treu_coun  -99987 "NA", modify
*label define treu_coun  -99993 "Not Applicable", modify
label values treu_coun treu_coun
label variable treu_coun "trust european council"

* ----
* generate trust council of the EU
* ----

*gen treu_couneu = .

*mvencode treu_couneu, mv(.a = -99987)
*mvencode treu_couneu, mv(.d = .d)
*mvencode treu_couneu, mv(.b = -99993)

*label define treu_couneu  1 "trust", modify
*label define treu_couneu  2 "no trust", modify
*label define treu_couneu  .d "DK", modify
*label define treu_couneu  -99987 "NA", modify
*label define treu_couneu  -99993 "Not Applicable", modify
*label values treu_couneu treu_couneu
*label variable treu_couneu "trust council of the EU"

* ----
*  generate trust ms political parties
* ----

gen trms_polpar = qa6a_1

recode trms_polpar (1=1) (2=2) (3 = .d)

label define trms_polpar 1 "trust", modify
label define trms_polpar 2 " no trust", modify
label define trms_polpar .d "DK", modify
*label define trms_polpar -99987 "NA", modify
*label define trms_polpar -99993 "Not Applicable", modify
label values trms_polpar trms_polpar
label variable trms_polpar "trust mb political parties"


* ----
*  generate trusteu central bank
* ----

gen treu_ecb = qa10_3

recode treu_ecb (1=1) (2=2) (3 = .d)

label define treu_ecb 1 "trust", modify
label define treu_ecb 2 " no trust", modify
label define treu_ecb .d "DK", modify
*label define treu_ecb -99987 "NA", modify
*label define treu_ecb -99993 "Not Applicable", modify
label values treu_ecb trms_polpar
label variable treu_ecb "trust mb political parties"

* ----
*  generate trust justice
* ----

gen trms_just = qa6a_2

recode trms_just (1=1) (2=2) (3 = .d)

label define trms_just 1 "trust", modify
label define trms_just 2 " no trust", modify
label define trms_just .d "DK", modify
*label define trms_just -99987 "NA", modify
*label define trms_just -99993 "Not Applicable", modify
label values trms_just trms_polpar
label variable trms_just "trust mb political parties"


* ----
*  generate common currency for/against
* ----

gen curr = qb3_1
recode curr (1=1) (2=2) (3 = .r)  (4 = .d)

label define curr 1 "for", modify
label define curr 2 "against", modify

label define curr  .d "DK", modify
*label define curr  -99987 "NA", modify
*label define curr  -99993 "Not Applicable", modify
label values curr curr
label variable curr "common currency"

* ----
* generate l-r selfplacement  
* ----

gen lr = d1

recode lr  (97= .r) (98= .d) 
*mvencode lr, mv(.c = -99993)

label define lr  1 "left", modify
label define lr  10 "right", modify

*label define lr  -99992 "Refused", modify
*label define lr  .d "DK", modify
*label define lr  -99987 "NA", modify
*label define lr  -99993 "Not Applicable", modify
label values lr lr
label variable lr  "left-right self placement"

* ----
* generate married
* 1-4 MARRIED OR REMARRIED; 5-8 SINGLE LIVING WITH A PARTNER; 9-10 SINGLE; 11-12 DIVORCED OR SEPARATED; 13-14 WIDOW
* ----

gen married = d7 

recode married (1= 101) (2= 102) (3= 103) (4= 104) (5= 201) (6= 202) (7= 203) (8= 204) (9= 301) (10= 302) (11= 401) (12= 402) (13= 501) (14= 502) (15= .o) (97= .r) 

*MARRIED OR REMARRIED
label define married 101 "married, living without children", modify
label define married 102 "married, living with the children of this marriage", modify
label define married 103 "married, living with the children of a previous marriage", modify
label define married 104 "married, living with the children of this marriage and a previous marriage", modify

* SINGLE LIVING WITH A PARTNER 
label define married 201 "Living with a partner, living without children", modify
label define married 202 "Living with a partner, living with the children of this union", modify
label define married 203 "Living with a partner, living with the children of a previous union", modify
label define married 204 "Living with a partner, living with the children of this union and of a previous union", modify

* SINGLE
label define married 301 "Single, living without children", modify
label define married 302 "Single, living with children", modify

* DIVORCED OR SEPARATED
label define married 401 "Divorced or separated, living without children", modify
label define married 402 "Divorced or separated, living with children", modify

* WIDOW
label define married 501 "Widow, living without children", modify
label define married 502 "Widow, living with children", modify

*label define married .d "DK", modify
*label define married -99987 "NA", modify
*label define married -99993 "Not Applicable", modify
label define married -99992 "Refusal", modify
label define married -99981 "Other", modify
label values married married
label variable married "married"


* ----
* generate education age
* ----

gen educ_age = d8

*mvencode educ_age, mv (.a = -99987) 
recode educ_age  (98= 0) (97= -99951) (99 = .d) 

label define educ_age  0 "still studying", modify

label define educ_age .d "DK", modify
*label define educ_age -99992 "Refused", modify
label define educ_age -99951 "No full-time education", modify
*label define educ_age -99993 "Not Applicable", modify
*label define educ_age -99965 "No formal schooling", modify
label values educ_age educ_age
label variable educ_age "education age"

* ----
* generate education
* ----

gen educ = d8r1 

*mvencode educ, mv(.a = -99987)
recode educ (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (11= -99951) (97 = .r) (98 = .d)


label define educ 1 "up to 14 years", modify
label define educ 2 "15 years", modify
label define educ 3 "16 years", modify
label define educ 4 "17 years", modify
label define educ 5 "18 years", modify
label define educ 6 "19 years", modify
label define educ 7 "20 years", modify
label define educ 8 "21 years", modify
label define educ 9 "22 years or over", modify
label define educ 10 "still studying", modify
label define educ -99951 "No full-time education", modify
*label define educ -99987 "NA", modify
label define educ .d "DK", modify
label define educ .r "Refused", modify
label values educ educ
label variable educ "education

* ----
* generate sex
* ----

gen sex = d10
*mvencode sex, mv(.a = -99987)

label define sex 1 "male", modify
label define sex 2 "female", modify
label define sex 3 "None of the above/ Non binary/ do not respond", modify
*label define sex -99987 "NA", modify
label values sex sex
label variable sex "sex"

* ----
* generate age
* in years
* ----

gen age = d11

replace age = .r if age == 99

*mvencode age, mv(.a = -99987)
*mvencode age, mv(.b = -99954)

*label define age -99987 "NA", modify
*label define age -99954 "Wild code", modify
label values age age
label variable age "age"

* ----
* recode occupation
* 1-4: not working ; 5-9: self employed ; 10-18: employed
* ----

gen occup = d15a 

recode occup (1= 510) (2= 521) (3= 540) (4= 530) (5= 111) (6= 112) (7= 120) (8= 130) (9= 132) (10= 210) (11= 220) (12= 210) (13= 310) (14= 321) (15= 322) (16= 412) (17= 411) (18= 413) 
*(.n= -99987) 
* NON-ACTIVE
label define occup 510 "housewife", modify
label define occup 521 "student", modify
label define occup 540 "unemployed", modify
label define occup 530 "retired", modify
*label define occup 522 "military service", modify

* SELF EMPLOYED
label define occup 111 "farmer", modify
label define occup 112 "fisherman", modify
label define occup 120 "professional sel-employed", modify
label define occup 130 "owner of shop, business propietor", modify
label define occup 132 "business propietors, owner of a company", modify

* EMPLOYED
label define occup 210 "employed professional", modify
label define occup 220 "general and top management", modify
label define occup 230 "middle management", modify
label define occup 310 "employed position, working from a desk", modify
label define occup 321 "employed position, travelling", modify
label define occup 322 "employed position, service job", modify
*label define occup 312 "other office employees", modify
*label define occup 320 "non-office employees", modify
label define occup 412 "supervisors", modify
label define occup 411 "skilled manual worker", modify
label define occup 413 "other worker", modify


*label define occup -99987 "NA", modify
*label define occup -99993 "Not Applicable", modify
label values occup occup
label variable occup "occupation"


* ----
* generate type of community
* ----

gen typecmty = d25 


label define typecmty 1 "rural area or village", modify
label define typecmty 2 "small or middle size town", modify
label define typecmty 3 "big town", modify
label define typecmty .d "DK", modify
*label define typecmty -99987 "NA", modify
label values typecmty typecmty
label variable typecmty "type of community"


* ----
* generate children 
* under 15
* ----

gen children =  d40c

label define children 0 "none", modify
label define children 1 "1 child", modify
*label define children 4 "4 or more", modify
*label define children -99987 "NA", modify
*label define children -99993 "Not Applicable", modify
label values children children
label variable children "children under 15"


* ----
* generate size household
* ----

gen sizehh = d40a

*mvencode sizehh, mv(.a = -99987)
*mvencode sizehh, mv(.b = -99993)

label define sizehh 1 "one person", modify
*label define sizehh 18 "18", modify
label define sizehh -99987 "NA", modify
*label define sizehh -99993 "Not Applicable", modify
label values sizehh sizehh
label variable sizehh "size household"


* ----
* recode eu community issues
* ----

gen issue_1 = qc4_1
label variable issue_1 "issue history"

gen issue_2 = qc4_2
label variable issue_2 "issue religion"

gen issue_3 = qc4_3
label variable issue_3 "issue values"

gen issue_4 = qc4_4
label variable issue_4 "issue geography"

gen issue_5 = qc4_5
label variable issue_5 "issue languages"

gen issue_6 = qc4_6
label variable issue_6 "issue legislation"

gen issue_7 = qc4_7
label variable issue_7 "issue sports"

gen issue_8 = qc4_8
label variable issue_8 "issue science and technology"      

gen issue_9 = qc4_9
label variable issue_9 "issue economy"

gen issue_10 = qc4_10
label variable issue_10 "issue healthcare education pensions" 

gen issue_11 = qc4_11
label variable issue_11 "issue solidarity with poor regions"

gen issue_12 = qc4_12
label variable issue_12 "issue culture"

gen issue_13 = qc4_15
label variable issue_13 "others"   

gen issue_14 = qc4_14
label variable issue_14 "the environment/climate/energy"

gen issue_15 = qc4_13
label variable issue_15 "education"   

gen issue_nosuchfeel = qc4_16
label variable issue_nosuchfeel "no such feelings"

gen issue_none = qc4_17
label variable issue_none "none of these"

gen issue_dk = qc4_18
label variable issue_dk "issue dk"

foreach x of varlist issue_* {
recode `x' (0=1)(1=2)
label define `x' 1 "not mentioned", modify
label define `x' 2 "mentioned", modify
*label define `x' -99993 "Not applicable", modify
label values `x' `x'
 }
 
 
* ----
* gen subjective social class
* ----

gen soclass = d63

recode soclass (1=1) (2=1) (3=2) (4=2) (5=3) (6 = .o)  (7 = .n)  (8 = .r)  (9 = .d) 

label define soclass 1 "working class", modify
label define soclass 2 "middle class", modify
label define soclass 3 "upper class", modify
*label define soclass -99983 "DK", modify
label values soclass soclass
label variable soclass "subjective social class"


* ----
* gen european citizenship feel 
* ----

gen citizen_2 = qc2_1

recode citizen_2 (1=1) (2=2) (3=3) (4 =4) (5 = .d)

label define citizen_2 1 " Yes, definitely", modify
label define citizen_2 2 "Yes, to some extent", modify
label define citizen_2 3 "No, not really ", modify
label define citizen_2 4 "No, definitely not", modify
label define citizen_2 .d "Don't know", modify
label values citizen_2 citizen_2
label variable citizen_2 "european citizenship feel"

gen citizen_h = qc2_1

recode citizen_h (1=1) (2=2) (3=3) (4 = 3) (5 = .d)

label define citizen_h 1 "often", modify
label define citizen_h 2 "sometimes", modify
label define citizen_h 3 "never", modify
label define citizen_h .d "Don't know", modify
*label define citizen_h 5 "DK", modify
label values citizen_h citizen_h
label variable citizen_h "european citizenship feel harmonised"





* ----
* recode EC common problem
* ----

gen p_6 = qa3a_1
label variable p_6 "cp crime"

gen p_38 = qa3a_2
label variable p_38 "cp economy"

gen p_28 = qa3a_3
label variable p_28 "cp rising prices"

gen p_40 = qa3a_4
label variable p_40 "cp vat"

gen p_33 = qa3a_5
label variable p_33 "cp unemployment"

gen p_30 = qa3a_6
label variable p_30 "cp terrorism"

gen p_15 = .
label variable p_15 "cp foreign policy"

gen p_55 = .
label variable p_55 "cp finances"      

gen p_18 = qa3a_10
label variable p_18 "cp immigration"

gen p_56 = qa3a_13
label variable p_56 "cp pensions" 

gen p_11 = qa3a_15
label variable p_11 "cp energy"

gen p_13 = qa3a_14
label variable p_13 "cp environment"

gen p_57 = qa3a_14
label variable p_57 "cp climate change"   

gen p_others = qa3a_16
label variable p_others "cp others"

gen p_dk = qa3a_18
label variable p_dk "cp dk"

foreach x of varlist p_* {
recode `x' (0=1)(1=2)
label define `x' 1 "not mentioned", modify
label define `x' 2 "mentioned", modify
label values `x' `x'
 }

 
 * ---- 
* recode important values eu
* ----

gen euval_1 = qc7_1
label variable euval_1 "euval rule of law"

gen euval_2 = qc7_2
label variable euval_2 "euval respect human life"

gen euval_3 = qc7_3
label variable euval_3 "euval human rights"

gen euval_4 = qc7_4
label variable euval_4 "euval individual freedom"

gen euval_5 = qc7_5
label variable euval_5 "euval democracy"

gen euval_6 = qc7_6
label variable euval_6 "euval peace"

gen euval_7 = qc7_7
label variable euval_7 "euval equality"

gen euval_8 = qc7_8
label variable euval_8 "euval solidarity"

gen euval_9 = qc7_9
label variable euval_9 "euval tolerance"

gen euval_10 = qc7_10
label variable euval_10 "euval religion"

gen euval_11 = qc7_11
label variable euval_11 "euval self-fulfilment"

gen euval_12 = qc7_12
label variable euval_12 "euval respect for cultures"

gen euval_13 = qc7_14
label variable euval_13 "None"

gen euval_14 = qc7_15
label variable euval_14 "dk"

gen euval_15 = qc7_13
label variable euval_15 "respect for the planet"


keep year ebid studid respid nation intdate wnation weuro w_all wnationGE wnationGB satislife satisdeu satisdms poldisc_nat poldisc_loc poldisc_eu lifenext econ_cntrynext fina_hhnext empl_cntrynext empl_persnext econ_eunext  cntrynext   mem benefit curr trms_just  trms_ngov trms_nparl treu treu_ep treu_com treu_coun lr married educ_age educ sex age occup typecmty children sizehh issue_1 issue_2 issue_3 issue_4 issue_5 issue_6 issue_7 issue_8 issue_9 issue_10 issue_11 issue_12 issue_13 issue_14 issue_15 issue_nosuchfeel issue_none issue_dk treu_ecb soclass attach_reg attach_cntry attach_eur empl_cntrycur citizen_2 citizen_h  val_1 val_2 val_3 val_4 val_5 val_5 val_6 val_7 val_8 val_9 val_10 val_11 val_12 val_13 val_14 p_6 p_38 p_28 p_40  p_33 p_30 p_15 p_18 p_13 p_11 p_55 p_56 p_57 p_others p_dk euval_1 euval_2 euval_3 euval_4 euval_5 euval_5 euval_6 euval_7 euval_8 euval_9 euval_10 euval_11 euval_12 euval_13 euval_14 euval_15 
