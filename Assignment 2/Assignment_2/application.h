#pragma once

#include <iostream>
#include <occi.h>
#include <string>

using oracle::occi::Environment;
using oracle::occi::Connection;
using namespace oracle::occi;

void displayOrderStatus(Connection* conn, int orderId, int customerId);
void cancelOrder(Connection* conn, int orderId, int customerId);
int mainMenu();
int subMenu();
int customerLogin(Connection* conn, int customerId);
int addToCart(Connection* conn, struct ShoppingCart cart[]);
double findProduct(Connection* conn, int productId);
void displayProducts(struct ShoppingCart cart[], int productCount);
int checkout(Connection* conn, struct ShoppingCart cart[], int customerId, int productCount);