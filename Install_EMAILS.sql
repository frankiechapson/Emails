/************************************************************
    Author  :   Ferenc Toth  
    Remark  :   e-Mail Manager
    Uses    :   MyEnv, DHM, evaluate_expression
    Date    :   2021.01.28
************************************************************/



Prompt *****************************************************************
Prompt **            I N S T A L L I N G   E M A I L S                **
Prompt *****************************************************************



/*************************************/
Prompt   S E Q U E N C E S
/*************************************/

Create Sequence SEQ_EMAILS_ID
    Increment by 1
    Minvalue 1
    Maxvalue 9999999999
    Start With 1
    Cycle
    NoCache;


/*************************************/
Prompt   T A B L E S
/*************************************/


/*============================================================================================*/
CREATE TABLE EMAIL_TEMPLATES (    
/*============================================================================================*/
  CODE                          VARCHAR2(    50 ),
  NAME                          VARCHAR2(   200 ),
  TO_EXPRESSION                 VARCHAR2(  2000 ),
  CC_EXPRESSION                 VARCHAR2(  2000 ),
  BCC_EXPRESSION                VARCHAR2(  2000 ),
  SENDER_EXPRESSION             VARCHAR2(  2000 ),
  SUBJECT                       VARCHAR2(  2000 ),
  BODY_TYPE                     VARCHAR2(    20 ),  /* plain, html or calendar */
  BODY                          VARCHAR2(  2000 ),
  SEND_CONDITION                VARCHAR2(  2000 ),
  REMARK                        VARCHAR2(  2000 )
  );


ALTER TABLE EMAIL_TEMPLATES ADD CONSTRAINT EMAIL_TEMPLATES_NN01   CHECK ( CODE IS NOT NULL );
ALTER TABLE EMAIL_TEMPLATES ADD CONSTRAINT EMAIL_TEMPLATES_PK     PRIMARY KEY ( CODE );

---------------------------------------------------------------------------
CREATE TRIGGER TR_EMAIL_TEMPLATES_AIR
    AFTER INSERT ON EMAIL_TEMPLATES FOR EACH ROW
BEGIN
    DHM.INSERT_ROW_LOG('I','IPC','EMAIL_TEMPLATES',:NEW.CODE );
END;
/
---------------------------------------------------------------------------

CREATE TRIGGER TR_EMAIL_TEMPLATES_AUR
    AFTER UPDATE ON EMAIL_TEMPLATES FOR EACH ROW
BEGIN
  DHM.INSERT_ROW_LOG('U','IPC','EMAIL_TEMPLATES'  ,:NEW.CODE);
  DHM.INSERT_COL_LOG('U','CODE'                   ,:OLD.CODE                   ,:NEW.CODE );
  DHM.INSERT_COL_LOG('U','NAME'                   ,:OLD.NAME                   ,:NEW.NAME );
  DHM.INSERT_COL_LOG('U','TO_EXPRESSION'          ,:OLD.TO_EXPRESSION          ,:NEW.TO_EXPRESSION        );
  DHM.INSERT_COL_LOG('U','CC_EXPRESSION'          ,:OLD.CC_EXPRESSION          ,:NEW.CC_EXPRESSION        );
  DHM.INSERT_COL_LOG('U','BCC_EXPRESSION'         ,:OLD.BCC_EXPRESSION         ,:NEW.BCC_EXPRESSION       );
  DHM.INSERT_COL_LOG('U','SENDER_EXPRESSION'      ,:OLD.SENDER_EXPRESSION      ,:NEW.SENDER_EXPRESSION    );
  DHM.INSERT_COL_LOG('U','SUBJECT'                ,:OLD.SUBJECT                ,:NEW.SUBJECT              );
  DHM.INSERT_COL_LOG('U','BODY_TYPE'              ,:OLD.BODY_TYPE              ,:NEW.BODY_TYPE            );
  DHM.INSERT_COL_LOG('U','BODY'                   ,:OLD.BODY                   ,:NEW.BODY                 );
  DHM.INSERT_COL_LOG('U','SEND_CONDITION'         ,:OLD.SEND_CONDITION         ,:NEW.SEND_CONDITION       );
END;
/
---------------------------------------------------------------------------

CREATE TRIGGER TR_EMAIL_TEMPLATES_ADR
    AFTER DELETE ON EMAIL_TEMPLATES FOR EACH ROW
