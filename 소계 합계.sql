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
              , GROUPING(IT.ITEM_NM)       Y
              , SUM(QTY.ORD_ITEM_QTY)    판매수량
              , SUM(QTY.SALE_AMT)     판매금액   
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
                QTY.ORD_DT, QTY.ITEM_ID
;

