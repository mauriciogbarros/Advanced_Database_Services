#include <iostream>
#include <iomanip>
#include <occi.h>
#include "Orders.h"

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;

struct ShoppingCart 
{
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
    string pass = "Bemvindo$";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";


    try 
    {
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);

        cout << "Connection is Successful!" << endl;

        displayOrderStatus(conn, 903, 17);
        //Terminate a statement before closing the connection 

        /*========================FINISH THE STATEMENT QUERY========================*/
        env->terminateConnection(conn);
        Environment::terminateEnvironment(env);
    }
    catch (SQLException& sqlExcp) 
    {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
    }
}