BEGIN
  DHM.INSERT_ROW_LOG('D','IPC','EMAIL_TEMPLATES',:OLD.CODE);
  DHM.INSERT_COL_LOG('D','NAME'                 ,:OLD.NAME                   ,NULL );
  DHM.INSERT_COL_LOG('D','TO_EXPRESSION'        ,:OLD.TO_EXPRESSION          ,NULL );
  DHM.INSERT_COL_LOG('D','CC_EXPRESSION'        ,:OLD.CC_EXPRESSION          ,NULL );
  DHM.INSERT_COL_LOG('D','BCC_EXPRESSION'       ,:OLD.BCC_EXPRESSION         ,NULL );
  DHM.INSERT_COL_LOG('D','SENDER_EXPRESSION'    ,:OLD.SENDER_EXPRESSION      ,NULL );
  DHM.INSERT_COL_LOG('D','SUBJECT'              ,:OLD.SUBJECT                ,NULL );
  DHM.INSERT_COL_LOG('D','BODY_TYPE'            ,:OLD.BODY_TYPE              ,NULL );
  DHM.INSERT_COL_LOG('D','BODY'                 ,:OLD.BODY                   ,NULL );
  DHM.INSERT_COL_LOG('D','SEND_CONDITION'       ,:OLD.SEND_CONDITION         ,NULL );
END;
/



/*============================================================================================*/
CREATE TABLE EMAIL_PARAMETERS (    
/*============================================================================================*/
  ID                            NUMBER  (    10 ),
  EMAIL_TEMPLATE_CODE           VARCHAR2(    50 ),
  CODE                          VARCHAR2(    50 ),
  EXPRESSION                    VARCHAR2(  2000 ),
  REMARK                        VARCHAR2(  2000 )
  );


ALTER TABLE EMAIL_PARAMETERS ADD CONSTRAINT EMAIL_PARAMETERS_NN01   CHECK ( ID IS NOT NULL );
ALTER TABLE EMAIL_PARAMETERS ADD CONSTRAINT EMAIL_PARAMETERS_PK     PRIMARY KEY ( ID );
ALTER TABLE EMAIL_PARAMETERS ADD CONSTRAINT EMAIL_PARAMETERS_FK01   FOREIGN KEY ( EMAIL_TEMPLATE_CODE ) REFERENCES EMAIL_TEMPLATES ( CODE );
ALTER TABLE EMAIL_PARAMETERS ADD CONSTRAINT EMAIL_PARAMETERS_UK01   UNIQUE ( ID, CODE ) USING INDEX ( CREATE UNIQUE INDEX EMAIL_PARAMETERS_UK01 ON EMAIL_PARAMETERS ( ID, CODE ) );


---------------------------------------------------------------------------
CREATE TRIGGER TR_EMAIL_PARAMETERS_BIR
    BEFORE INSERT ON EMAIL_PARAMETERS FOR EACH ROW
BEGIN
    :NEW.ID := nvl( :NEW.ID, SEQ_EMAILS_ID.NEXTVAL );
    DHM.INSERT_ROW_LOG('I','IPC','EMAIL_PARAMETERS',:NEW.ID );
END;
/
---------------------------------------------------------------------------

CREATE TRIGGER TR_EMAIL_PARAMETERS_AUR
    AFTER UPDATE ON EMAIL_PARAMETERS FOR EACH ROW
BEGIN
  DHM.INSERT_ROW_LOG('U','IPC','EMAIL_PARAMETERS' ,:NEW.ID);
  DHM.INSERT_COL_LOG('U','CODE'                   ,:OLD.CODE                   ,:NEW.CODE );
  DHM.INSERT_COL_LOG('U','EMAIL_TEMPLATE_CODE'    ,:OLD.EMAIL_TEMPLATE_CODE    ,:NEW.EMAIL_TEMPLATE_CODE );
  DHM.INSERT_COL_LOG('U','EXPRESSION'             ,:OLD.EXPRESSION             ,:NEW.EXPRESSION        );
END;
/
---------------------------------------------------------------------------

CREATE TRIGGER TR_EMAIL_PARAMETERS_ADR
    AFTER DELETE ON EMAIL_PARAMETERS FOR EACH ROW
