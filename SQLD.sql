--P9 조인
SELECT
       E.DEPTNO
      , D.DEPTNO
      , D.DNAME
FROM   
        EMP E
      , DEPT D
WHERE   1 = 1
AND     E.DEPTNO = D.DEPTNO
AND     E.DEPTNO = 30
;


-- P14 조인 ON 조건절(WHERE로 대체)
SELECT
        P.PLAYER_NAME   선수명
      , P.POSITION      포지션
      , T.REGION_NAME   연고지명
      , T.TEAM_NAME     팀명
      , S.STADIUM_NAME  구장명
FROM
        PLAYER P
      , TEAM T
      , STADIUM S
WHERE   1 = 1
AND     P.TEAM_ID = T.TEAM_ID
AND     T.STADIUM_ID = S.STADIUM_ID
AND     P.POSITION = 'GK'
ORDER   BY 선수명
;
-- 조인조건과 같음 T.STADIUM_ID = S.STADIUM_ID

-- P15 조인 홈팀이 3점 이상 차이로 승리한 경기의 경기장 이름, 경기 일정, 홈팀 이름과 원정팀 이름 정보를 출력
SELECT
        ST.STADIUM_NAME
      , SC.STADIUM_ID
      , SCHE_DATE
      , HT.TEAM_NAME
      , AT.TEAM_NAME
      , HOME_SCORE
      , AWAY_SCORE
FROM
        SCHEDULE SC
JOIN    STADIUM  ST
ON      SC.STADIUM_ID  = ST.STADIUM_ID
JOIN    TEAM     HT
ON      SC.HOMETEAM_ID = HT.TEAM_ID
JOIN    TEAM     AT
ON      SC.AWAYTEAM_ID = AT.TEAM_ID
WHERE   HOME_SCORE >= AWAY_SCORE + 3
;


/* P17 LEFT OUTER JOIN STADIUM에 등록된 운동장 정보를 출력(운동장이름과 운동장의 소속팀을 출력)
   오른쪽 테이블에 정보가 없으면 NULL출력 */
SELECT
        STADIUM_NAME
      , STADIUM.STADIUM_ID
      , SEAT_COUNT
      , HOMETEAM_ID
      , TEAM_NAME
FROM    STADIUM
LEFT OUTER JOIN TEAM
ON      STADIUM.HOMETEAM_ID = TEAM.TEAM_ID
ORDER BY
        HOMETEAM_ID
;        
/* P18 RIGHT OUTER JOIN
   DEPT에 등록된 부서 중에는 사원이 없는 부서도 있다 -> 15번 ENAME값에 null*/
SELECT
        E.ENAME
      , D.DEPTNO
      , D.DNAME
      , D.LOC
FROM    EMP E RIGHT OUTER JOIN DEPT D
ON      E.DEPTNO = D.DEPTNO
;
/* P19 FULL OUTER JOIN
   DEPTNO 기준으로 DEPT와 DEPT_TEMP 데이터를 FULL OUTER JOIN으로 출력 ;;실행안됨*/   
SELECT  *
FROM    DEPT FULL OUTER JOIN DEPT_TEMP
ON      DEPT.DEPTNO = DEPT_TEMP.DEPTNO
;

/* P38 단일 행 서브 쿼리 
   정남일 선수가 소속된 팀 선수 정보를 표시 
   PLAYER_ID, PLAYER_NAME, TEAM_ID, E_PLAYER_NAME, NICKNAME, JOIN_YYYY, POSITION, BACK_NO, NATION, BIRTH_DATE, SOLAR, HEIGHT, WEIGHT
*/
   
SELECT
        PLAYER_NAME
      , POSITION
      , BACK_NO
FROM    PLAYER
WHERE   TEAM_ID = (
                    SELECT  TEAM_ID
                    FROM    PLAYER
                    WHERE   PLAYER_NAME = '정남일'
                  )
ORDER BY
        PLAYER_NAME
;

/* P39 단일 행 서브 쿼리
   평균 이하의 키를 가지고 있는 선수 정보를 출력하는 쿼리
*/
SELECT
        PLAYER_NAME
      , POSITION
      , BACK_NO
      , HEIGHT
FROM    PLAYER
WHERE   HEIGHT <= (
                    SELECT AVG(HEIGHT)
                    FROM   PLAYER
                  )
ORDER BY
        PLAYER_NAME
;

