/* �Ѵ޺з� �Ǹż��� �� �Ǹűݾ� ��� */
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
              , SUM(QTY.ORD_ITEM_QTY * PRICE.SALE_PRICE)     �Ǹűݾ�   
        FROM    ITEM    IT
              , (
                    SELECT  
                            OI.ORD_DT
                          , OI.ITEM_ID
                          , SUM(OI.ORD_ITEM_QTY) AS ORD_ITEM_QTY
                    FROM    ORD_ITEM OI
                    WHERE   ORD_DT  BETWEEN :st_dt AND :ed_dt
                    GROUP BY
                            OI.ORD_DT
                          , OI.ITEM_ID                                        
                )   QTY -- �Ǹż���, �ݾ�
              , (
                    SELECT 
                            ITEM_ID
                          , SUM(SALE_PRICE) AS SALE_PRICE
                    FROM    UITEM_PRICE
                    GROUP BY
                            ITEM_ID                            
                )   PRICE -- ��ǰ���� ���̺�, �ǸŰ�
        WHERE   1 = 1
        AND     QTY.ITEM_ID = IT.ITEM_ID   
        AND     PRICE.ITEM_ID = QTY.ITEM_ID
        GROUP BY ROLLUP(
                QTY.ORD_DT
              , (QTY.ITEM_ID
              , IT.ITEM_NM)
              )
        ORDER BY   
                QTY.ORD_DT, QTY.ITEM_ID
;

        
/*        
SELECT  *
FROM    (
            SELECT
                    CASE
                        WHEN ITEM_NM IS NOT NULL
                            THEN    CASE
                                        WHEN ITEM_NM LIKE '%����%'
                                            THEN ITEM_NM
                                    END
                    END ITEM_NM
            FROM    ITEM
        )
WHERE   ITEM_NM IS NOT NULL;



WHERE   ITEM_NM IS NOT NULL AND ITEM_NM LIKE '%����%'
*/
