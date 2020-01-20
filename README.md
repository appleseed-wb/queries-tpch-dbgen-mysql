# queries-tpch-dbgen-mysql
TPC-H MySQL基准测试

解压缩TPC-H_Tools_v2.18.0.zip，并进入2.18.0_rc2/dbgen目录
```
$ cd 2.18.0_rc2/dbgen
```  

复制 makefile  
```
$ cp makefile.suite makefile
```  

修改 makefile 文件，设置编译器、数据库类型为MySQL和操作系统等
```
################
## CHANGE NAME OF ANSI COMPILER HERE
################
CC      = gcc
# Current values for DATABASE are: INFORMIX, DB2, TDAT (Teradata)
#                                  SQLSERVER, SYBASE, ORACLE, VECTORWISE
# Current values for MACHINE are:  ATT, DOS, HP, IBM, ICL, MVS, 
#                                  SGI, SUN, U2200, VMS, LINUX, WIN32 
# Current values for WORKLOAD are:  TPCH
DATABASE = MYSQL
MACHINE = LINUX
WORKLOAD = TPCH
#
...
```  

dbgen目录下的 *tpcd.h* 文件增加如下代码进行MySQL语法支持  
```
...
#ifdef MYSQL
#define GEN_QUERY_PLAN  ""
#define START_TRAN      "START TRANSACTION"
#define END_TRAN        "COMMIT"
#define SET_OUTPUT      ""
#define SET_ROWCOUNT    "limit %d;\n"
#define SET_DBASE       "use %s;\n"
#endif
...
```  

执行make命令，生成dbgen文件
```
$ make
```  

通过以下命令生成100MB的数据（0.1=100MB，1=1GB）
```
$ ./dbgen -s 0.1
```  

连接MySQL创建数据库
```
$ mysql -u root -p --local-infile
$ mysql> CREATE DATABASE tpch;
$ mysql> USE tpch;
```  

创建表  
```
CREATE TABLE NATION  ( N_NATIONKEY  INTEGER NOT NULL,
                            N_NAME       CHAR(25) NOT NULL,
                            N_REGIONKEY  INTEGER NOT NULL,
                            N_COMMENT    VARCHAR(152));

CREATE TABLE REGION  ( R_REGIONKEY  INTEGER NOT NULL,
                            R_NAME       CHAR(25) NOT NULL,
                            R_COMMENT    VARCHAR(152));

CREATE TABLE PART  ( P_PARTKEY     INTEGER NOT NULL,
                          P_NAME        VARCHAR(55) NOT NULL,
                          P_MFGR        CHAR(25) NOT NULL,
                          P_BRAND       CHAR(10) NOT NULL,
                          P_TYPE        VARCHAR(25) NOT NULL,
                          P_SIZE        INTEGER NOT NULL,
                          P_CONTAINER   CHAR(10) NOT NULL,
                          P_RETAILPRICE DECIMAL(15,2) NOT NULL,
                          P_COMMENT     VARCHAR(23) NOT NULL );

CREATE TABLE SUPPLIER ( S_SUPPKEY     INTEGER NOT NULL,
                             S_NAME        CHAR(25) NOT NULL,
                             S_ADDRESS     VARCHAR(40) NOT NULL,
                             S_NATIONKEY   INTEGER NOT NULL,
                             S_PHONE       CHAR(15) NOT NULL,
                             S_ACCTBAL     DECIMAL(15,2) NOT NULL,
                             S_COMMENT     VARCHAR(101) NOT NULL);

CREATE TABLE PARTSUPP ( PS_PARTKEY     INTEGER NOT NULL,
                             PS_SUPPKEY     INTEGER NOT NULL,
                             PS_AVAILQTY    INTEGER NOT NULL,
                             PS_SUPPLYCOST  DECIMAL(15,2)  NOT NULL,
                             PS_COMMENT     VARCHAR(199) NOT NULL );

CREATE TABLE CUSTOMER ( C_CUSTKEY     INTEGER NOT NULL,
                             C_NAME        VARCHAR(25) NOT NULL,
                             C_ADDRESS     VARCHAR(40) NOT NULL,
                             C_NATIONKEY   INTEGER NOT NULL,
                             C_PHONE       CHAR(15) NOT NULL,
                             C_ACCTBAL     DECIMAL(15,2)   NOT NULL,
                             C_MKTSEGMENT  CHAR(10) NOT NULL,
                             C_COMMENT     VARCHAR(117) NOT NULL);

CREATE TABLE ORDERS  ( O_ORDERKEY       INTEGER NOT NULL,
                           O_CUSTKEY        INTEGER NOT NULL,
                           O_ORDERSTATUS    CHAR(1) NOT NULL,
                           O_TOTALPRICE     DECIMAL(15,2) NOT NULL,
                           O_ORDERDATE      DATE NOT NULL,
                           O_ORDERPRIORITY  CHAR(15) NOT NULL,  
                           O_CLERK          CHAR(15) NOT NULL, 
                           O_SHIPPRIORITY   INTEGER NOT NULL,
                           O_COMMENT        VARCHAR(79) NOT NULL);

CREATE TABLE LINEITEM ( L_ORDERKEY    INTEGER NOT NULL,
                             L_PARTKEY     INTEGER NOT NULL,
                             L_SUPPKEY     INTEGER NOT NULL,
                             L_LINENUMBER  INTEGER NOT NULL,
                             L_QUANTITY    DECIMAL(15,2) NOT NULL,
                             L_EXTENDEDPRICE  DECIMAL(15,2) NOT NULL,
                             L_DISCOUNT    DECIMAL(15,2) NOT NULL,
                             L_TAX         DECIMAL(15,2) NOT NULL,
                             L_RETURNFLAG  CHAR(1) NOT NULL,
                             L_LINESTATUS  CHAR(1) NOT NULL,
                             L_SHIPDATE    DATE NOT NULL,
                             L_COMMITDATE  DATE NOT NULL,
                             L_RECEIPTDATE DATE NOT NULL,
                             L_SHIPINSTRUCT CHAR(25) NOT NULL,
                             L_SHIPMODE     CHAR(10) NOT NULL,
                             L_COMMENT      VARCHAR(44) NOT NULL);
```  