BEGIN
  DHM.INSERT_ROW_LOG('D','IPC','EMAIL_PARAMETERS',:OLD.ID);
  DHM.INSERT_COL_LOG('D','CODE'                  ,:OLD.CODE                ,NULL );
  DHM.INSERT_COL_LOG('D','EMAIL_TEMPLATE_CODE'   ,:OLD.EMAIL_TEMPLATE_CODE ,NULL );
  DHM.INSERT_COL_LOG('D','EXPRESSION'            ,:OLD.EXPRESSION          ,NULL );
END;
/



/*============================================================================================*/
CREATE TABLE EMAIL_TRANSFERS (    
/*============================================================================================*/
  ID                            NUMBER  (    10 ),
  EMAIL_TEMPLATE_CODE           VARCHAR2(    50 ),
  TO_ADDRESS                    VARCHAR2(  2000 ),
  CC_ADDRESS                    VARCHAR2(  2000 ),
  BCC_ADDRESS                   VARCHAR2(  2000 ),
  SENDER_ADDRESS                VARCHAR2(  2000 ),
  SUBJECT                       VARCHAR2(  2000 ),
  BODY                          VARCHAR2(  2000 ),
  CREATED_TIME                  DATE,
  CREATED_USER                  VARCHAR2(    50 ),
  SEND_CONDITION                VARCHAR2(  2000 ),
  SEND_START                    DATE,
  SEND_FINISH                   DATE,
  SENT_FLAG                     NUMBER  (     1 ),
  ERROR                         VARCHAR2(  2000 )
  );

ALTER TABLE EMAIL_TRANSFERS ADD CONSTRAINT EMAIL_TRANSFERS_NN01   CHECK ( ID IS NOT NULL );
ALTER TABLE EMAIL_TRANSFERS ADD CONSTRAINT EMAIL_TRANSFERS_PK     PRIMARY KEY ( ID );
ALTER TABLE EMAIL_TRANSFERS ADD CONSTRAINT EMAIL_TRANSFERS_FK01   FOREIGN KEY ( EMAIL_TEMPLATE_CODE ) REFERENCES EMAIL_TEMPLATES ( CODE );


---------------------------------------------------------------------------
CREATE TRIGGER TR_EMAIL_TRANSFERS_BIR
    BEFORE INSERT ON EMAIL_TRANSFERS FOR EACH ROW
BEGIN
    :NEW.ID := nvl( :NEW.ID, SEQ_EMAILS_ID.NEXTVAL );
END;
/


/*============================================================================================*/
create or replace function EMAIL_PARAMETERS_REPLACE( I_STRING in varchar2
                                                   , I_CODE   in varchar2 
                                                   ) return varchar2 is
/*============================================================================================*/
    V_STRING    varchar2( 10000 ) := I_STRING;
begin

    for L_R in ( select * from EMAIL_PARAMETERS where EMAIL_TEMPLATE_CODE = I_CODE )
    loop
        V_STRING := replace( V_STRING, L_R.CODE, EVALUATE_EXPRESSION( L_R.EXPRESSION ) );
    end loop;
    return V_STRING;
end;
/


/*============================================================================================*/
create or replace function EMAIL_CREATE( I_CODE in varchar2 ) return number is
/*============================================================================================*/
    V_EMAIL_TRANSFER        EMAIL_TRANSFERS%rowtype;
begin

    for L_R in ( select * from EMAIL_TEMPLATES where CODE = I_CODE )
    loop
    
        V_EMAIL_TRANSFER.ID                  := SEQ_EMAILS_ID.nextval;
        V_EMAIL_TRANSFER.EMAIL_TEMPLATE_CODE := I_CODE;
        V_EMAIL_TRANSFER.TO_ADDRESS          := EVALUATE_EXPRESSION( L_R.TO_EXPRESSION     );
        V_EMAIL_TRANSFER.CC_ADDRESS          := EVALUATE_EXPRESSION( L_R.CC_EXPRESSION     );
        V_EMAIL_TRANSFER.BCC_ADDRESS         := EVALUATE_EXPRESSION( L_R.BCC_EXPRESSION    );
        V_EMAIL_TRANSFER.SENDER_ADDRESS      := EVALUATE_EXPRESSION( L_R.SENDER_EXPRESSION );
        V_EMAIL_TRANSFER.SUBJECT             := substr( EMAIL_PARAMETERS_REPLACE( L_R.SUBJECT, I_CODE ), 1, 2000 );
        V_EMAIL_TRANSFER.BODY                := substr( EMAIL_PARAMETERS_REPLACE( L_R.BODY   , I_CODE ), 1, 2000 );
        V_EMAIL_TRANSFER.CREATED_TIME        := sysdate;
        V_EMAIL_TRANSFER.CREATED_USER        := SYS_CONTEXT( 'APEX$SESSION', 'APP_USER' );
        V_EMAIL_TRANSFER.SEND_CONDITION      := L_R.SEND_CONDITION;
        V_EMAIL_TRANSFER.SENT_FLAG           := 0;
        
        insert into EMAIL_TRANSFERS values V_EMAIL_TRANSFER;
        commit;
        
    end loop;
    
    return V_EMAIL_TRANSFER.ID;

