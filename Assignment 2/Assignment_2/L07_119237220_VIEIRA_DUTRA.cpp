#include <iostream>
#include <iomanip>
#include <occi.h>

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;

int main(void)
{
    /* OCCI Variables */
    Environment* env = nullptr;
    Connection* conn = nullptr;
    /* Used Variables */
    string user = "dbs211_231naa32";
    string pass = "98662218";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";
    try {
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);
        cout << "Connection is Successful!" << endl;
        Statement* stmt = conn->createStatement();

    //  stmt->setSQL("CREATE TABLE student (s_id NUMBER(4), name VARCHAR(40))");
   //   stmt->executeUpdate();
    //  stmt->setSQL("INSERT INTO student VALUES(10, 'sARAH STONE')");
    //  stmt->executeQuery();
        
       /* stmt->setSQL("INSERT INTO student VALUES(:1, :2)");
        stmt->setInt(1, 30);
        stmt->setString(2, "john");
        stmt->executeUpdate();
        stmt->setInt(1, 40);
        stmt->setString(2, "mary");
        stmt->executeUpdate();*/
        

       // stmt->setSQL("DELETE FROM student");
       // stmt->executeUpdate();

        stmt->setSQL("SELECT e.employeenumber,"
                             "e.firstname,"
                             "e.lastname,"
                             " o.phone,"
                             "e.extension"
                     "FROM dbs211_employees e "
                     "LEFT JOIN dbs211_offices o  "
                     "ON e.officecode = o.officecode"
                     "WHERE LOWER(o.city) = 'san francisco' ");

        ResultSet* rs = stmt->executeQuery();
        //The above 2 lines can be simplified to ResultSet* rs = stmt->executeQuery("SELECT * FROM student");
        if (!rs->next())
        {
            cout << "There is no rows to display";
       }
        else
        {
            for (int i = 0; i < 25; i++)
                cout << '-';
            
            cout << " Report 1 (Employee Report) ";

            for (int i = 0; i < 35; i++)
                 cout << '-';
            
            cout << endl;

            cout << "Employee ID   First Name         Last Name          Phone             Extension" << endl;
            cout << "------------  -----------------  -----------------  ----------------  ---------" << endl;
            do {
                int empID = rs->getInt(1);
                string fName = rs->getString(2);
                string lName = rs->getString(3);
                string phone = rs->getString(4);
                string extension = rs->getString(5);

                cout << left << setw(14) << empID;
                cout << left << setw(19) << fName;
                cout << left << setw(19) << lName;
                cout << left << setw(18) << phone;
                cout << extension;
                cout << endl;
            } while (rs->next());
        }


        SELECT e.employeenumber,
            e.firstname,
            e.lastname,
            o.phone,
            e.extension
            FROM dbs211_employees e
            JOIN dbs211_offices o
            ON e.officecode = o.officecode
            WHERE e.employeenumber IN(
                SELECT DISTINCT reportsto
                FROM dbs211_employees
            )
            ORDER BY e.employeenumber;


        //UPDATE NAME OF STUDENT 10 TO Tina
     //   stmt->setSQL("UPDATE student SET name = 'Tina' WHERE s_id = 10");
       // stmt->executeUpdate();


        //DROP THE TABLE
        /*
        stmt->setSQL("drop table student");
        stmt->executeUpdate();
        */


        //Terminate a statement before closing the connection 
            conn->terminateStatement(stmt);

        /*========================FINISH THE STATEMENT QUERY========================*/


        env->terminateConnection(conn);
        Environment::terminateEnvironment(env);
    }
    catch (SQLException& sqlExcp) {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
    }
    return 0;
}