加载tbl数据到数据库，也可以通过navicat导入向导导入
```
LOAD DATA LOCAL INFILE 'customer.tbl' INTO TABLE CUSTOMER FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'orders.tbl' INTO TABLE ORDERS FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'lineitem.tbl' INTO TABLE LINEITEM FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'nation.tbl' INTO TABLE NATION FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'partsupp.tbl' INTO TABLE PARTSUPP FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'part.tbl' INTO TABLE PART FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'region.tbl' INTO TABLE REGION FIELDS TERMINATED BY '|';
LOAD DATA LOCAL INFILE 'supplier.tbl' INTO TABLE SUPPLIER FIELDS TERMINATED BY '|';
```  

增加主外键
```
ALTER TABLE REGION
ADD PRIMARY KEY (R_REGIONKEY);
ALTER TABLE NATION
ADD PRIMARY KEY (N_NATIONKEY);
ALTER TABLE NATION
ADD FOREIGN KEY NATION_FK1 (N_REGIONKEY) references REGION(R_REGIONKEY);
ALTER TABLE PART
ADD PRIMARY KEY (P_PARTKEY);
ALTER TABLE SUPPLIER  
ADD PRIMARY KEY (S_SUPPKEY);
ALTER TABLE SUPPLIER
ADD FOREIGN KEY SUPPLIER_FK1 (S_NATIONKEY) references NATION(N_NATIONKEY);
ALTER TABLE PARTSUPP
ADD PRIMARY KEY (PS_PARTKEY,PS_SUPPKEY);
ALTER TABLE CUSTOMER
ADD PRIMARY KEY (C_CUSTKEY);
ALTER TABLE CUSTOMER
ADD FOREIGN KEY CUSTOMER_FK1 (C_NATIONKEY) references NATION(N_NATIONKEY);
ALTER TABLE LINEITEM
ADD PRIMARY KEY (L_ORDERKEY,L_LINENUMBER);
ALTER TABLE PARTSUPP
ADD FOREIGN KEY PARTSUPP_FK1 (PS_SUPPKEY) references SUPPLIER(S_SUPPKEY);
ALTER TABLE PARTSUPP
ADD FOREIGN KEY PARTSUPP_FK2 (PS_PARTKEY) references PART(P_PARTKEY);
ALTER TABLE ORDERS
ADD FOREIGN KEY ORDERS_FK1 (O_CUSTKEY) references CUSTOMER(C_CUSTKEY);
ALTER TABLE LINEITEM
ADD FOREIGN KEY LINEITEM_FK1 (L_ORDERKEY)  references ORDERS(O_ORDERKEY);
ALTER TABLE LINEITEM
ADD FOREIGN KEY LINEITEM_FK2 (L_PARTKEY,L_SUPPKEY) references PARTSUPP(PS_PARTKEY, PS_SUPPKEY);
``` 

可以进行测试了