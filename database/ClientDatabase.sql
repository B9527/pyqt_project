DROP TABLE IF EXISTS Box;
CREATE TABLE Box
(
  id           VARCHAR(255) PRIMARY KEY NOT NULL,
  currencyUnit VARCHAR(255),
  deleteFlag   INT                      NOT NULL,
  name         VARCHAR(255)             NOT NULL,
  orderNo      VARCHAR(255)             NOT NULL,
  syncFlag     INT,
  validateType VARCHAR(255),
  operator_id  VARCHAR(255)             NOT NULL,
  freeDays     INT,
  freeHours    INT,
  holidayType  VARCHAR(255),
  overdueType  VARCHAR(255),
  receiptNo    BIGINT
);
DROP TABLE IF EXISTS Holiday;
CREATE TABLE Holiday
(
  id          VARCHAR(255) PRIMARY KEY NOT NULL,
  startTime   BIGINT                   NOT NULL,
  endTime     BIGINT                   NOT NULL,
  delayDay    INT,
  deleteFlag  INT                      NOT NULL,
  holidayType VARCHAR(255)             NOT NULL
);
DROP TABLE IF EXISTS Cabinet;
CREATE TABLE Cabinet
(
  id         VARCHAR(255) PRIMARY KEY NOT NULL,
  deleteFlag INT                      NOT NULL,
  number     INT                      NOT NULL
);
DROP TABLE IF EXISTS Company;
CREATE TABLE Company
(
  id               VARCHAR(255) PRIMARY KEY NOT NULL,
  companyType      VARCHAR(255),
  name             VARCHAR(255)             NOT NULL,
  parentCompany_id VARCHAR(255),
  deleteFlag       INT                      NOT NULL
);
DROP TABLE IF EXISTS Express;
CREATE TABLE Express
(
  id                       VARCHAR(255) PRIMARY KEY NOT NULL,
  brandId                  VARCHAR(255),
  customerStoreNumber      VARCHAR(255),
  expressNumber            VARCHAR(128),
  expressType              VARCHAR(255),
  overdueTime              BIGINT,
  status                   VARCHAR(255),
  storeTime                BIGINT,
  syncFlag                 INT                      NOT NULL,
  takeTime                 BIGINT,
  takeUserPhoneNumber      VARCHAR(255),
  storeUserPhoneNumber     VARCHAR(255),
  validateCode             VARCHAR(255),
  version                  INT                      NOT NULL,
  barcode_id               VARCHAR(255),
  box_id                   VARCHAR(255),
  endAddress_id            VARCHAR(255),
  logisticsCompany_id      VARCHAR(255),
  mouth_id                 VARCHAR(255),
  operator_id              VARCHAR(255),
  rangePrice_id            VARCHAR(255),
  startAddress_id          VARCHAR(255),
  storeUser_id             VARCHAR(255),
  takeUser_id              VARCHAR(255),
  recipientName            VARCHAR(255),
  weight                   BIGINT,
  recipientUserPhoneNumber VARCHAR(255),
  groupName                VARCHAR(255),
  staffTakenUser_id        VARCHAR(255),
  importTime               BIGINT,
  lastModifiedTime         BIGINT,
  chargeType               VARCHAR(255),
  continuedHeavy           INT,
  continuedPrice           INT,
  endAddress               VARCHAR(255),
  startAddress             VARCHAR(255),
  firstHeavy               INT,
  firstPrice               INT,
  designationSize          VARCHAR(255),
  payOfAmount              INT,
  electronicCommerce_id    VARCHAR(255),
  payAmount                INT,
  payType                  VARCHAR(255),
  order_id                 VARCHAR(255)
);

DROP TABLE IF EXISTS Item;
CREATE TABLE Item
(
  id         VARCHAR(255) PRIMARY KEY NOT NULL,
  express_id VARCHAR(255)             NOT NULL,
  item_id    VARCHAR(255)             NOT NULL,
  syncFlag   INT
);

