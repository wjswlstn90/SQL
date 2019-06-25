        SELECT 
                QTY.ORD_DT          ����
              , CASE
                    WHEN GROUPING(QTY.ORD_DT) = 0 THEN QTY.ORD_DT
                    WHEN GROUPING(QTY.ORD_DT) = 1 THEN SUBSTR(:st_dt,1,6)
                END     ORD_DT
              , QTY.ITEM_ID          ��ǰID
              , IT.ITEM_NM          ��ǰ��
              , CASE
                    WHEN GROUPING(QTY.ORD_DT) = 0 AND GROUPING(IT.ITEM_NM) = 0 THEN IT.ITEM_NM
                    WHEN GROUPING(QTY.ORD_DT) = 0 AND GROUPING(IT.ITEM_NM) = 1 THEN '�Ұ�'
                    WHEN GROUPING(QTY.ORD_DT) = 1 AND GROUPING(IT.ITEM_NM) = 1 THEN '�հ�'
                END     ITEM_NM
              , GROUPING(QTY.ORD_DT)    X
              , GROUPING(IT.ITEM_NM)       Y
              , SUM(QTY.ORD_ITEM_QTY)    �Ǹż���
              , SUM(QTY.SALE_AMT)     �Ǹűݾ�   
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
                            )   PRICE -- ��ǰ���� ���̺�, �ǸŰ�
                    WHERE   ORD_DT  BETWEEN :st_dt AND :ed_dt
                    AND     PRICE.ITEM_ID = OI.ITEM_ID
                    GROUP BY
                            OI.ORD_DT
                          , OI.ITEM_ID                                        
                )   QTY -- �Ǹż���, �ݾ�
        WHERE   1 = 1
        AND     QTY.ITEM_ID = IT.ITEM_ID   
        GROUP BY ROLLUP(
                QTY.ORD_DT
              , (QTY.ITEM_ID
              ,  IT.ITEM_NM
                )
                
                /*
                CASE 1 �Ұ踸 ���ϱ�
                QTY.ORD_DT
              , ROLLUP(
               (QTY.ITEM_ID
              , IT.ITEM_NM)
                */
                
                /*
                CASE 2 �հ踸 ���ϱ�
                (QTY.ORD_DT
              , QTY.ITEM_ID
              , IT.ITEM_NM
                )
                */
                
                /*
                CASE 3 �Ұ� �հ� ���ϱ�                
                QTY.ORD_DT
              , (QTY.ITEM_ID
              , IT.ITEM_NM
                )
                */
              )
        ORDER BY   
                QTY.ORD_DT, QTY.ITEM_ID
;

