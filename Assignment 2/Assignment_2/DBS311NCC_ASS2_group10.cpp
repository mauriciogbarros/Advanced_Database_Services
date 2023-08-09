#include <iostream>
#include <iomanip>
#include <occi.h>

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;

struct ShoppingCart {
    int product_id;
    double price;
    int quantity;
};


int main(void)
{
    /* OCCI Variables */
    Environment* env = nullptr;
    Connection* conn = nullptr;
    /* Used Variables */
    string user = "dbs311_232ncc36";
    string pass = "";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";
    try {
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);

        cout << "Connection is Successful!" << endl;
        Statement* stmt = conn->createStatement();

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