/* P40 다중 행 서브 쿼리
   IN        서브쿼리 결과에 존재하는 임의의 값과 동일한 조건 (OR조건 있다면 해당 조건 출력)
   ALL       서브쿼리 결과값들 모두를 만족하는 조건 (AND조건)
   ANY, SOME 서브쿼리 결과값 중 한개라도 만족하는 조건 (OR조건)
   EXISTS    서브쿼리 결과를 만족하는 값이 존재하는지 (있다면 전부 출력)
   선수들 중에서 '정현수'선수가 소속되어 있는 팀 정보를 출력
*/
--where in( select) 부분 참고
SELECT
        REGION_NAME
      , TEAM_NAME
      , E_TEAM_NAME
FROM    TEAM
WHERE   TEAM_ID IN(
                    SELECT  TEAM_ID
                    FROM    PLAYER
                    WHERE   PLAYER_NAME = '정현수'
                  )
ORDER BY
        TEAM_NAME
;

/*P3 ROLLUP 일반적인 GROUP BY*/
SELECT * FROM EMP, DEPT;

SELECT
        DNAME
      , JOB
      , COUNT(*) "TOTAL EMPL"
      , SUM(SAL) "TOTAL SAL"
FROM    EMP, DEPT
WHERE   DEPT.DEPTNO = EMP.DEPTNO
GROUP BY DNAME, JOB
;

/*P3 ROLLUP GROUP BY + ORDER BY*/
SELECT
        DNAME
      , JOB
      , COUNT(*) "TOTAL EMPL"
      , SUM(SAL) "TOTAL SAL"
FROM    EMP, DEPT
WHERE   DEPT.DEPTNO = EMP.DEPTNO
GROUP BY DNAME, JOB
ORDER BY DNAME, JOB
;

/*P4 ROLLUP GROUP BY 안에 ROLLUP*/
SELECT
        DNAME
      , JOB
      , COUNT(*) "TOTAL EMPL"
      , SUM(SAL) "TOTAL SAL"
FROM    EMP, DEPT
WHERE   DEPT.DEPTNO = EMP.DEPTNO
GROUP BY ROLLUP(DNAME, JOB)
;
--ORDER BY
SELECT
        DNAME
      , JOB
      , COUNT(*) "TOTAL EMPL"
      , SUM(SAL) "TOTAL SAL"
FROM    EMP, DEPT
WHERE   DEPT.DEPTNO = EMP.DEPTNO
GROUP BY ROLLUP(DNAME, JOB)
ORDER BY DNAME, JOB
;

/*P5 GROUPING, ROLLUP*/
SELECT
        DNAME
      , GROUPING(DNAME)
      , JOB
      , GROUPING(JOB)
      , COUNT(*) "TOTAL EMPL"
      , SUM(SAL) "TOTAL SAL"
FROM    EMP, DEPT
WHERE   DEPT.DEPTNO = EMP.DEPTNO
GROUP BY ROLLUP(DNAME, JOB)
;

/*P6 GROUPING, CASE, ROLLUP*/
SELECT
        CASE GROUPING(DNAME) WHEN 1 THEN 'ALL DEPARTMENTS' ELSE DNAME END AS DNAME
      , CASE GROUPING(JOB)   WHEN 1 THEN 'ALL JOBS' ELSE JOB END AS JOB
      , COUNT(*) "TOTAL EMPL"
      , SUM(SAL) "TOTAL SAL"
FROM    EMP, DEPT
WHERE   DEPT.DEPTNO = EMP.DEPTNO
GROUP BY ROLLUP(DNAME, JOB)
;

/*P7 ROLLUP 함수 일부 사용 ; GROUPING(DNAME)이 작동하지 않는 상황*/
SELECT
        CASE GROUPING(DNAME) WHEN 1 THEN 'ALL DEPARTMENTS' ELSE DNAME END AS DNAME
      , CASE GROUPING(JOB)   WHEN 1 THEN 'ALL JOBS' ELSE JOB END AS JOB
      , COUNT(*) "TOTAL EMPL"
      , SUM(SAL) "TOTAL SAL"
FROM    EMP, DEPT
WHERE   DEPT.DEPTNO = EMP.DEPTNO
GROUP BY DNAME ,ROLLUP(JOB)
;

/*P7 ROLLUP 함수 결합 컬럼 사용*/
SELECT
        DNAME
      , JOB
      , MGR
      , SUM(SAL) "TOTAL SAL"
      , GROUPING(JOB)
      , GROUPING(MGR)
FROM    EMP
      , DEPT
WHERE   DEPT.DEPTNO = EMP.DEPTNO
GROUP BY
ROLLUP (DNAME
      ,(JOB, MGR)
       )
