CREATE TABLE USERS
( USER_ID NUMBER,
  FIRST_NAME VARCHAR2(100) NOT NULL,
  LAST_NAME VARCHAR2(100) NOT NULL,
  YEAR_OF_BIRTH INTEGER,
  MONTH_OF_BIRTH INTEGER,
  DAY_OF_BIRTH INTEGER,
  GENDER VARCHAR2(100),
  PRIMARY KEY (USER_ID),
  CHECK (MONTH_OF_BIRTH BETWEEN 1 AND 12),
  CHECK (DAY_OF_BIRTH BETWEEN 1 AND 31));

CREATE TABLE FRIENDS
( USER1_ID NUMBER,
  USER2_ID NUMBER,
  PRIMARY KEY (USER1_ID, USER2_ID),
  FOREIGN KEY (USER1_ID) REFERENCES USERS ON DELETE CASCADE,
  FOREIGN KEY (USER2_ID) REFERENCES USERS ON DELETE CASCADE,
  CHECK(USER1_ID<>USER2_ID));

CREATE TRIGGER FRI_TRIGGER
BEFORE INSERT ON FRIENDS
FOR EACH ROW
WHEN (NEW.USER1_ID > NEW.USER2_ID)
BEGIN
  :NEW.USER1_ID := :NEW.USER1_ID + :NEW.USER2_ID;
  :NEW.USER2_ID := :NEW.USER1_ID - :NEW.USER2_ID;
  :NEW.USER1_ID := :NEW.USER1_ID - :NEW.USER2_ID;
END;
/

CREATE TABLE CITIES
( CITY_ID INTEGER,
  CITY_NAME VARCHAR2(100),
  STATE_NAME VARCHAR2(100),
  COUNTRY_NAME VARCHAR2(100),
  PRIMARY KEY (CITY_ID));

CREATE TABLE USER_CURRENT_CITY
( USER_ID NUMBER,
  CURRENT_CITY_ID INTEGER,
  PRIMARY KEY (USER_ID),
  FOREIGN KEY (USER_ID) REFERENCES USERS ON DELETE CASCADE,
  FOREIGN KEY (CURRENT_CITY_ID) REFERENCES CITIES ON DELETE CASCADE);

CREATE TABLE USER_HOMETOWN_CITY
( USER_ID NUMBER,
  HOMETOWN_CITY_ID INTEGER,
  PRIMARY KEY (USER_ID),
  FOREIGN KEY (USER_ID) REFERENCES USERS ON DELETE CASCADE,
  FOREIGN KEY (HOMETOWN_CITY_ID) REFERENCES CITIES ON DELETE CASCADE);

CREATE TABLE MESSAGE
( MESSAGE_ID INTEGER,
  SENDER_ID NUMBER NOT NULL,
  RECEIVER_ID NUMBER NOT NULL,
  MESSAGE_CONTENT VARCHAR2(2000),
  SENT_TIME TIMESTAMP,
  PRIMARY KEY (MESSAGE_ID),
  FOREIGN KEY (SENDER_ID) REFERENCES USERS ON DELETE CASCADE,
  FOREIGN KEY (RECEIVER_ID) REFERENCES USERS ON DELETE CASCADE);

CREATE TABLE PROGRAMS
( PROGRAM_ID INTEGER,
  INSTITUTION VARCHAR2(100),
  CONCENTRATION VARCHAR2(100),
  DEGREE VARCHAR2(100),
  PRIMARY KEY (PROGRAM_ID));

CREATE TABLE EDUCATION
( USER_ID NUMBER,
  PROGRAM_ID INTEGER,
  PROGRAM_YEAR INTEGER,
  PRIMARY KEY (USER_ID, PROGRAM_ID),
  FOREIGN KEY (USER_ID) REFERENCES USERS ON DELETE CASCADE,
  FOREIGN KEY (PROGRAM_ID) REFERENCES PROGRAMS ON DELETE CASCADE);

CREATE TABLE USER_EVENTS
( EVENT_ID NUMBER,
  EVENT_CREATOR_ID NUMBER,
  EVENT_NAME VARCHAR2(100),
  EVENT_TAGLINE VARCHAR2(100),
  EVENT_DESCRIPTION VARCHAR2(100),
  EVENT_HOST VARCHAR2(100),
  EVENT_TYPE VARCHAR2(100),
  EVENT_SUBTYPE VARCHAR2(100),
  EVENT_LOCATION VARCHAR(100),
  EVENT_CITY_ID INTEGER,
  EVENT_START_TIME TIMESTAMP,
  EVENT_END_TIME TIMESTAMP,
  PRIMARY KEY (EVENT_ID),
  FOREIGN KEY (EVENT_CREATOR_ID) REFERENCES USERS ON DELETE CASCADE,
  FOREIGN KEY (EVENT_CITY_ID) REFERENCES CITIES ON DELETE CASCADE,
  CHECK (EVENT_END_TIME >= EVENT_START_TIME));