DROP TABLE IF EXISTS Mouth;
CREATE TABLE Mouth
(
  id              VARCHAR(255) PRIMARY KEY NOT NULL,
  deleteFlag      INT                      NOT NULL,
  number          INT                      NOT NULL,
  numberInCabinet INT                      NOT NULL,
  overduePrice    BIGINT                   NOT NULL,
  status          VARCHAR(255),
  syncFlag        INT,
  usePrice        BIGINT                   NOT NULL,
  box_id          VARCHAR(255)             NOT NULL,
  cabinet_id      VARCHAR(255)             NOT NULL,
  express_id      VARCHAR(255),
  mouthType_id    VARCHAR(255)             NOT NULL,
  openOrder       INT
);
DROP TABLE IF EXISTS MouthType;
CREATE TABLE MouthType
(
  id                  VARCHAR(255) PRIMARY KEY NOT NULL,
  defaultOverduePrice BIGINT                   NOT NULL,
  defaultUsePrice     BIGINT                   NOT NULL,
  name                VARCHAR(255)             NOT NULL,
  deleteFlag          INT
);
DROP TABLE IF EXISTS Alert;
CREATE TABLE Alert
(
  id          VARCHAR(255) PRIMARY KEY NOT NULL,
  alertType   VARCHAR(255)             NOT NULL,
  box_id      VARCHAR(255)             NOT NULL,
  operator_id VARCHAR(255)             NOT NULL,
  createTime  BIGINT                   NOT NULL,
  alertStatus VARCHAR(255)             NOT NULL,
  value_id    VARCHAR(255),
  syncFlag    INT                      NOT NULL,
  alertvalue  VARCHAR(255)             NOT NULL
);
DROP TABLE IF EXISTS Activity;
CREATE TABLE Activity
(
  id             VARCHAR(255) PRIMARY KEY NOT NULL,
  activityType   VARCHAR(255),
  chargeType     VARCHAR(255),
  firstHeavy     BIGINT,
  firstPrice     BIGINT,
  continuedHeavy BIGINT,
  continuedPrice BIGINT,
  startTime      BIGINT,
  endTime        BIGINT,
  payOfAmount    BIGINT,
  position       BIGINT,
  box_id         VARCHAR(255)
);
DROP TABLE IF EXISTS TransactionRecord;
CREATE TABLE TransactionRecord
(
  id              VARCHAR(255) PRIMARY KEY NOT NULL,
  amount          BIGINT,
  createTime      BIGINT,
  paymentType     VARCHAR(255),
  transactionType VARCHAR(255),
  express_id      VARCHAR(255),
  mouth_id        VARCHAR(255)
);
DROP TABLE IF EXISTS Download;
CREATE TABLE Download
(
  id         VARCHAR(255) PRIMARY KEY NOT NULL,
  deleteFlag INT                      NOT NULL,
  url        VARCHAR(255),
  filename   VARCHAR(255),
  position   BIGINT,
  version    VARCHAR(255),
  status     BIGINT,
  type       VARCHAR(255),
  startTime  BIGINT,
  endTime    BIGINT,
  MD5        VARCHAR(255),
  flagTime   BIGINT,
  initFlag   INT
);

CREATE UNIQUE INDEX UK_dr2kya9pdulgpd4bgw8nuhwcg ON Box (name);
CREATE UNIQUE INDEX UK_itq51i9x3mlbgor90wxgqhoy8 ON Box (orderNo);
CREATE UNIQUE INDEX UK_7jxprbacypavkjykkaesjm9cp ON Company (name);
CREATE INDEX FK_k0q1oxj3os8acfcfpfcsp3kse ON Company (parentCompany_id);
CREATE INDEX FK_qlkikayvbymtes0pjkj32829g ON Mouth (cabinet_id);
CREATE UNIQUE INDEX UK_66ojrpd72bvdbnoh3b0feisso ON MouthType (name);
CREATE INDEX FK_h3vypb16nkqlkh7r1e4o6p4vl ON TransactionRecord (express_id);
