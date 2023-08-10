#include <iostream>
#include <iomanip>
#include <occi.h>
#include "application.h"

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;

#define MAX_ITEMS 5

int main(void)
{
    bool customerFound{ true };
    bool goToCheckout{};
    size_t menuInput{ 1 };
    size_t customerId{};
    size_t subMenuInput{};
    size_t orderId{};
    size_t n_items{};
    ShoppingCart cart[MAX_ITEMS] = {};
    size_t shoppingCartSize{};

    /* OCCI Variables */
    Environment* env = nullptr;
    Connection* conn = nullptr;

    /* Used Variables */
    string user = "dbs311_232ncc36";
    string pass = "Bem";
    string constr = "myoracle12c.senecacollege.ca:1521/oracle12c";

    // Attempt to stablish a connection
    try 
    {
        env = Environment::createEnvironment(Environment::DEFAULT);
        conn = env->createConnection(user, pass, constr);
        cout << "Connection is Successful!" << endl;

        while (menuInput != 0)
        {
            menuInput = mainMenu();
            if (menuInput == 1)
            {
                std::cout << "Enter the customer ID: ";
                std::cin >> customerId;
                customerFound = customerLogin(conn, customerId);
                if (customerFound)
                {
                    subMenuInput = subMenu();
                    switch (subMenuInput)
                    {
                    case 0:
                    {
                    }
                    break;

                    case 1:
                    {
                        n_items = addToCart(conn, cart);
                        displayProducts(cart, n_items);
                        goToCheckout = checkout(conn, cart, customerId, n_items);
                    }
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

                    /*
                    * If the user enters "N/n", the function checkout terminates and returns 0.
                    * If the user enters "Y/y", call procedure add_order()
                    * ... see the Assignment 2 docx.
                    * 
                    * This is how I figured out how to use the return from checkout.
                    * Feel free to change the logic if you think otherwise.
                    */
                    if (goToCheckout)
                    {

                        customerFound = false;
                    }
                }
                else
                    std::cout << "The customer does not exist.\n";
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
