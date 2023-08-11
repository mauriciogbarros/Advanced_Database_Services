#include <iostream>
#include <iomanip>
#include <occi.h>
#include "application.h"

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;
using namespace std;

int main(void)
{
    bool customerFound{ true };
    bool cartCheckout{ false };
    size_t menuInput{ 1 };
    size_t customerId{};
    size_t subMenuInput{};
    size_t orderId{};
    size_t nItems{};
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
                    while (!cartCheckout)
                    {
                        subMenuInput = subMenu();
                        switch (subMenuInput)
                        {
                        case 0:
                            cartCheckout = true;
                            break;

                        case 1:
                            {
                                nItems = addToCart(conn, cart);
                                displayProducts(cart, nItems);
                                cartCheckout = checkout(conn, cart, customerId, nItems);
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
                    }
                    for (int i = 0; i < nItems; i++)
                        cart[i] = ShoppingCart();
                    cartCheckout = false;
                }
                else
                    std::cout << "The customer does not exist.\n";
            }
        }
        std::cout << "Good bye...!\n";

        /*========================FINISH THE STATEMENT QUERY========================*/
        env->terminateConnection(conn);
        Environment::terminateEnvironment(env);
    }
    catch (SQLException& sqlExcp) 
    {
        cout << sqlExcp.getErrorCode() << ": " << sqlExcp.getMessage();
    }
}
