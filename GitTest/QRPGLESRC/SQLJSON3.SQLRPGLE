000100000000      **********************************************************************************************
000200000000      *
000300000000      *     Program.....:  SQLJSON3
000400000000      *
000500000000      *     Function....: JSON med SQL Exempel 3
000600000000      *
000700000000      *     Created.....: 2018-10-31 / Pdb, BE
000800000000      *
000900000000      *     Last changed: 2018-10-31 / Pdb, BE
001000000000      *
001100000000      **********************************************************************************************
001200000000
001300000000     H Debug DatEdit(*ymd)
001400000000     H Option(*NoDebugIO:*SrcStmt)
001500000000     H Dftactgrp(*No) Bnddir('QC2LE')
001600000000
001700000000      // Prototypes
001800000000
001900000000     D ExecCmd         PR            10i 0 Extproc('system')
002000000000     D  CmdString                      *   Options(*String) Value
002100000000
002200000000      // Data structures
002300000000
002400000000     D DsEmp           DS                  Qualified Dim(100)
002500000000     D  Employee                      6  0
002600000000     D  FirstName                    50A
002700000000     D  LastName                     50A
002800000000     D  Department                    3A
002900000000     D  Phone                        20A
003000000000
003100000000      // Variables
003200000000
003300000000     D SqlSuccess      C                   '00000'
003400000000     D SqlNoData       C                   '02000'
003500000000     D JSONData        S                   Sqltype(CLOB:100000) CCSID(*UTF8)
003600000000     D InFile          S                   Sqltype(CLOB_FILE)
003700000000     D FileName        S            100A   Inz('/pdbbe/summit/JSONFile1.json')
003800000000     D                                     Varying
003900000000     D Ix              S              3  0
004000000000     D Rows            S             10I 0
004100000000     D Employee        S              6  0
004200000000     D Name            S             50A
004300000000     D Department      S              3A
004400000000     D Phone           S             20A
004500000000
004600000000         Exec Sql
004700000000           Set Option COMMIT = *NONE,
004800000000                      DATFMT = *ISO,
004900000000                      DATSEP = '-';
005000000000
005100000000         InFile_Name = %Trim(FileName);
005200000000         InFile_NL = %Len(%Trim(FileName));
005300000000         InFile_FO = SQFRD;
005400000000
005500000000         Exec Sql
005600000000           Declare Emp Cursor For
005700000000           SELECT X.*
005800000000           FROM JSON_TABLE(:InFile, '$.Employees[*]'
005900000000           COLUMNS(
006000000000                   EMPNUM NUMERIC(6) PATH '$.EmployeeNumber',
006100000000                   FNAME CHAR(50)  PATH '$.FirstName',
006200000000                   LNAME CHAR(50)  PATH '$.LastName',
006300000000                   DEPT CHAR(3)  PATH '$.Department',
006400000000                   PHONE CHAR(20) PATH '$.Phone'
006500000000           )) AS X;
006600000000
006700000000         Exec Sql
006800000000           Open Emp;
006900000000
007000000000         Exec Sql
007100000000           Fetch From Emp For 100 Rows Into :DsEmp;
007200000000
007300000000         Rows = SqlERRD(3);
007400000000
007500000000         If SqlStt = SqlSuccess;
007600000000         EndIf;
007700000000
007800000000         For Ix = 1 to Rows;
007900000000           Employee = DsEmp(Ix).Employee;
008000000000           Name = %Trim(DsEmp(Ix).FirstName) + ' ' + %Trim(DsEmp(Ix).LastName);
008100000000           Department = DsEmp(Ix).Department;
008200000000           Phone = DsEmp(Ix).Phone;
008300000000           Exec Sql
008400000000             Insert Into SUMMIT/EMPFILE
008500000000             Values (:Employee,
008600000000                     :Name,
008700000000                     :Department,
008800000000                     :Phone);
008900000000         EndFor;
009000000000
009100000000         Exec Sql
009200000000           Close Emp;
009300000000
009400000000          *InLR = *On;