end;
/



/*============================================================================================*/
create or replace procedure EMAIL_SEND_ONE ( I_EMAIL_ID in number ) as
/*============================================================================================*/
   V_CONNECTION             UTL_SMTP.CONNECTION;
   V_MAIL_SERV              VARCHAR2(50)                := 'localhost';
   V_MAIL_PORT              PLS_INTEGER                 := '25';
   V_ERRM                   VARCHAR2( 1000 );
   V_EMAIL_TRANSFER         EMAIL_TRANSFERS%rowtype;
   V_EMAIL_TEMPLATE         EMAIL_TEMPLATES%rowtype;
   V_BOUNDARY               VARCHAR2(50)                := '----=*#abc1234321cba#*=';
   V_MSG_BODY               varchar2(32000);

begin

    select * into V_EMAIL_TRANSFER from EMAIL_TRANSFERS where ID   = I_EMAIL_ID;
    select * into V_EMAIL_TEMPLATE from EMAIL_TEMPLATES where CODE = V_EMAIL_TRANSFER.EMAIL_TEMPLATE_CODE;

    begin
    
        update EMAIL_TRANSFERS set SEND_START = sysdate where ID = I_EMAIL_ID;
        commit;

        V_CONNECTION := utl_smtp.open_connection( V_MAIL_SERV, V_MAIL_PORT );
        utl_smtp.helo( V_CONNECTION, V_MAIL_SERV        );
        utl_smtp.mail( V_CONNECTION, V_EMAIL_TRANSFER.SENDER_ADDRESS );

        for L_A in ( select * from table( F_CSV_TO_LIST ( V_EMAIL_TRANSFER.TO_ADDRESS||','||V_EMAIL_TRANSFER.CC_ADDRESS||','||V_EMAIL_TRANSFER.BCC_ADDRESS, ',' ) ) )
        loop
            if trim( L_A.COLUMN_VALUE ) is not null then
                utl_smtp.rcpt( V_CONNECTION, L_A.COLUMN_VALUE );
            end if;
        end loop;


        --  PLAIN TEXT
        if V_EMAIL_TEMPLATE.BODY_TYPE = 'plain' then

            utl_smtp.open_data( V_CONNECTION );

            utl_smtp.write_data( V_CONNECTION, 'DATE: ' || to_char( sysdate, 'DD-MON-YYYY HH24:MI:SS' )      || utl_tcp.crlf );
            utl_smtp.write_data( V_CONNECTION, 'TO: '   || replace( V_EMAIL_TRANSFER.TO_ADDRESS, ',', ';' )  || utl_tcp.crlf );
            if trim( V_EMAIL_TRANSFER.CC_ADDRESS ) is not null then
                utl_smtp.write_data( V_CONNECTION, 'CC: ' || replace( V_EMAIL_TRANSFER.CC_ADDRESS, ',', ';') || utl_tcp.crlf );
            end if;
            if trim( V_EMAIL_TRANSFER.BCC_ADDRESS ) is not null then
                utl_smtp.write_data( V_CONNECTION, 'BCC: ' || replace( V_EMAIL_TRANSFER.BCC_ADDRESS, ',', ';') || utl_tcp.crlf );
            end if;
            utl_smtp.write_data( V_CONNECTION, 'FROM: '     || V_EMAIL_TRANSFER.SENDER_ADDRESS || utl_tcp.crlf );
            utl_smtp.write_raw_data( V_CONNECTION, UTL_RAW.cast_to_raw( 'Subject: '||REPLACE(utl_encode.MIMEHEADER_ENCODE( V_EMAIL_TRANSFER.SUBJECT , 'utf8'),CHR(13) || CHR(10) ) || utl_tcp.CRLF ) );
            utl_smtp.write_data( V_CONNECTION, 'REPLY-TO: ' || V_EMAIL_TRANSFER.SENDER_ADDRESS || utl_tcp.crlf );
            utl_smtp.write_data( V_CONNECTION, 'MIME-version: 1.0'                                  || utl_tcp.crlf );
            utl_smtp.write_data( V_CONNECTION, 'Content-Type: text/plain; charset="iso-8859-2"'     || utl_tcp.crlf );
            utl_smtp.write_data( V_CONNECTION, 'Content-Transfer-Encoding: quoted-printable '       || utl_tcp.crlf || utl_tcp.crlf );
            utl_smtp.write_raw_data( V_CONNECTION, UTL_ENCODE.QUOTED_PRINTABLE_ENCODE( UTL_RAW.CAST_TO_RAW( V_EMAIL_TRANSFER.BODY ) ) );
            utl_smtp.write_data( V_CONNECTION, utl_tcp.crlf || utl_tcp.crlf );
        
            utl_smtp.close_data( V_CONNECTION );

        --  HTML         
        elsif V_EMAIL_TEMPLATE.BODY_TYPE = 'html' then

            utl_smtp.open_data( V_CONNECTION );

            utl_smtp.write_data(V_CONNECTION, 'DATE: ' || to_char( sysdate, 'DD-MON-YYYY HH24:MI:SS') || utl_tcp.crlf );
            utl_smtp.write_data(V_CONNECTION, 'TO: '   || replace( V_EMAIL_TRANSFER.TO_ADDRESS, ',', ';' ) || utl_tcp.crlf );
            if trim( V_EMAIL_TRANSFER.CC_ADDRESS ) is not null then
                utl_smtp.write_data( V_CONNECTION, 'CC: ' || replace( V_EMAIL_TRANSFER.CC_ADDRESS, ',', ';') || utl_tcp.crlf );
            end if;
            if trim( V_EMAIL_TRANSFER.BCC_ADDRESS ) is not null then
                utl_smtp.write_data( V_CONNECTION, 'BCC: ' || replace( V_EMAIL_TRANSFER.BCC_ADDRESS, ',', ';') || utl_tcp.crlf );
            end if;
            utl_smtp.write_data( V_CONNECTION, 'FROM: '     || V_EMAIL_TRANSFER.SENDER_ADDRESS || utl_tcp.crlf );
            utl_smtp.write_raw_data( V_CONNECTION, UTL_RAW.cast_to_raw( 'Subject: '||REPLACE( utl_encode.MIMEHEADER_ENCODE( V_EMAIL_TRANSFER.SUBJECT , 'utf8'),CHR(13) || CHR(10) ) || utl_tcp.CRLF ) );
            utl_smtp.write_data( V_CONNECTION, 'REPLY-TO: ' || V_EMAIL_TRANSFER.SENDER_ADDRESS || utl_tcp.crlf );
            utl_smtp.write_data( V_CONNECTION, 'MIME-Version: 1.0'                             || utl_tcp.crlf );
            utl_smtp.write_data( V_CONNECTION, 'Content-Type: multipart/alternative; boundary="' || V_BOUNDARY || '"' || utl_tcp.crlf || utl_tcp.crlf ); 
            utl_smtp.write_data( V_CONNECTION, '--' || V_BOUNDARY || utl_tcp.crlf );
            utl_smtp.write_data( V_CONNECTION, 'Content-Transfer-Encoding: 8bit'               || utl_tcp.crlf );
            utl_smtp.write_data( V_CONNECTION, 'Content-Type: text/html; charset="iso-8859-2"'      || utl_tcp.crlf || utl_tcp.crlf );
            utl_smtp.write_raw_data( V_CONNECTION, UTL_RAW.CAST_TO_RAW( V_EMAIL_TRANSFER.BODY )  );
            utl_smtp.write_data( V_CONNECTION, utl_tcp.crlf || utl_tcp.crlf );
            utl_smtp.write_data( V_CONNECTION, '--' || V_BOUNDARY || '--' || utl_tcp.crlf );

            utl_smtp.close_data( V_CONNECTION );


        --  CALENDAR
        elsif V_EMAIL_TEMPLATE.BODY_TYPE = 'calendar' then

            V_MSG_BODY :=  'Content-class: urn:content-classes:calendarmessage'   || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'MIME-Version: 1.0'                                    || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Content-Type: multipart/alternative;'                 || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || ' boundary="----_=_NextPart"'                          || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Subject: '  || REPLACE(utl_encode.MIMEHEADER_ENCODE( V_EMAIL_TRANSFER.SUBJECT , 'utf8'),CHR(13) || CHR(10) )  || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Date: '  || to_char(sysdate,'DAY, DD-MON-RR HH24:MI') || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'From: <' || V_EMAIL_TRANSFER.SENDER_ADDRESS || '>'    || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'To: '    || V_EMAIL_TRANSFER.TO_ADDRESS               || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || '------_=_NextPart'                                    || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Content-Type: text/plain;'                            || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || ' charset="iso-8859-2"'                                || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Content-Transfer-Encoding: quoted-printable'          || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY ||                                                           utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'You must have an HTML client to view this message.'   || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY ||                                                           utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || '------_=_NextPart'                                    || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Content-Type: text/html;'                             || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || ' charset="iso-8859-2"'                                || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Content-Transfer-Encoding: quoted-printable'          || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY ||                                                           utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || PKG_MYENV.F_GET_MYENV ( 'BODY_HTML', 'ICAL' )          || utl_tcp.crlf ;  /* titkos összetevő! */
            V_MSG_BODY := V_MSG_BODY ||                                                           utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || '------_=_NextPart'                                    || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Content-class: urn:content-classes:calendarmessage'   || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Content-Type: text/calendar;'                         || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || '  method=REQUEST;'                                    || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || '  name="meeting.ics"'                                 || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || ';charset="iso-8859-2"'                                || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || 'Content-Transfer-Encoding: quoted-printable'          || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY ||                                                           utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || replace( V_EMAIL_TRANSFER.BODY , chr(13) )             || utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY ||                                                           utl_tcp.crlf ;
            V_MSG_BODY := V_MSG_BODY || '------_=_NextPart--'                                  || utl_tcp.crlf ;

            utl_smtp.data( V_CONNECTION, V_MSG_BODY );
           
        end if;
        
        utl_smtp.quit      ( V_CONNECTION );

        update EMAIL_TRANSFERS set SENT_FLAG = 1, SEND_FINISH = sysdate where ID = I_EMAIL_ID;
        commit;

    exception when others then

        V_ERRM := SQLERRM;
        update EMAIL_TRANSFERS set ERROR = V_ERRM where ID = I_EMAIL_ID;
        commit;

    end;