CREATE TABLE PARTICIPANTS
( EVENT_ID NUMBER,
  USER_ID NUMBER,
  CONFIRMATION VARCHAR2(100),
  PRIMARY KEY (EVENT_ID, USER_ID),
  FOREIGN KEY (EVENT_ID) REFERENCES USER_EVENTS ON DELETE CASCADE,
  FOREIGN KEY (USER_ID) REFERENCES USERS ON DELETE CASCADE,
  CHECK (CONFIRMATION IN ('ATTENDING','DECLINED','UNSURE','NOT-REPLIED'))
);

CREATE TABLE ALBUMS
( ALBUM_ID VARCHAR2(100),
  ALBUM_OWNER_ID NUMBER,
  ALBUM_NAME VARCHAR2(100),
  ALBUM_CREATED_TIME TIMESTAMP,
  ALBUM_MODIFIED_TIME TIMESTAMP,
  ALBUM_LINK VARCHAR2(2000),
  ALBUM_VISIBILITY VARCHAR2(100),
  COVER_PHOTO_ID VARCHAR2(100) NOT NULL,
  PRIMARY KEY (ALBUM_ID),
  FOREIGN KEY (ALBUM_OWNER_ID) REFERENCES USERS ON DELETE CASCADE,
  CHECK (ALBUM_CREATED_TIME <= ALBUM_MODIFIED_TIME));

CREATE TABLE PHOTOS
( PHOTO_ID VARCHAR2(100),
  ALBUM_ID VARCHAR2(100),
  PHOTO_CAPTION VARCHAR2(2000),
  PHOTO_CREATED_TIME TIMESTAMP,
  PHOTO_MODIFIED_TIME TIMESTAMP,
  PHOTO_LINK VARCHAR2(2000),
  PRIMARY KEY (PHOTO_ID),
  CHECK(PHOTO_CREATED_TIME <= PHOTO_MODIFIED_TIME)
);

ALTER TABLE ALBUMS ADD CONSTRAINT ALBUMSRefsPHOTOS FOREIGN KEY (COVER_PHOTO_ID) REFERENCES PHOTOS(PHOTO_ID)
INITIALLY DEFERRED DEFERRABLE;
ALTER TABLE PHOTOS ADD CONSTRAINT PHOTOSRefsALBUMS FOREIGN KEY (ALBUM_ID) REFERENCES ALBUMS(ALBUM_ID)
INITIALLY DEFERRED DEFERRABLE;

CREATE TABLE TAGS
( TAG_PHOTO_ID VARCHAR2(100),
  TAG_SUBJECT_ID NUMBER,
  TAG_CREATED_TIME TIMESTAMP,
  TAG_X NUMBER,
  TAG_Y NUMBER,
  PRIMARY KEY (TAG_PHOTO_ID, TAG_SUBJECT_ID),
  FOREIGN KEY (TAG_PHOTO_ID) REFERENCES PHOTOS ON DELETE CASCADE,
  FOREIGN KEY (TAG_SUBJECT_ID) REFERENCES USERS ON DELETE CASCADE);

CREATE SEQUENCE MES_SEQUENCE
START WITH 1
INCREMENT BY 1;
CREATE TRIGGER MES_TRIGGER
BEFORE INSERT ON MESSAGE
FOR EACH ROW
BEGIN
  SELECT MES_SEQUENCE.NEXTVAL 
  INTO :NEW.MESSAGE_ID 
  FROM DUAL;
END;
/

CREATE SEQUENCE CITIES_SEQUENCE
START WITH 1
INCREMENT BY 1;
CREATE TRIGGER CITIES_SEQUENCE_TRIGGER
BEFORE INSERT ON CITIES
FOR EACH ROW
BEGIN
  SELECT CITIES_SEQUENCE.NEXTVAL
  INTO :NEW.CITY_ID
  FROM DUAL; 
END;
/

CREATE SEQUENCE PROGRAMS_SEQUENCE
START WITH 1
INCREMENT BY 1;
CREATE TRIGGER PROGRAMS_SEQUENCE_TRIGGER
BEFORE INSERT ON PROGRAMS
FOR EACH ROW
BEGIN
  SELECT PROGRAMS_SEQUENCE.NEXTVAL
  INTO :NEW.PROGRAM_ID
  FROM DUAL; 
END;
/

