
declare
    V_EMAIL_TEMPLATE        EMAIL_TEMPLATES%rowtype;
    V_EMAIL_PARAMETER       EMAIL_PARAMETERS%rowtype;
begin

    -------------------------------------------------------------------------------------
    V_EMAIL_TEMPLATE.CODE             := 'VMM' ;
    V_EMAIL_TEMPLATE.NAME             := 'Vacation modify e-mail' ;
    V_EMAIL_TEMPLATE.TO_EXPRESSION    := 'select listagg( E_MAIL, '','' ) within  group  ( order by e_mail) from PERSON where ID in ( select PERSON_ID as APPROVAL_ID from MY_APPROVALS_VW )' ;
    V_EMAIL_TEMPLATE.CC_EXPRESSION    := 'select E_MAIL from PERSON where ID = PKG_MYENV.F_GET_MYENV ( ''PERSON_ID'', ''VMM'' ) ';
    V_EMAIL_TEMPLATE.BCC_EXPRESSION   := null ;
    V_EMAIL_TEMPLATE.SENDER_EXPRESSION:= V_EMAIL_TEMPLATE.CC_EXPRESSION ;
    V_EMAIL_TEMPLATE.SUBJECT          := '[OLD_EVENT_NAME] módosítás - [SENDER_NAME]';
    V_EMAIL_TEMPLATE.BODY             := 
'
<p>Sziasztok!</p><p></p><p>A Timesheet-ben korábban rögzített szabadságigényemet az alábbiak szerint módosítottam:</p><p><b>
[OLD_START_DATE] - [OLD_END_DATE] - [OLD_NUM_OF_DAYS] nap </b></p><p></p><p>helyett</p><p><b>
[NEW_EVENT_NAME] [NEW_START_DATE] - [NEW_END_DATE] - [NEW_NUM_OF_DAYS] nap </b></p>
<p>[TEXT]</p>
<p></p><p>Üdv,</p><p>[SENDER_NAME]</p>
';
    V_EMAIL_TEMPLATE.SEND_CONDITION   := null ;
    V_EMAIL_TEMPLATE.REMARK           := 'When someone changed the her/his vacation type and/or date' ;
    insert into EMAIL_TEMPLATES values V_EMAIL_TEMPLATE;
 
    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[OLD_START_DATE]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''OLD_START_DATE'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[OLD_END_DATE]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''OLD_END_DATE'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[OLD_NUM_OF_DAYS]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''OLD_NUM_OF_DAYS'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[NEW_START_DATE]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''NEW_START_DATE'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[NEW_END_DATE]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''NEW_END_DATE'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[NEW_NUM_OF_DAYS]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''NEW_NUM_OF_DAYS'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[OLD_EVENT_NAME]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''OLD_EVENT_NAME'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[NEW_EVENT_NAME]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''NEW_EVENT_NAME'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[TEXT]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''TEXT'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[SENDER_NAME]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''SENDER_NAME'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    -------------------------------------------------------------------------------------
    V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE  := V_EMAIL_TEMPLATE.CODE;
    V_EMAIL_PARAMETER.CODE                 := '[PERSON_ID]';
    V_EMAIL_PARAMETER.EXPRESSION           := 'PKG_MYENV.F_GET_MYENV ( ''PERSON_ID'', ''VMM'' )';
    V_EMAIL_PARAMETER.REMARK               := null;
    insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;

    commit;    
end;
/

-- VMM
begin

    PKG_MYENV.P_SET_MYENV ( 'OLD_START_DATE' , '2020.02.03'             , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'OLD_END_DATE'   , '2020.02.03'             , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'OLD_NUM_OF_DAYS', '1'                      , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'NEW_START_DATE' , '2020.02.04'             , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'NEW_END_DATE'   , '2020.02.05'             , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'NEW_NUM_OF_DAYS', '2'                      , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'OLD_EVENT_NAME' , 'Alapszabadság'          , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'NEW_EVENT_NAME' , 'Alapszabadság'          , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'TEXT'           , ' '                      , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'SENDER_NAME'    , 'Tóth Ferenc'            , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'SENDER_EMAIL'   , 'tothf@abcd.com'         , 'VMM' );
    PKG_MYENV.P_SET_MYENV ( 'PERSON_ID'      , '103'                    , 'VMM' );

    dbms_output.put_line( EMAIL_CREATE( 'VMM' ) );
end;
/




-- VMM ICAL
begin

    PKG_MYENV.P_SET_MYENV ( 'ICAL_DTSTART'    , '20210203T200000Z'           , 'VMM ICAL' );
    PKG_MYENV.P_SET_MYENV ( 'ICAL_DTEND'      , '20210203T220000Z'           , 'VMM ICAL' );
    PKG_MYENV.P_SET_MYENV ( 'ICAL_DTSTAMP'    , '20210202T100000Z'           , 'VMM ICAL' );
    PKG_MYENV.P_SET_MYENV ( 'ICAL_UID'        , 'B9F8217E1AB96915E0537801010AA80D@yoururl.com', 'VMM ICAL' );
    PKG_MYENV.P_SET_MYENV ( 'NEW_EVENT_NAME'  , 'Alapszabadság'               , 'VMM ICAL' );
    PKG_MYENV.P_SET_MYENV ( 'SENDER_EMAIL'    , 'tothf@abcd.com'              , 'VMM ICAL' );
    PKG_MYENV.P_SET_MYENV ( 'SENDER_NAME'     , 'Ferike the Tóth'             , 'VMM ICAL' );

    dbms_output.put_line( EMAIL_CREATE( 'VMM ICAL' ) );
end;
/

