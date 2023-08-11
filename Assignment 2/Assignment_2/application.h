#pragma once

#include <iostream>
#include <occi.h>
#include <string>

#define MAX_ITEMS 5

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;

struct ShoppingCart
{
    int product_id{};
    double price{};
    int quantity{};
};

extern int cartSize;

void displayOrderStatus(Connection* conn, int orderId, int customerId);
void cancelOrder(Connection* conn, int orderId, int customerId);
int mainMenu();
int subMenu();
int customerLogin(Connection* conn, int customerId);
int addToCart(Connection* conn, struct ShoppingCart cart[]);
double findProduct(Connection* conn, int productId);
void displayProducts(struct ShoppingCart cart[], int productCount);
int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount);

/*
* PL/SQL Stored Procedures
* 1) find_customer(customer_id IN NUMBER, found OUT NUMBER)
* 2) find_product(productId IN NUMBER,
*                   price OUT products.list_price%type,
*                   productName OUT products.product_name%type)
* 3) add_order (customer_id IN NUMBER, new_order_id OUT NUMBER)
* 4) generate_order_id() => called from (3)
* 5) add_order_item(orderId IN order_items.order_id%type,
*                       itemId IN order_items.item_id%type,
*                       productId IN order_items.product_id%type,
*                       quantity IN order_items.quantity%type,
*                       price IN order_items.unit_price%type)
* 6) customer_order(customerId IN NUMBER, orderId IN OUT NUMBER)
* 7) display_order_status(orderId IN NUMBER, status OUT order.status%type)
* 8) cancel_order(orderId IN NUMBER, cancelStataus OUT NUMBER)
*/