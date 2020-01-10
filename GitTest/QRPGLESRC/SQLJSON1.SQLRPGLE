000100000000      **********************************************************************************************
000200000000      *
000300000000      *     Program.....:  SQLJSON1
000400000000      *
000500000000      *     Function....: JSON med SQL Exempel 1
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
002400000000     D DsVal           DS                  Qualified
002500000000     D  Customer                      9A
002600000000     D  Order                        10S 0
002700000000     D  Value                        15S 2
002800000000
002900000000      // Variables
003000000000
003100000000     D SqlSuccess      C                   '00000'
003200000000     D SqlNoData       C                   '02000'
003300000000     D JSONData        S                   Sqltype(CLOB:100000) CCSID(*UTF8)
003400000000     D Data            S                   Sqltype(CLOB:100000) CCSID(*UTF8)
003500000000     D OutFile         S                   Sqltype(CLOB_FILE)
003600000000     D FileName        S            100A   Inz('/pdbbe/summit/JSONFile1.json')
003700000000     D                                     Varying
003800000000
003900000000         Exec Sql
004000000000           Set Option COMMIT = *NONE,
004100000000                      DATFMT = *ISO,
004200000000                      DATSEP = '-';
004300000000
004400000000         Exec Sql
004500000000           Select JSON_OBJECT('Employees' Value
004600000000                          JSON_ARRAYAGG(
004700000000                          JSON_OBJECT(
004800000000                          'EmployeeNumber' Value EMPNO,
004900000000                          'FirstName' Value FIRSTNME,
005000000000                          'LastName' Value LASTNAME,
005100000000                          'Department' Value WORKDEPT,
005200000000                          'Phone' Value PHONENO
005300000000                          )))
005400000000                          Into :JSONData
005500000000                          From SAMPLEDB/EMPLOYEE;
005600000000
005700000000         If SqlStt = SqlSuccess;
005800000000         EndIf;
005900000000
006000000000         Clear OutFile;
006100000000         OutFile_Name = %Trim(FileName);
006200000000         OutFile_NL = %Len(%Trim(OutFile_Name));
006300000000         OutFile_FO = SQFCRT;
006400000000
006500000000         Exec Sql
006600000000           Set :OutFile = :JSONData;
006700000000
006800000000          *InLR = *On;
