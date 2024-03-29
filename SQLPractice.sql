/**/
        SELECT  
                QTY.ORD_DT          일자
              , CASE
                    WHEN GROUPING(QTY.ORD_DT) = 0 THEN QTY.ORD_DT
                    WHEN GROUPING(QTY.ORD_DT) = 1 THEN SUBSTR(:st_dt,1,6)
                END     ORD_DT
              , QTY.ITEM_ID          상품ID
              , IT.ITEM_NM          상품명
              , CASE
                    WHEN GROUPING(QTY.ORD_DT) = 0 AND GROUPING(IT.ITEM_NM) = 0 THEN IT.ITEM_NM
                    WHEN GROUPING(QTY.ORD_DT) = 0 AND GROUPING(IT.ITEM_NM) = 1 THEN '소계'
                    WHEN GROUPING(QTY.ORD_DT) = 1 AND GROUPING(IT.ITEM_NM) = 1 THEN '합계'
                END     ITEM_NM
              , GROUPING(QTY.ORD_DT)    X
              , GROUPING(IT.ITEM_NM)    Y              
              , SUM(QTY.ORD_ITEM_QTY)    판매수량
              , SUM(QTY.SALE_AMT)     판매금액
              , CASE
                    WHEN GROUPING(QTY.ORD_DT) = 0 AND GROUPING(IT.ITEM_NM) = 0
                    THEN RANK() OVER(PARTITION BY QTY.ORD_DT, GROUPING(IT.ITEM_NM) ORDER BY SUM(QTY.ORD_ITEM_QTY) DESC)
                    ELSE NULL
                END     RANK_EA
              , CASE
                    WHEN GROUPING(QTY.ORD_DT) = 0 AND GROUPING(IT.ITEM_NM) = 0
                    THEN RANK() OVER(PARTITION BY QTY.ORD_DT, GROUPING(IT.ITEM_NM) ORDER BY SUM(QTY.SALE_AMT) DESC)
                    ELSE NULL
                END     RANK_AMT
              /*
              , CASE
                    WHEN GROUPING(QTY.ORD_DT) = 0 AND GROUPING(IT.ITEM_NM) = 0 THEN RANK() OVER(PARTITION BY QTY.ORD_DT ORDER BY SUM(QTY.ORD_ITEM_QTY) DESC)
                    ELSE NULL
                END     RANK_EA
                */
        FROM    ITEM    IT
              , (
                    SELECT  
                            OI.ORD_DT
                          , OI.ITEM_ID
                          , SUM(OI.ORD_ITEM_QTY) AS ORD_ITEM_QTY
                          , SUM(OI.ORD_ITEM_QTY * SALE_PRICE) AS SALE_AMT
                    FROM    ORD_ITEM OI
                          , (
                                SELECT 
                                        ITEM_ID
                                      , SUM(SALE_PRICE) AS SALE_PRICE
                                FROM    UITEM_PRICE
                                GROUP BY
                                        ITEM_ID                            
                            )   PRICE -- 단품가격 테이블, 판매가
                    WHERE   ORD_DT  BETWEEN :st_dt AND :ed_dt
                    AND     PRICE.ITEM_ID = OI.ITEM_ID
                    GROUP BY
                            OI.ORD_DT
                          , OI.ITEM_ID
                )   QTY -- 판매수량, 금액
        WHERE   1 = 1
        AND     QTY.ITEM_ID = IT.ITEM_ID
        GROUP BY ROLLUP(
                QTY.ORD_DT
              , (QTY.ITEM_ID
              ,  IT.ITEM_NM
                )
                
                /*
                CASE 1 소계만 구하기
                QTY.ORD_DT
              , ROLLUP(
               (QTY.ITEM_ID
              , IT.ITEM_NM)
                */
                
                /*
                CASE 2 합계만 구하기
                (QTY.ORD_DT
              , QTY.ITEM_ID
              , IT.ITEM_NM
                )
                */
                
                /*
                CASE 3 소계 합계 구하기                
                QTY.ORD_DT
              , (QTY.ITEM_ID
              , IT.ITEM_NM
                )
                */
                
              
              )
        ORDER BY   
                QTY.ORD_DT, QTY.ITEM_ID, RANK_EA
;

UPDATE  []
	SET     [] = 'N'
	      , [] = 80000
        WHERE   [] = #{id,jdbcType=INTEGER}
   
   //두개의 테이블에서 하나의 컬럼으로 합치기
 SELECT     CF.[ID]
	  , 0 [CATEID]
	  , CF.[NAME]		SCR_NM
	  , CF.[NAME]
	  , CF.[SEQ]
	  , 0 [SEQ2]
	  , CF.[DISP_YN]
	  , CF.[NOTE]
	  , CF.[HOPTION]
FROM	[]	CF
UNION ALL
SELECT	C.[CFID]
	  , C.[CATEID]
	  , '      ' + C.[NAME]	SCR_NM
	  , C.[NAME]
	  , CF.[SEQ]
	  , C.[SEQ]	SEQ2
	  , C.[DISP_YN]
	  , ''
	  , C.[HOPTION]
FROM	[] C
	  , [] CF
WHERE	1 = 1
AND		C.[CFID] = CF.[ID]
AND		C.[HOPTION] NOT IN (80000)
AND		CF.[HOPTION] NOT IN (80000)
--ORDER BY ID, CATEID
ORDER BY [SEQ], [SEQ2]


/* 계층형 질의 */

/*매니저로부터 자신의 하위 사원을 찾는 순방향 전개*/
SELECT
        LEVEL
      , LPAD(' ', 4*(LEVEL-1)) || EMPNO
      , MGR
      , CONNECT_BY_ISLEAF ISLEAF
FROM    EMP
START WITH MGR IS NULL
CONNECT BY PRIOR EMPNO = MGR;

/*사원으로부터 자신의 상위 관리자를 찾는 역방향 전개*/
SELECT
        LEVEL
      , LPAD(' ', 4*(LEVEL-1)) || EMPNO
      , MGR
      , CONNECT_BY_ISLEAF ISLEAF
FROM    EMP
START WITH EMPNO = '7788'
CONNECT BY EMPNO = PRIOR MGR ;

SELECT
	MGR
      , ENAME
      , SAL
      , MAX(SAL) OVER(PARTITION BY MGR) MGR_MAX
FROM	EMP
		     