;
/*시간 함수*/
SELECT SYSTIMESTAMP FROM DUAL;

/* P15 WINDOW FUNCTION RANK함수
   사원 데이터에서 급여가 높은 순서와 JOB별로 급여가 높은 순서를 같이 출력
*/
SELECT
        JOB
      , ENAME
      , SAL
      , RANK() OVER(ORDER BY SAL DESC) ALL_RANK
      , RANK() OVER(PARTITION BY JOB ORDER BY SAL DESC) JOB_RANK
FROM EMP
;

/* P16 DENSE_RANK
   사원 데이터에서 급여가 높은 순서와, 동일한 순위를 하나의 등수로 간주한 결과도 같이 출력한다.
*/
SELECT
        JOB
      , ENAME
      , SAL
      , RANK() OVER(ORDER BY SAL DESC) RANK --공동 2위일경우 3위는 표기하지 않고 4위로 넘어감
      , DENSE_RANK() OVER(ORDER BY SAL DESC) DENSE_RANK --공동 2위일 경우 3위를 표기함
FROM    EMP
;

/* P16 ROW_NUMBER
   사원데이터에서 급여가 높은 순서와, 동일한 순위를 인정하지 않는 등수도 같이 출력한다.
*/
SELECT
        JOB
      , ENAME
      , SAL
      , RANK() OVER(ORDER BY SAL DESC) RANK
      , ROW_NUMBER() OVER(ORDER BY SAL DESC) ROW_NUMBER -- 공동순위를 무시하고 출력
FROM    EMP
;

/* P17
   사원들의 급여와 같은 매니저를 두고 있는 사원들의 SALARY 합을 구한다.
*/
SELECT
        MGR
      , ENAME
      , SAL
      , SUM(SAL) OVER(PARTITION BY MGR) MGR_SUM
FROM    EMP
;

SELECT
        E.MGR        
      , E.ENAME
      , E.SAL
      , SMGR.MGR_SUM
FROM    EMP E
      , (
            SELECT  
                    MGR
                  , SUM(SAL) MGR_SUM
            FROM    EMP
            GROUP BY 
                    MGR
        )   SMGR
WHERE   SMGR.MGR = E.MGR
ORDER BY
        MGR
;

/* SUM OVER 윈도우함수관련(합계) */
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER(ORDER BY deptno, empno 
                ROWS BETWEEN UNBOUNDED PRECEDING 
                         AND UNBOUNDED FOLLOWING) sal1,
       SUM(sal) OVER(ORDER BY deptno, empno 
                ROWS BETWEEN UNBOUNDED PRECEDING 
                         AND CURRENT ROW) sal2,
       SUM(sal) OVER(ORDER BY deptno, empno 
                ROWS BETWEEN CURRENT ROW 
                         AND UNBOUNDED FOLLOWING) sal3
FROM emp
;
-- SAL1 : 첫 번째 ROW부터 마지막 ROW까지의 급여 합계이다. 
-- SAL2 : 첫 번째 ROW 부터 현재 ROW까지의 급여 합계이다. 
-- SAL3 : 현재 ROW부터 마지막 ROW까지 급여 합계이다.


SELECT mgr, ename, sal,
       sum(sal) over(partition by sal order by sal rows between unbounded preceding and current row) mgr_sum
from emp
;
select ename, sal, count(*) over(order by sal range between 50 preceding and 150 following) sim
from emp
 
SELECT
    CASE GROUPING(DNAME) WHEN 1 THEN 'All Departments' ELSE DNAME END AS DNAME,
    CASE GROUPING(JOB) WHEN 1 TEHN 'All Jobs' ELSE JOB END AS JOB,
    COUNT(*) "Total Empl",
    SUM(SAL) "Total Sal"
FROM EMP, DEPT
WHERE DEPT.DEPTNO = EMP.DEPTNO
GROUP BY CUBE(DNAME,JOB);


SELECT
       DNAME
     , JOB
     , COUNT(*) "TOTAL EMPL"
     , SUM(SAL) "TOTAL SAL"
FROM   EMP, DEPT
WHERE  DEPT.DEPTNO = EMP.EPTNO
GROUP  BY DNAME, JOB
ORDER  BY DNAME, JOB

SELECT, INSERT, DELETE, UPDATE
CREATE, DROP, ALTER

SELECT LEVEL
     , A.*
FROM FAM A
START WITH A.FATHER_NAME IS NULL
CONNECT BY A.FATHER_NAME = PRIOR A.NAME;
