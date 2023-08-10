#include <iostream>
#include <iomanip>
#include <occi.h>
#include "application.h"

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
    int menuInput{ 1 };
    int customerId{};
    bool customerFound{};
    int subMenuInput{};
    int orderId{};
    ShoppingCart* cart{};
    // *** Remove
    int temp{};
    /* OCCI Variables */
    Environment* env = nullptr;
    Connection* conn = nullptr;
    /* Used Variables */
    string user = "dbs311_232ncc36";
    string pass = "Bemvindo$";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

    // Attempt to stablish a connection
    try 
    {
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);
        cout << "Connection is Successful!" << endl;

        while (menuInput != 0 || customerFound == 0)
        {
            int input = mainMenu();
            if (input == 1)
            {
                std::cout << "Enter the customer ID: ";
                std::cin >> customerId;
                customerFound = customerLogin(conn, customerId);
            }

            if (customerFound)
            {
                subMenuInput = subMenu();
                switch (subMenuInput)
                {
                case 0:
                    {
                        if (cart)
                        {
                            delete[] cart;
                            cart = nullptr;
                        }
                    }
                    break;

                case 1:
                    temp = addToCart(conn, cart);
                    break;
                case 2:
                {
                    std::cout << "Enter an Order ID: ";
                    std::cin >> orderId;
                    displayOrderStatus(conn, orderId, customerId);
                }
                break;

                case 3:
                {
                    std::cout << "Enter an Order ID: ";
                    std::cin >> orderId;
                    cancelOrder(conn, orderId, customerId);
                }
                break;
                }
            }
        }

        /*========================FINISH THE STATEMENT QUERY========================*/
        env->terminateConnection(conn);
        Environment::terminateEnvironment(env);
    }
    catch (SQLException& sqlExcp) 
    {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
    }
}