end;
/
        



/*============================================================================================*/
create or replace procedure EMAIL_SEND_ALL as
/*============================================================================================*/
   
begin
    update EMAIL_TRANSFERS
       set ERROR = 'Missing data'
     where BODY           is null 
        or SUBJECT        is null 
        or TO_ADDRESS     is null 
        or SENDER_ADDRESS is null
        and ( SENT_FLAG = 0 and ERROR is null );
    commit;
    
    for L_R in ( select * from EMAIL_TRANSFERS where SENT_FLAG = 0 and ERROR is null order by CREATED_TIME )
    loop
        EMAIL_SEND_ONE( L_R.ID );
    end loop;         
    
end;
/





/*============================================================================================*/
create or replace procedure EMAIL_TEMPLATE_COPY ( I_SOURCE_CODE  in varchar2
                                                , I_TARGET_CODE  in varchar2
                                                ) as
/*============================================================================================*/
   V_EMAIL_TEMPLATE         EMAIL_TEMPLATES%rowtype;
   V_EMAIL_PARAMETER        EMAIL_PARAMETERS%rowtype;

begin

    -- Template copy
    select * into V_EMAIL_TEMPLATE from EMAIL_TEMPLATES where CODE = I_SOURCE_CODE;
    V_EMAIL_TEMPLATE.CODE  := I_TARGET_CODE;
    insert into EMAIL_TEMPLATES values V_EMAIL_TEMPLATE;

    -- Parameters copy
    for L_R in ( select * from EMAIL_PARAMETERS where EMAIL_TEMPLATE_CODE = I_SOURCE_CODE )
    loop
        V_EMAIL_PARAMETER                     := L_R;
        V_EMAIL_PARAMETER.ID                  := null;
        V_EMAIL_PARAMETER.EMAIL_TEMPLATE_CODE := I_TARGET_CODE;
        insert into EMAIL_PARAMETERS values V_EMAIL_PARAMETER;
    end loop;
    
    commit;    
    
end;
/




